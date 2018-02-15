//
//  CategoryImageCell.swift
//  MemoryBook
//
//  Created by gisu kim on 2018-02-08.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

class CategoryImageCell: UICollectionViewCell {
    
    var categoryCell : CategoryCell?
    
    lazy var cateogryView : UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .clear
        imgView.layer.cornerRadius = 30
        imgView.isUserInteractionEnabled = true
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.opacity = 0.8
        imgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCategoryClicked)))
        
        return imgView
    }()
    
    let categoryNameLabel : UILabel = {
        let nl = UILabel()
        nl.font = UIFont.boldSystemFont(ofSize: 25)
        nl.textAlignment = .right
        nl.textColor = .white
        
        return nl
    }()
    
    @objc func handleCategoryClicked() {
        self.categoryCell?.handleCategorySelected()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(cateogryView)
        cateogryView.translatesAutoresizingMaskIntoConstraints = false
        [
            cateogryView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cateogryView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            cateogryView.widthAnchor.constraint(equalTo: self.widthAnchor),
            cateogryView.heightAnchor.constraint(equalTo: self.heightAnchor)
            ].forEach{ $0.isActive = true}
        addSubview(categoryNameLabel)
        categoryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        [
            categoryNameLabel.bottomAnchor.constraint(equalTo: cateogryView.bottomAnchor, constant: -12),
            categoryNameLabel.rightAnchor.constraint(equalTo: cateogryView.rightAnchor, constant: -16),
            categoryNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            categoryNameLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1)
            ].forEach{ $0.isActive = true}
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
