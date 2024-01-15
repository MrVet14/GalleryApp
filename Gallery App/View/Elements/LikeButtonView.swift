//
//  LikeButtonView.swift
//  Gallery App
//
//  Created by Vitali Vyucheiski on 1/14/24.
//

import SnapKit
import UIKit

class LikeButtonView: UIView {
    let button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .white
        return button
    }()
    var isLiked = false

    var model: Any? {
        didSet {
            guard let photoID = model as? String else { return }

            self.isLiked = RealmDBManager.shared.isLiked(photoID)
            updateLikeStatus()
        }
    }

    var likeTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(button)

        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        button.addAction { [weak self] in
            self?.likeTapped?()
            self?.isLiked.toggle()
            self?.updateLikeStatus()
        }
    }

    func updateLikeStatus() {
        if isLiked {
            button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            button.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
