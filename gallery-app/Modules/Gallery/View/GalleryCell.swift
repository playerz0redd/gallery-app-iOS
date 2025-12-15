//
//  GalleryCell.swift
//  gallery-app
//
//  Created by Pavel Playerz0redd on 10.12.25.
//

import UIKit


class GalleryCell: UICollectionViewCell {
    
    class var reuseId: String {
        "galleryCell"
    }
    
    private var photoService: PhotoService?
    private var imageUrl: String = ""
    
    lazy var imageView: UIImageView = {
        setupImageView()
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
}
