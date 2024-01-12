//
//  URLSessonNetworkManager.swift
//  Gallery App
//
//  Created by Vitali Vyucheiski on 1/12/24.
//

import Foundation

class URLSessonNetworkManager {
    static let shared = URLSessonNetworkManager()

    func fetchPhotos() async throws -> Data {
        let session = URLSession.shared

        var request = URLRequest(url: URL(string: "https://api.unsplash.com/photos/?client_id=zuQbME8fxNsaYVs8ti9o2BeNfvl5I21VMb5h43CmPFs")!)
        request.httpMethod = "GET"

        do {
            let (data, _) = try await session.data(for: request)

            return data
        } catch {
            throw NetworkError.requestFailed
        }
    }
}
