//
//  ViewController.swift
//  Gallery App
//
//  Created by Vitali Vyucheiski on 1/10/24.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink

        Task {
            do {
                let data = try await URLSessonNetworkManager.shared.fetchPhotos()

                let photos = try JSONDecoder().decode([PhotoModel].self, from: data)
                print(photos)
            } catch {
                print("Error: ", error)
            }
        }
    }
}
