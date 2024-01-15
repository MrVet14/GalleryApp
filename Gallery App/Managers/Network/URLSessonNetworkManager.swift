//
//  URLSessonNetworkManager.swift
//  Gallery App
//
//  Created by Vitali Vyucheiski on 1/12/24.
//

import Foundation

class URLSessonNetworkManager {
    static let shared = URLSessonNetworkManager()

    func fetchPhotos(page: Int = 0, completion: @escaping (Result<[PhotoModel], Error>) -> Void) {
        let session = URLSession.shared

        let endpoint = "/photos"
        let parameters: [String: String] = [
            "client_id": Configuration.accessKey,
            "page": "\(page)", // page param for pagination
            "per_page": "30" // Amount of photos per peques
        ]

        do {
            let request = try makeURLRequest(endpoint: endpoint, parameters: parameters)
            let task = session.dataTask(with: request) { data, _, error in
                if let error {
                    completion(.failure(error))
                    return
                }

                guard let data else {
                    completion(.failure(NetworkError.requestFailed))
                    return
                }

                do {
                    let photos = try JSONDecoder().decode([PhotoModel].self, from: data)
                    completion(.success(photos))
                } catch {
                    completion(.failure(error))
                }
            }

            task.resume()
        } catch {
            completion(.failure(NetworkError.requestFailed))
        }
    }

    private func makeURLRequest(endpoint: String, method: String = "GET", headers: [String: String]? = nil, parameters: [String: String]? = nil) throws -> URLRequest {
        guard var components = URLComponents(string: Configuration.baseURL + endpoint) else {
            throw NetworkError.invalidURL
        }

        if let parameters = parameters {
            components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method

        if let headers = headers {
            for (key, value) in headers {
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }

        return urlRequest
    }
}
