//
//  CategorySelectingView.swift
//  MemoryBook
//
//  Created by gisu kim on 2018-02-19.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

class CategoryCellForSelectionView: UICollectionViewCell {
    let label : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "labellabellabel"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = .clear
        label.font = UIFont.boldSystemFont(ofSize: 25)
        
        return label
    }()
    
    let backgroundImageView : UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleToFill
        
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backgroundImageView)
        
        backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        backgroundImageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        backgroundImageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        addSubview(label)
        
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CategorySelectingView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var mainViewController : MainViewController?
    let categorySelectionId = "categorySelectionId"
    var categories = ["nature", "programming", "life", "object", "smoke"]
    var categoryBackgroundimageNames = ["memorybook_category1", "memorybook_category2", "memorybook_category3", "memorybook_category4", "memorybook_category5"]
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.register(CategoryCellForSelectionView.self, forCellWithReuseIdentifier: categorySelectionId)
        
        return cv
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categorySelectionId, for: indexPath) as! CategoryCellForSelectionView
        cell.label.text = categories[indexPath.row]
        cell.backgroundImageView.image = UIImage(named: categoryBackgroundimageNames[indexPath.row]) 
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.mainViewController?.selectedCategory = categories[indexPath.row]
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.frame = CGRect(x: 0, y: 1000, width: self.frame.width, height: self.frame.height)
        }) { (completed) in
            if completed {
                self.removeFromSuperview()
                
                let picker = UIImagePickerController()
                picker.delegate = self.mainViewController
                picker.allowsEditing = true
                picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                
                self.mainViewController?.present(picker, animated: true, completion: nil)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.mainViewController?.view.frame.width)!, height: (self.mainViewController?.view.frame.height)! / 5)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        [
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            collectionView.widthAnchor.constraint(equalTo: self.widthAnchor),
            collectionView.heightAnchor.constraint(equalTo: self.heightAnchor)
            
        ].forEach{ $0.isActive = true }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
