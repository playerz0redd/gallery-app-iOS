//
//  GalleryDetailsCell.swift
//  gallery-app
//
//  Created by Pavel Playerz0redd on 10.12.25.
//

import UIKit

final class GalleryDetailsCell: UICollectionViewCell {
    
    static let reuseId: String = "detailsCell"
    private var photoService: PhotoService?
    
    private var imageUrl: String?
    private var isLiked: Bool?
    
    private var onLike: (() -> Void)?
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let usernameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let likesLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let descriptionLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureLabel(label: UILabel, text: String?, font: UIFont) {
        label.text = text
        label.textColor = .black
        label.font = font
    }
    
    private func configureButton() {
        if let isLiked = self.isLiked {
            likeButton.contentHorizontalAlignment = .center
            likeButton.contentVerticalAlignment = .center
            let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .medium, scale: .default)
            let image = UIImage(systemName: isLiked ? "heart.fill" : "heart", withConfiguration: config)
            likeButton.contentHorizontalAlignment = .center
            likeButton.contentVerticalAlignment = .center
            likeButton.imageView?.contentMode = .scaleAspectFit
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = isLiked ? .red : .black
            likeButton.addTarget(self, action: #selector(likeAction), for: .touchUpInside)
        }
    }
    
    @objc private func likeAction() {
        self.onLike?()
        
        UIView.animate(withDuration: 0.1, animations: {
            self.likeButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.likeButton.transform = .identity
            }
        }
    }
    
    func configureCell(
        with imageUrl: String,
        username: String?,
        likeAmount: Int?,
        description: String?,
        isLiked: Bool,
        photoService: PhotoService,
        onLike: @escaping () -> Void
    ) {
        self.imageUrl = imageUrl
        self.isLiked = isLiked
        self.onLike = onLike
        configureButton()
        
        configureLabel(
            label: usernameLabel,
            text: "@\(username ?? "No username")",
            font: UIFont.systemFont(ofSize: 16, weight: .bold)
        )
        configureLabel(
            label: descriptionLabel,
            text: description ?? "No description",
            font: UIFont.systemFont(ofSize: 14, weight: .medium)
        )
        configureLabel(
            label: likesLabel,
            text: "\(likeAmount ?? 0)",
            font: UIFont.systemFont(ofSize: 14, weight: .bold)
        )
        
        configureCell(with: imageUrl, photoService: photoService)
    }
    
    private func configureCell(with url: String, photoService: PhotoService) {
        self.imageUrl = url
        self.photoService = photoService
        Task { @MainActor in
            let image = try await photoService.fetchPhoto(for: .downloadImage(url: url))
            
            if imageUrl == self.imageUrl {
                self.imageView.image = image
            }
        }
    
    }
    
    func setupLayout() {
        contentView.addSubview(imageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(likesLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(likeButton)
        contentView.backgroundColor = .systemBackground
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -60),
            imageView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            usernameLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -60),
            usernameLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -5),
            
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            likeButton.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: -25),
            likeButton.heightAnchor.constraint(equalToConstant: 30),
            likeButton.widthAnchor.constraint(equalToConstant: 30),
            
            likesLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 3),
            likesLabel.centerXAnchor.constraint(equalTo: likeButton.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            descriptionLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -60),
        ])
    }

}
