//
//  GalleryPhotoDetailsViewController.swift
//  gallery-app
//
//  Created by Pavel Playerz0redd on 10.12.25.
//

import UIKit

final class GalleryPhotoDetailsViewController: UIViewController {
    
    private let viewModel: GalleryPhotoDetailsViewModel
    private var currentImageIndex: Int
    private var isFirstLayout = true
    
    init(viewModel: GalleryPhotoDetailsViewModel, currentImageIndex: Int) {
        self.viewModel = viewModel
        self.currentImageIndex = currentImageIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy private var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = .init()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let collection: UICollectionView = .init(frame: .zero, collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        collection.register(GalleryDetailsCell.self, forCellWithReuseIdentifier: GalleryDetailsCell.reuseId)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Details"
        bindViewModel()
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
    }
    
    
}

extension GalleryPhotoDetailsViewController {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if indexPath.item == viewModel.photoModels.count - 5 {
            viewModel.changePhotoPage(to: viewModel.getNextPage(photoIndex: indexPath.item))
            viewModel.fetchPhotoModelPage()
        }
    }
}

extension GalleryPhotoDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.frame.size
    }
}

extension GalleryPhotoDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.photoModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GalleryDetailsCell.reuseId,
            for: indexPath
        ) as? GalleryDetailsCell else {
            return .init()
        }
        let model = viewModel.photoModels[indexPath.item]
        cell.configureCell(
            with: viewModel.photoModels[indexPath.item].photoUrls.regular,
            username: viewModel.photoModels[indexPath.item].user.instagramUsername,
            likeAmount: viewModel.photoModels[indexPath.item].likes, description:
            viewModel.photoModels[indexPath.item].description,
            isLiked: model.isLiked ?? false, photoService: viewModel.getPhotoService()) { [weak self] in
            guard let self = self else { return }
            
            self.viewModel.changeButtonState(at: indexPath.item)
            
            self.collectionView.reloadItems(at: [indexPath])
            
        }
        return cell
    }
    
    
}





