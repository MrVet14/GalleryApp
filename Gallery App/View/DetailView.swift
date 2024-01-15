//
//  DetailView.swift
//  Gallery App
//
//  Created by Vitali Vyucheiski on 1/14/24.
//

import UIKit

class PhotoDetailView: UIViewController {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    var spinner = UIActivityIndicatorView(style: .large)

    let descriptionView = UIView()
    let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    let createdAtLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .white.withAlphaComponent(0.8)
        label.numberOfLines = 1
        return label
    }()

    let likeButton = LikeButtonView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavBarItems()
        setUpView()
    }

    func setUpView() {
        view.backgroundColor = .black
        view.addSubview(imageView)
        view.addSubview(spinner)
        view.addSubview(descriptionView)
        descriptionView.addSubview(authorLabel)
        descriptionView.addSubview(descriptionLabel)
        descriptionView.addSubview(createdAtLabel)
        view.addSubview(likeButton)

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.center.equalToSuperview()
        }
        spinner.snp.makeConstraints { make in
            make.center.equalTo(imageView)
        }
        spinner.startAnimating()
        spinner.hidesWhenStopped = true

        descriptionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(50)
        }

        authorLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(descriptionView)
            make.trailing.equalTo(likeButton.snp.leading).offset(-5)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(2)
            make.leading.trailing.equalTo(authorLabel)
        }

        createdAtLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom)
            make.leading.trailing.equalTo(descriptionLabel)
            make.bottom.equalTo(descriptionView)
        }

        likeButton.snp.makeConstraints { make in
            make.trailing.equalTo(descriptionView)
            make.centerY.equalTo(descriptionView)
            make.width.height.equalTo(20)
        }
    }

    func setUpNavBarItems() {
        let share = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(shareImage))

        navigationItem.rightBarButtonItems = [share]
    }

    var model: Any? {
        didSet {
            guard let model = model as? PhotoModel else { return }

            let photoURL = URL(string: model.urls.full)
            imageView.kf.setImage(with: photoURL, options: [.transition(.fade(0.5))]) { result in
                switch result {
                // swiftlint:disable:next empty_enum_arguments
                case .success(_):
                    self.spinner.stopAnimating()

                case .failure(let error):
                    print("Error: \(error)")
                    self.showAlert()
                }
            }
            authorLabel.text = "Author: \(model.user.name)"
            descriptionLabel.text = model.description
            createdAtLabel.text = "Created at: \(model.createdAt)"
            likeButton.model = RealmDBManager.shared.isLiked(model.id)
        }
    }

    @objc func shareImage() {
        let items = [imageView.image]
        let activityController = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
        present(activityController, animated: true)
    }

    func showAlert() {
        let alert = UIAlertController(
            title: "Something went wrong",
            message: "Try again later",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Close", style: .cancel))
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }
}
