//
//  LoginAndRegisterController.swift
//  MemoryBook
//
//  Created by GISU KIM on 2018-02-20.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

class LoginAndRegisterController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let loginCellId = "loginCellId"
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        cv.register(LoginCell.self, forCellWithReuseIdentifier: loginCellId) 
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    let pages : [LoginPage] = {
        let firstPage = LoginPage(title: "Memory with the moment", message: "Sometimes memory is everything you have in a life and make you live as human being", imageName: "memorybook_page1")
        let secondPage = LoginPage(title: "Share your memory with people who you care about", message: "Sometimes memory is everything you have in a life and make you live as human being", imageName: "memorybook_page2")
        let thirdPage = LoginPage(title: "Memory bring your back to a moment you were the shinest moment", message: "Sometimes memory is everything you have in a life and make you live as human being", imageName: "memorybook_page3")
//        let fourthPage = LoginPage(title: "Memory bring your back to a moment you were the shinest moment", message: "Sometimes memory is everything you have in a life and make you live as human being", imageName: "memorybook_page3")
//
        return [firstPage, secondPage, thirdPage]
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: loginCellId, for: indexPath) as! LoginCell
        cell.loginPage = pages[indexPath.row]
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.anchorToTop(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor)
        
    }
}


