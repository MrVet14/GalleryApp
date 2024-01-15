//
//  PhotoDBModel.swift
//  Gallery App
//
//  Created by Vitali Vyucheiski on 1/14/24.
//

import Foundation
import RealmSwift

class PhotoDBObject: Object {
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var createdAt: String = ""
    @Persisted var width: Float = 0
    @Persisted var height: Float = 0
    @Persisted var desc: String?
    @Persisted var fullURL: String = ""
    @Persisted var smallURL: String = ""
    @Persisted var userName: String = ""
    @Persisted var isLiked = false
}
