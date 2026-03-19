//
//  GalleryDetailsCell.swift
//  gallery-app
//
//  Created by Pavel Playerz0redd on 10.12.25.
//

import UIKit

final class GalleryDetailsCell: UICollectionViewCell {
    
    static let reuseId: String = "detailsCell"
    
    private var imageLoadTask: Task<Void, Never>?
    private var onLike: (() -> Void)?
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let usernameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let likesLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        likeButton.addTarget(self, action: #selector(likeAction), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageLoadTask?.cancel()
    }
    
    private func configureLabel(label: UILabel, text: String?, font: UIFont) {
        label.text = text
        label.textColor = .black
        label.font = font
    }
    
    private func configureButton(isLiked: Bool) {
        let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .medium, scale: .default)
        let image = UIImage(systemName: isLiked ? "heart.fill" : "heart", withConfiguration: config)
        likeButton.setImage(image, for: .normal)
        likeButton.tintColor = isLiked ? .red : .black
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
        username: String?,
        likeAmount: Int?,
        description: String?,
        isLiked: Bool,
        imageTask: @escaping () async -> UIImage?,
        onLike: @escaping () -> Void
    ) {
        self.onLike = onLike
        configureButton(isLiked: isLiked)
        
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
        
        imageLoadTask = Task { @MainActor in
            let image = await imageTask()
            if !Task.isCancelled {
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
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topImageOffset),
            imageView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            usernameLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: Constants.labelsTrailingLimit),
            usernameLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: Constants.labelVerticalSpacing),
            
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            likeButton.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: Constants.bottomImageOffset),
            likeButton.heightAnchor.constraint(equalToConstant: Constants.iconSize),
            likeButton.widthAnchor.constraint(equalToConstant: Constants.iconSize),
            
            likesLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: Constants.iconVerticalSpacing),
            likesLabel.centerXAnchor.constraint(equalTo: likeButton.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: Constants.bottomImageOffset),
            descriptionLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: Constants.labelsTrailingLimit),
        ])
    }
}

private extension GalleryDetailsCell {
    
    enum Constants {
        static let topImageOffset: CGFloat = -60
        static let bottomImageOffset: CGFloat = -25
        static let iconSize: CGFloat = 30
        static let padding: CGFloat = 15
        static let labelsTrailingLimit: CGFloat = -60
        static let labelVerticalSpacing: CGFloat = -5
        static let iconVerticalSpacing: CGFloat = 3
    }
    
}
