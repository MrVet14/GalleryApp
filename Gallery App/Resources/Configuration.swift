//
//  Configuration.swift
//  Gallery App
//
//  Created by Vitali Vyucheiski on 1/12/24.
//

import Foundation

enum Configuration: String {
    case develop
    case production

    private static let current: Self = {
        guard let rawValue = Bundle.main.infoDictionary?["Configuration"] as? String else {
            fatalError("No Configuration Found")
        }

        guard let configuration = Self(rawValue: rawValue.lowercased()) else {
            fatalError("Invalid Configuration")
        }

        return configuration
    }()

    static var baseURL: URL {
        switch current {
        case .develop, .production: return URL(string: "")!
        }
    }

    static var accessKey: String {
        switch current {
        case .develop, .production: return "zuQbME8fxNsaYVs8ti9o2BeNfvl5I21VMb5h43CmPFs"
        }
    }

    static var secretKey: String {
        switch current {
        case .develop, .production: return "buxmx6JeTVbWGOzcMctn0XMbSOLjSPoK57TJcWyVz1g"
        }
    }
}
