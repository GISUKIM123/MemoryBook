//
//  MainCell.swift
//  MemoryBook
//
//  Created by gisu kim on 2018-02-07.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

class MainCell: UICollectionView {
    var mainViewController: MainViewController?
    let cellId = "cellId"
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.backgroundColor = UIColor.black
        self.alpha = 0.9
        
        self.register(ImageCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
