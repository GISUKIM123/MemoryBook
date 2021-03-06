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
    var indexPath : IndexPath?
    
    lazy var cateogryView : UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .clear
        imgView.layer.cornerRadius = 30
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.opacity = 0.8
        
        return imgView
    }()
    
    let coverLayerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.alpha = 0.5
        view.layer.cornerRadius = 30
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        return view
    }()
    
    let categoryNameLabel : UILabel = {
        let nl = UILabel()
        nl.font = UIFont.boldSystemFont(ofSize: 25)
        nl.textAlignment = .right
        nl.textColor = .white
        
        return nl
    }()
    
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
        
        addSubview(coverLayerView)
        coverLayerView.translatesAutoresizingMaskIntoConstraints = false
        [
            coverLayerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            coverLayerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            coverLayerView.widthAnchor.constraint(equalTo: self.widthAnchor),
            coverLayerView.heightAnchor.constraint(equalTo: self.heightAnchor)
            
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
