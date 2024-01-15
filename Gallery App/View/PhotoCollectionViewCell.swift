//
//  CollectionViewCell.swift
//  Gallery App
//
//  Created by Vitali Vyucheiski on 1/14/24.
//

import Kingfisher
import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "PhotoCollectionViewCell"

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let likeButton = LikeButtonView(frame: .zero)

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 1
        label.textColor = .white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.contentMode = .scaleAspectFill
        contentView.clipsToBounds = true

        contentView.addSubview(imageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(nameLabel)

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        likeButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(10)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var model: Any? {
        didSet {
            guard let model = model as? PhotoModel else { return }

            let photoURL = URL(string: model.urls.small)
            imageView.kf.setImage(with: photoURL, options: [.transition(.fade(0.1))])
            nameLabel.text = model.user.name
            likeButton.model = RealmDBManager.shared.isLiked(model.id)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
        nameLabel.text = nil
        likeButton.button.setImage(UIImage(systemName: "heart"), for: .normal)
    }
}
