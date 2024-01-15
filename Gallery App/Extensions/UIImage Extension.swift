//
//  UIImage Extension.swift
//  Gallery App
//
//  Created by Vitali Vyucheiski on 1/15/24.
//

import UIKit

extension UIImage {
    func imageWith(newSize: CGSize) -> UIImage {
        let image = UIGraphicsImageRenderer(size: newSize).image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }

        return image.withRenderingMode(renderingMode)
    }
}
