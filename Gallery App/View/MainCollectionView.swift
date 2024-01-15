//
//  CollectionView.swift
//  Gallery App
//
//  Created by Vitali Vyucheiski on 1/14/24.
//

import UIKit

class MainCollectionView: UIViewController {
    var viewModel: MainViewModel?

    let collectionView: UICollectionView = {
        let cellSize = 200
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(
            PhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier
        )

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()

        viewModel = MainViewModel()
        viewModel?.viewVC = self
        viewModel?.updateViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        viewModel?.loadData()
    }

    func setUpView() {
        setUpNavBarItems()

        title = "Photo Stream"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white

        view.backgroundColor = .black

        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setUpNavBarItems() {
        let showLiked = UIBarButtonItem(
            image: UIImage(systemName: viewModel?.displayLikedPhotos ?? false ? "heart" : "heart.fill"),
            style: .plain,
            target: self,
            action: #selector(showLiked))
        showLiked.tintColor = .label
        navigationItem.rightBarButtonItems = [showLiked]
    }

    @objc func showLiked() {
        viewModel?.showLikedPhotos()
        setUpNavBarItems()
    }
}

extension MainCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photosDisplayedRN.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoCollectionViewCell.identifier,
            for: indexPath
        // swiftlint:disable:next force_cast
        ) as! PhotoCollectionViewCell

        guard let model = viewModel?.photosDisplayedRN[indexPath.item] else { return cell }
        cell.model = model
        cell.likeButton.likeTapped = { [weak self] in
            self?.viewModel?.likeTapped(photoID: model.id)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = viewModel?.photosDisplayedRN[indexPath.item] else { return }

        let newVC = PhotoDetailView()
        newVC.model = model
        newVC.likeButton.likeTapped = { [weak self] in
            self?.viewModel?.likeTapped(photoID: model.id)
        }
        navigationController?.pushViewController(newVC, animated: true)
    }
}

extension MainCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let model = viewModel?.photosDisplayedRN[indexPath.row] else { return CGSize(width: 100, height: 100) }
        let photoAspectRation = model.height / model.width
        let screenWidth = UIScreen.main.bounds.width
        let cellHeight = screenWidth * CGFloat(photoAspectRation)
        return CGSize(width: screenWidth, height: cellHeight)
    }
}

extension MainCollectionView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (collectionView.contentSize.height - scrollView.frame.size.height - 500) {
            viewModel?.loadMoreData()
        }
    }
}
