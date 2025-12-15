//
//  ViewController.swift
//  gallery-app
//
//  Created by Pavel Playerz0redd on 9.12.25.
//

import UIKit

class GalleryViewController: UIViewController {
    
    private let viewModel: GalleryViewModel
    
    init(viewModel: GalleryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy private var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        collection.register(GalleryCell.self, forCellWithReuseIdentifier: GalleryCell.reuseId)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()

    override func viewDidLoad() {
        Task { @MainActor in
            super.viewDidLoad()
            bindViewModel()
            bindErrorAction()
            viewModel.fetchPhotoModelPage()
            view.backgroundColor = .systemBackground
            setupCollectionView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.photoModels.removeAll()
        viewModel.fetchPhotoModelPage()
        viewModel.changePhotoPage(to: 1)
        collection.reloadData()
    }
    
    private func bindErrorAction() {
        viewModel.onError = { [weak self] errorMessage in
            self?.showAler(title: "An error occured :(", message: errorMessage)
        }
    }
    
    private func bindViewModel() {
        viewModel.onDataFetch = { [weak self] newIndexPaths in
            
            if let first = newIndexPaths.first, first.item == 0 {
                self?.collection.reloadData()
            } else {
                self?.collection.performBatchUpdates({
                    self?.collection.insertItems(at: newIndexPaths)
                }, completion: nil)
            }
        }
    }
    
    func setupCollectionView() {
        view.addSubview(collection)
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: view.topAnchor),
            
            collection.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: GalleryViewController.spacing
            ),
            
            collection.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -GalleryViewController.spacing
            ),
            collection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if indexPath.item == viewModel.photoModels.count - 20 {
            viewModel.fetchPhotoModelPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vm = GalleryPhotoDetailsViewModel(
            photoService: viewModel.getPhotoService(),
            photoModels: viewModel.photoModels) { [weak self] index, action in
                guard let self = self else { return }
                onAction(index: index, action: action, self: self)
        }
        let detailsViewController = GalleryPhotoDetailsViewController(
            viewModel: vm,
            currentImageIndex: indexPath.row
        )
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    private func onAction(
        index: Int,
        action: GalleryPhotoDetailsViewModel.Action,
        self: GalleryViewController
    ) {
        guard (0..<self.viewModel.photoModels.count).contains(index) else { return }
        switch action {
        case .like:
            self.viewModel.photoModels[index].isLiked = true
            self.viewModel.photoModels[index].likes += 1
        case .dislike:
            self.viewModel.photoModels[index].isLiked = false
            self.viewModel.photoModels[index].likes -= 1
        }
    }
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    
    private static let spacing: CGFloat = 10
    private static let photosPerRow: CGFloat = 3
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = (GalleryViewController.photosPerRow - 1) * GalleryViewController.spacing
        let size = floor((collectionView.frame.width - totalSpacing) / GalleryViewController.photosPerRow)
        return .init(width: size, height: size)
    }
    
}

extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.photoModels.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GalleryCell.reuseId,
            for: indexPath
        ) as? GalleryCell else { return .init() }
        
        cell.configureCell(with: viewModel.photoModels[indexPath.item].photoUrls.thumb, photoService: viewModel.getPhotoService())
        return cell
    }
    
    
}

