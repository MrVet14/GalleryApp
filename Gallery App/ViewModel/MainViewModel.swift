//
//  ViewController.swift
//  Gallery App
//
//  Created by Vitali Vyucheiski on 1/10/24.
//

import UIKit

class MainViewModel: UIViewController {
    var viewVC: MainCollectionView?

    var displayLikedPhotos = false {
        didSet {
            if displayLikedPhotos {
                likedPhotosToDisplay = RealmDBManager.shared.getLikedPhotos()
                viewVC?.title = "Liked Photos"
                photosDisplayedRN = likedPhotosToDisplay
            } else {
                viewVC?.title = "Photo Stream"
                photosDisplayedRN = allPhotosToDisplay
            }
            viewVC?.navigationController?.navigationBar.prefersLargeTitles = !displayLikedPhotos
            updateViewClosure?()
        }
    }
    var allPhotosToDisplay: [PhotoModel] = []
    var likedPhotosToDisplay: [PhotoModel] = []
    var photosDisplayedRN: [PhotoModel] = []

    var currentPage = 0
    var isLoadingData = false

    var updateViewClosure: (() -> Void)?

    func loadData() {
        isLoadingData = true

        URLSessonNetworkManager.shared.fetchPhotos { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let photos):
                RealmDBManager.shared.addPhotosToDB(photos)
                allPhotosToDisplay.append(contentsOf: photos)
                photosDisplayedRN = allPhotosToDisplay

            case .failure(let error):
                loadPhotosFromDB()
                showAlert()
                print(error)
            }

            updateViewClosure?()
            currentPage += 1
            isLoadingData = false
        }
    }

    func loadMoreData() {
        guard !isLoadingData && !displayLikedPhotos else { return }
        isLoadingData = true

        URLSessonNetworkManager.shared.fetchPhotos(page: currentPage) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let photos):
                RealmDBManager.shared.addPhotosToDB(photos)
                allPhotosToDisplay.append(contentsOf: photos)
                photosDisplayedRN.append(contentsOf: photos)

            case .failure(let error):
                showAlert()
                print(error)
            }

            updateViewClosure?()
            currentPage += 1
            isLoadingData = false
        }
    }

    func loadPhotosFromDB() {
        allPhotosToDisplay = RealmDBManager.shared.getAllPhotos()
        photosDisplayedRN = allPhotosToDisplay
    }

    func showLikedPhotos() {
        if !displayLikedPhotos {
            displayLikedPhotos = true
        } else {
            displayLikedPhotos = false
        }
    }

    func likeTapped(photoID: String) {
        RealmDBManager.shared.likeHandler(photoID)
    }

    func showAlert() {
        let alert = UIAlertController(
            title: "Something went wrong",
            message: "Some troubles with accessin internet, try again later.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Close", style: .cancel))
        DispatchQueue.main.async { [weak self] in
            self?.viewVC?.present(alert, animated: true)
        }
    }
}
