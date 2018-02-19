//
//  CategoryCell.swift
//  MemoryBook
//
//  Created by gisu kim on 2018-02-07.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

class CategoryCell: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var mainViewController : MainViewController?
    let categoryCellId = "categoryCellId"
    let categoryImages: [String] = ["memorybook_category1", "memorybook_category2", "memorybook_category3", "memorybook_category4", "memorybook_category5"]
    let categories: [String] = ["Natural", "Programming", "Life", "Object", "Smoke"]
    
    
    lazy var cateogryCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.black
        cv.register(CategoryImageCell.self, forCellWithReuseIdentifier: categoryCellId)
        cv.dataSource = self
        cv.delegate = self
        
        return cv
    }()
    
    @objc func handleCategorySelected(tap: UITapGestureRecognizer) {
//        TODO: handle a category is selected
        if let view = tap.view as? CategoryImageCell {
            var imagesFilterdbyCategory = [Image]()
            for count in 0..<(self.mainViewController?.userImages.count)! {
                if view.categoryNameLabel.text?.lowercased() == self.mainViewController?.userImages[count].category?.lowercased() {
                    imagesFilterdbyCategory.append((self.mainViewController?.userImages[count])!)
                }
            }
            self.mainViewController?.filteredImages = imagesFilterdbyCategory
            self.mainViewController?.setupMainView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellId, for: indexPath) as! CategoryImageCell
        cell.cateogryView.image = UIImage(named: categoryImages[indexPath.row])
        cell.categoryNameLabel.text = categories[indexPath.row]
        cell.isUserInteractionEnabled = true
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCategorySelected)))
        cell.categoryCell = self
        cell.indexPath = indexPath
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.frame.width * 0.9, height: self.frame.height * 0.95)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cateogryCollectionView)
        
        cateogryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        [
            cateogryCollectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cateogryCollectionView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            cateogryCollectionView.widthAnchor.constraint(equalTo: self.widthAnchor),
            cateogryCollectionView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ].forEach{ $0.isActive = true}
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
