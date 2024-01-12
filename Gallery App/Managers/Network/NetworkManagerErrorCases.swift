//
//  NetworkManagerErrorCases.swift
//  Gallery App
//
//  Created by Vitali Vyucheiski on 1/12/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
}
