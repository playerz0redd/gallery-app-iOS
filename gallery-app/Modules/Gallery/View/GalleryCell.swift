//
//  GalleryCell.swift
//  gallery-app
//
//  Created by Pavel Playerz0redd on 10.12.25.
//

import UIKit

class GalleryCell: UICollectionViewCell {
    
    class var reuseId: String { "galleryCell" }
    
    private var imageLoadTask: Task<Void, Never>?
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 10
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        return image
    }()
    
    required init?(coder: NSCoder) { fatalError() }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        imageLoadTask?.cancel()
    }
    
    func configureCell(imageTask: @escaping () async -> UIImage?) {
        imageLoadTask = Task { @MainActor in
            let image = await imageTask()
            if !Task.isCancelled {
                self.imageView.image = image
            }
        }
    }
    
    private func setupLayout() {
        contentView.addSubview(imageView)
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
