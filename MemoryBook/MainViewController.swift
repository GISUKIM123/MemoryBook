//
//  ViewController.swift
//  MemoryBook
//
//  Created by gisu kim on 2018-02-02.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UICollectionViewController {
    let cellId = "cellId"
    // access to navigationBarView
    var navigationBarView : NavigationBarView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.backgroundColor = UIColor.init(red: 69/255, green: 90/255, blue: 100/255, alpha: 1)
        self.collectionView?.register(ImageCell.self, forCellWithReuseIdentifier: cellId)
        
        let customizedLayout = CustomizedFlowlayout()
        self.collectionView?.collectionViewLayout = customizedLayout
        
        if let layout = collectionView?.collectionViewLayout as? CustomizedFlowlayout {
            layout.delegate = self
        }
        
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        navigationBarView = NavigationBarView()
        self.collectionView?.addSubview(navigationBarView!)
        navigationBarView?.mainViewController = self
        navigationBarView?.translatesAutoresizingMaskIntoConstraints = false
        [
            navigationBarView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            navigationBarView?.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            navigationBarView?.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            navigationBarView?.heightAnchor.constraint(equalToConstant: 64)
            ].forEach{ $0?.isActive = true }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        // randomize height for each cell
//        let randomNum = Int(arc4random_uniform(3))
//        let height : CGFloat
//        if randomNum == 0 {
//            height = self.view.frame.height / 3
//        }else if randomNum == 1 {
//            height = self.view.frame.height / 4
//        }else {
//            height = self.view.frame.height / 5
//        }
//
//        return CGSize(width: self.view.frame.width / 3, height: height)
//    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    let imageNames : [String] = ["image1", "image2", "image3", "image4", "image5", "image6", "image7", "image8", "image9"]
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageCell
        let image = UIImage(named: imageNames[indexPath.item])
        cell.imageView.image = image
        cell.imageView.contentMode = .scaleAspectFill
        cell.imageView.clipsToBounds = true
        cell.imageCellDelegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
    }
    

}

extension MainViewController : CustomizedLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForImageAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        // calculate dynamic size of image
//        let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
//        let rect = AVMakeRect(aspectRatio: image.size, insideRect: boundingRect)
        
        let randomNum = Int(arc4random_uniform(3))
        let height : CGFloat
        if randomNum == 0 {
            height = self.view.frame.height / 3
        }else if randomNum == 1 {
            height = self.view.frame.height / 4
        }else {
            height = self.view.frame.height / 5
        }
        
        return height
    }
}

extension MainViewController : ImageCellDelegate {
    func handleImageClicked() {
        // TODO: image is clicked
        print(123123)
    }
}
