//
//  ImageCell.swift
//  MemoryBook
//
//  Created by gisu kim on 2018-02-02.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

//protocol ImageCellDelegate : class {
//    func handleImageClicked(imageView : UIImageView)
//}

class ImageCell: UICollectionViewCell {
//    weak var imageCellDelegate : ImageCellDelegate?
    var mainViewController : MainViewController?
    var imageUrl : String?
    
    lazy var imageView : UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .clear
        imgView.isUserInteractionEnabled = true
        imgView.contentMode = .scaleToFill
        imgView.layer.opacity = 0.8
        imgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageClicked)))
        
        return imgView
    }()
    
    @objc func handleImageClicked(tapGesture: UITapGestureRecognizer) {
        if let imageView = tapGesture.view as? UIImageView, let imageUrl = self.imageUrl {
            self.mainViewController?.handleImageClicked(imageView: imageView, imageUrl: imageUrl)
        }
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? CustomizedLayoutAttributes {
            imageViewHeightLayoutConstraint = imageView.heightAnchor.constraint(equalToConstant: attributes.imageHeight)
        }
    }
    
    var imageViewHeightLayoutConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        [
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ].forEach{ $0.isActive = true }
        
        imageViewHeightLayoutConstraint = imageView.heightAnchor.constraint(equalTo: self.heightAnchor)
        imageViewHeightLayoutConstraint?.isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
