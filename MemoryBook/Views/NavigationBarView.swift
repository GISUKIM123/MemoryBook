//
//  NavigationBarView.swift
//  MemoryBook
//
//  Created by gisu kim on 2018-02-02.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

class MenuCell : UICollectionViewCell {
    let imageView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "memoryBook_image")?.withRenderingMode(.alwaysTemplate)
        imgView.tintColor = UIColor.init(red: 96/255, green: 125/255, blue: 139/255, alpha: 1)
        
        return imgView
    }()
    
    // highlight selected cell by coloring white when clicked
    override var isHighlighted: Bool {
        didSet {
            imageView.tintColor = isHighlighted ? UIColor.white : UIColor.init(red: 96/255, green: 125/255, blue: 139/255, alpha: 1)
        }
    }
    
    // change to white color when it selected
    override var isSelected: Bool {
        didSet {
            imageView.tintColor = isSelected ? UIColor.white : UIColor.init(red: 96/255, green: 125/255, blue: 139/255, alpha: 1)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        [
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.widthAnchor.constraint(lessThanOrEqualToConstant: 44),
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 44)
            ].forEach{ $0.isActive = true}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class NavigationBarView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"

    var mainViewController : MainViewController?
    var imageNames : [String] = ["memoryBook_image", "memoryBook_like", "memoryBook_bookmark", "memoryBook_setting"]
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.black
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.imageView.image = UIImage(named: imageNames[indexPath.row])?.withRenderingMode(.alwaysTemplate)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 4, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if self.mainViewController?.mainCell == nil {
                self.mainViewController?.setupMainView()
            } else {
                self.mainViewController?.assignedImageUrls = (self.mainViewController?.imageUrls)!
                self.mainViewController?.setupMainView()
            }
        }else if indexPath.row == 1 {
            if self.mainViewController?.likeCell == nil {
                self.mainViewController?.setupLikeView()
            }else {
                self.mainViewController?.view.bringSubview(toFront: (self.mainViewController?.likeCell)!)
            }
        }else if indexPath.row == 2 {
            if self.mainViewController?.categoryCell == nil {
                self.mainViewController?.setupCategoryView()
            }else {
                self.mainViewController?.view.bringSubview(toFront: (self.mainViewController?.categoryCell)!)
            }
        }else {
            if self.mainViewController?.settingCell == nil {
                self.mainViewController?.setupSettingView()
            }else {
                self.mainViewController?.view.bringSubview(toFront: (self.mainViewController?.settingCell)!)
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        [
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            collectionView.widthAnchor.constraint(equalTo: self.widthAnchor),
            collectionView.heightAnchor.constraint(equalTo: self.heightAnchor)
            ].forEach { $0.isActive = true }
        
        let selectedIndexPath = NSIndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: .centeredVertically)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


