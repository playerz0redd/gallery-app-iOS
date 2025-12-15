//
//  GalleryDetailsCell.swift
//  gallery-app
//
//  Created by Pavel Playerz0redd on 10.12.25.
//

import UIKit

final class GalleryDetailsCell: GalleryCell {
    
    override class var reuseId: String {
        "detailsCell"
    }
    
    private var imageUrl: String?
    private var isLiked: Bool?
    
    private var onLike: (() -> Void)?
    
    lazy private var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy private var usernameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    lazy private var likesLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    lazy private var descriptionLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    override func setupImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

}
