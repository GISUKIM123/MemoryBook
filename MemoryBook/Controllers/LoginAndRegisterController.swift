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
    let pageCellId = "pageCellId"
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white     
        cv.delegate = self
        cv.dataSource = self
        cv.register(PageCell.self, forCellWithReuseIdentifier: pageCellId)
        cv.register(LoginCell.self, forCellWithReuseIdentifier: loginCellId)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    let pages : [Page] = {
        let firstPage = Page(title: "Memory with the moment", message: "Sometimes memory is everything you have in a life and make you live as human being", imageName: "memorybook_page1")
        let secondPage = Page(title: "Share your memory with people who you care about", message: "Sometimes memory is everything you have in a life and make you live as human being", imageName: "memorybook_page2")
        let thirdPage = Page(title: "Memory bring your back to a moment you were the shinest moment", message: "Sometimes memory is everything you have in a life and make you live as human being", imageName: "memorybook_page3")

        return [firstPage, secondPage, thirdPage]
    }()
    
    lazy var pageControl : UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = .orange
        pc.numberOfPages = pages.count + 1
        
        return pc
    }()
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / self.view.frame.width)
        pageControl.currentPage = pageNumber
        
        // we are on the last page
        if pageNumber == pages.count {
            moveControlOffScreen()
        }else {
            pageControlBottomAnchor?.constant = -24
            skipButtonTopAnchor?.constant = 24
            nextButtonTopAnchor?.constant = 24
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    fileprivate func moveControlOffScreen() {
        pageControlBottomAnchor?.constant = 200
        skipButtonTopAnchor?.constant = -40
        nextButtonTopAnchor?.constant = -40
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == pages.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: loginCellId, for: indexPath) as! LoginCell
            
            return cell
        }
        
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pageCellId, for: indexPath) as! PageCell
        cell.page = pages[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height)
    }
    
    var pageControlBottomAnchor : NSLayoutConstraint?
    
    lazy var skipButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.addTarget(self, action: #selector(skipPage), for: .touchUpInside)
        
        return button
    }()
    
    @objc func skipPage() {
        pageControl.currentPage = pages.count - 1
        nextPage()
    }
    
    lazy var nextButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        
        return button
    }()
    
    @objc func nextPage() {
        // on the last page
        if pageControl.currentPage == pages.count {
            return
        }
        
        if pageControl.currentPage == pages.count - 1 {
            moveControlOffScreen()
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        
        let indexPath = IndexPath(item: pageControl.currentPage + 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage += 1
    }
    
    var skipButtonTopAnchor : NSLayoutConstraint?
    var nextButtonTopAnchor : NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        obserKeyboardNotification()
        
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleScreenTouched)))
        
        setupButtons()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        [
            pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ].forEach{ $0.isActive = true }
        pageControlBottomAnchor = pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24)
        pageControlBottomAnchor?.isActive = true
        
        collectionView.anchorToTop(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor)
    }
    
    @objc func handleScreenTouched() {
        view.endEditing(true)
    }
    
    func setupButtons() {
        view.addSubview(skipButton)
        view.addSubview(nextButton)
        
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        [
            skipButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            skipButton.widthAnchor.constraint(equalToConstant: 60),
            skipButton.heightAnchor.constraint(equalToConstant: 50)
        ].forEach{ $0.isActive = true }
        
        skipButtonTopAnchor = skipButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 24)
        skipButtonTopAnchor?.isActive = true
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        [
            nextButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12),
            nextButton.widthAnchor.constraint(equalToConstant: 60),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ].forEach{ $0.isActive = true }
        
        nextButtonTopAnchor = nextButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 24)
        nextButtonTopAnchor?.isActive = true
    }
    
    
    
    fileprivate func obserKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    @objc func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    @objc func keyboardShow() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: -85, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
}

