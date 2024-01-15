//
//  RealmBDManager.swift
//  Gallery App
//
//  Created by Vitali Vyucheiski on 1/14/24.
//

import Foundation
import RealmSwift

class RealmDBManager {
    static let shared = RealmDBManager()

    func addPhotoToDB(_ photo: PhotoModel) {
        // swiftlint:disable:next force_try
        let realm = try! Realm()

        realm.beginWrite()

        let photoObject = PhotoDBObject()
        photoObject.id = photo.id
        photoObject.createdAt = photo.createdAt
        photoObject.width = photo.width
        photoObject.height = photo.height
        photoObject.desc = photo.description
        photoObject.fullURL = photo.urls.full
        photoObject.smallURL = photo.urls.small
        photoObject.userName = photo.user.name

        realm.add(photoObject)
        realmCommitWrite()
    }

    func addPhotosToDB(_ photos: [PhotoModel]) {
        for photo in photos where getPhotoObject(photo.id) == nil {
            addPhotoToDB(photo)
        }
    }

    func getAllPhotos() -> [PhotoModel] {
        // swiftlint:disable:next force_try
        let realm = try! Realm()

        let objects = realm.objects(PhotoDBObject.self)

        return converToPhotoModel(Array(objects))
    }

    func getLikedPhotos() -> [PhotoModel] {
        // swiftlint:disable:next force_try
        let realm = try! Realm()

        let objects = realm.objects(PhotoDBObject.self).where { $0.isLiked == true }

        return converToPhotoModel(Array(objects))
    }

    func deleteAllPhotoObjects() {
        // swiftlint:disable:next force_try
        let realm = try! Realm()

        realm.beginWrite()

        realm.delete(realm.objects(PhotoDBObject.self))
        print("Purged all photo objects")

        realmCommitWrite()
    }

    func isLiked(_ photoID: String) -> Bool {
        guard let photoObject = getPhotoObject(photoID) else {
            print("No Object present")
            return false
        }

        return photoObject.isLiked
    }

    func likeHandler(_ photoID: String) {
        // swiftlint:disable:next force_try
        let realm = try! Realm()

        guard let photoObject = getPhotoObject(photoID) else {
            print("No Object present")
            return
        }

        do {
            try realm.write {
                photoObject.isLiked.toggle()
            }
        } catch {
            print("Could not manage like action, error: \(error)")
        }
    }

    func getPhotoObject(_ photoID: String) -> PhotoDBObject? {
        // swiftlint:disable:next force_try
        let realm = try! Realm()

        return realm.object(ofType: PhotoDBObject.self, forPrimaryKey: photoID)
    }

    func realmCommitWrite() {
        // swiftlint:disable:next force_try
        let realm = try! Realm()

        do {
            try realm.commitWrite()
        } catch {
            print(error.localizedDescription)
        }
    }

    func converToPhotoModel(_ objects: [PhotoDBObject]) -> [PhotoModel] {
        objects.compactMap({
            PhotoModel(
                id: $0.id,
                createdAt: $0.createdAt,
                width: $0.width,
                height: $0.height,
                description: $0.desc,
                urls: PhotoURLs(
                    full: $0.fullURL,
                    small: $0.smallURL),
                user: PhotoUserProfile(
                    name: $0.userName),
                isLiked: $0.isLiked)
        })
    }
}
