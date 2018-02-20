//
//  ZoomInAndOutLauncher.swift
//  MemoryBook
//
//  Created by gisu kim on 2018-02-08.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ButtonCell : UICollectionViewCell {
    
    var zoomInAndOutLauncher : ZoomInAndOutLauncher?
    var mainViewController : MainViewController?
        
    
    lazy var button : UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.init(red: 96/255, green: 125/255, blue: 139/255, alpha: 1)
        button.addTarget(self, action: #selector(handleAddToLike), for: .touchUpInside)
        return button
    }()
    
    @objc func handleAddToLike() {
        //TODO: update current user like array
        if let imageUrl = self.zoomInAndOutLauncher?.imageUrl {
            self.mainViewController?.currentUser?.likeImageUrls?.append(imageUrl)
            self.mainViewController?.likeCell?.likeImageUrls = self.mainViewController?.currentUser?.likeImageUrls
        }
        
        //TODO: update db
        let databaseRef = Database.database().reference()
        if  let lastname = self.mainViewController?.currentUser?.lastName                       ,
            let firstname = self.mainViewController?.currentUser?.firstName                     ,
            let email = self.mainViewController?.currentUser?.email                             ,
            let imageIds = self.mainViewController?.currentUser?.imageIds == nil ? [String]() : self.mainViewController?.currentUser?.imageIds,
            let likeImageUrls = self.mainViewController?.currentUser?.likeImageUrls == nil ? [String]() :  self.mainViewController?.currentUser?.likeImageUrls
        {
            let values: [String : Any] = ["lastName": lastname, "firstName": firstname, "email": email, "imageIds": imageIds, "likeImageUrls": likeImageUrls]
            
            databaseRef.child("users").child((Auth.auth().currentUser?.uid)!).updateChildValues(values) { (error, ref) in
                if error != nil {
                    return
                }
                
                DispatchQueue.main.async {
                    self.mainViewController?.likeCell?.carouselView.reloadData()
                    self.mainViewController?.likeCell?.timer?.invalidate()
                    self.mainViewController?.likeCell?.setupScrollView(width: (self.mainViewController?.view.frame.width)!, height: (self.mainViewController?.view.frame.height)!)
                    if (self.mainViewController?.currentUser?.likeImageUrls?.count)! > 5 {
                        self.mainViewController?.likeCell?.pageController.numberOfPages = 5
                    }else {
                        self.mainViewController?.likeCell?.pageController.numberOfPages = (self.mainViewController?.currentUser?.likeImageUrls?.count)!
                    }
                    
                    self.zoomInAndOutLauncher?.handleDimiss()
                    UIAlertController().alertMessage(message: "Added to your like 💖", rootController: self.mainViewController!)
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        [
            button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            button.widthAnchor.constraint(lessThanOrEqualToConstant: 44),
            button.heightAnchor.constraint(lessThanOrEqualToConstant: 44)
            
            ].forEach{ $0.isActive = true }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ZoomInAndOutLauncher: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    
    let buttonCell = "buttonCell"
    // remind original size of an image
    var startingFrame : CGRect?
    // backgroundView when an image is zoomed in
    var blackBackgroundView : UIView?
    // contains info of original imageView and image
    var imageView : UIImageView?
    // selected image
    var imageUrl : String?
    
    
    var mainViewController : MainViewController?
    
    lazy var buttonCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: buttonCell)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    let buttonNames = ["memoryBook_like", "memorybook_download", "memorybook_uparrow"]
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: buttonCell, for: indexPath) as! ButtonCell
        cell.button.setImage(UIImage(named: buttonNames[indexPath.row])?.withRenderingMode(.alwaysTemplate), for: .normal)
        cell.zoomInAndOutLauncher = self
        cell.mainViewController = self.mainViewController
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
    
    var zoomingImageView : UIImageView?
    
    func setupLauncher(imageView: UIImageView, imageUrl: String) {
        self.imageView = imageView
        self.imageView?.isHidden = true
        startingFrame = imageView.superview?.convert(imageView.frame, to: nil)
        
        zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView?.image = imageView.image
        zoomingImageView?.isUserInteractionEnabled = true
        zoomingImageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        self.imageUrl = imageUrl
        
        
        let image = imageView.image
        
        if let keyWindow = UIApplication.shared.keyWindow {
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = .black
            blackBackgroundView?.alpha = 0
            keyWindow.addSubview(blackBackgroundView!)
            
            keyWindow.addSubview(zoomingImageView!)
            setupbuttons(keyWindow: keyWindow)
            
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackBackgroundView?.alpha = 1
                let height = (image?.size.height)! / (image?.size.width)! * keyWindow.frame.width
                
                self.zoomingImageView?.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                self.zoomingImageView?.center = keyWindow.center
                
            }, completion: nil)
        }
    }
    
    func setupbuttons(keyWindow : UIWindow) {
        keyWindow.addSubview(buttonCollectionView)
        buttonCollectionView.translatesAutoresizingMaskIntoConstraints = false
        [
            buttonCollectionView.bottomAnchor.constraint(equalTo: keyWindow.bottomAnchor),
            buttonCollectionView.centerXAnchor.constraint(equalTo: keyWindow.centerXAnchor),
            buttonCollectionView.widthAnchor.constraint(equalTo: keyWindow.widthAnchor),
            buttonCollectionView.heightAnchor.constraint(equalTo: keyWindow.heightAnchor, multiplier: 0.1)
            ].forEach{ $0.isActive = true }
        
    }
    
    @objc func handleZoomOut() {
        //TODO: zoom out an image
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.zoomingImageView?.frame = self.startingFrame!
            self.blackBackgroundView?.alpha = 0
            
        }, completion: { (completed) in
            
            if completed {
                self.buttonCollectionView.removeFromSuperview()
                self.zoomingImageView?.removeFromSuperview()
                self.imageView?.isHidden = false
            }
        })
    }
    
    func handleDimiss() {
        self.zoomingImageView?.frame = self.startingFrame!
        self.blackBackgroundView?.alpha = 0
        self.buttonCollectionView.removeFromSuperview()
        self.zoomingImageView?.removeFromSuperview()
        self.imageView?.isHidden = false
    }
}
