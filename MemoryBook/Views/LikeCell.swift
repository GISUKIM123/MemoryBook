//
//  LikeCell.swift
//  MemoryBook
//
//  Created by gisu kim on 2018-02-07.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

class LikeCell: UIView, UIScrollViewDelegate {
    
    var mainViewController : MainViewController?
    
    lazy var zoomInAndOutLauncher : ZoomInAndOutLauncher = {
        let launcher = ZoomInAndOutLauncher()
        launcher.mainViewController = self.mainViewController
        
        return launcher
    }()
    
    let categoryImages: [String] = ["memorybook_category1", "memorybook_category2", "memorybook_category3", "memorybook_category4", "memorybook_category5"]
    
    
    var currentUser : User? {
        didSet {
            //TODO: userbased setting
            
        }
    }
    
    let likeCellAnimation = "likeCellAnimation"
    
    let pageController : UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.currentPageIndicatorTintColor = .orange
        
        return pc
    }()
    
    lazy var animationView: UIScrollView = {
        let cv = UIScrollView()
        cv.backgroundColor = .clear
        cv.delegate = self
        
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    
    let carouselView : iCarousel = {
        let view = iCarousel()
        
        return view
    }()
    
    var imageContentWidthForScrollView : CGFloat = 0.0
    
    func setupScrollView(width: CGFloat, height: CGFloat) {
        for i in 0..<5 {
            let imageView = UIImageView()
            imageView.loadImageUsingCacheWithUrl(urlString: (self.mainViewController?.imageUrls[i])!)
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSliderClicked)))
            
            let xCoordinate =  width * CGFloat(i)
            imageContentWidthForScrollView += width
            animationView.addSubview(imageView)
            imageView.frame = CGRect(x: xCoordinate, y: 64, width: width, height: height)
        }
        
        animationView.contentSize = CGSize(width: imageContentWidthForScrollView, height: self.frame.height)
        
        pageController.numberOfPages = categoryImages.count
        animateSlider()
    }
    
    @objc func handleSliderClicked(tap: UITapGestureRecognizer) {
        if let view = tap.view as? UIImageView {
            zoomInAndOutLauncher.setupLauncher(imageView: view)
        }
    }
    
    func animateSlider() {
        var currentPage: CGFloat = 0.0
        let timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (timer) in
            if currentPage != CGFloat(self.categoryImages.count) {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.animationView.contentOffset.x = currentPage * (self.imageContentWidthForScrollView / CGFloat(self.categoryImages.count))
                }, completion: { (completed) in
                    if completed {
                        currentPage += 1.0
                    }
                })
                
            }else {
                currentPage = 0.0
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.animationView.contentOffset.x = currentPage * (self.imageContentWidthForScrollView / CGFloat(self.categoryImages.count))
                }, completion: { (completed) in
                    if completed {
                        currentPage += 1.0
                    }
                })
            }
        }

        timer.fire()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         pageController.currentPage = Int(animationView.contentOffset.x / CGFloat(imageContentWidthForScrollView / CGFloat(categoryImages.count)))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        
        addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        [
            animationView.topAnchor.constraint(equalTo: self.topAnchor),
            animationView.leftAnchor.constraint(equalTo: self.leftAnchor),
            animationView.widthAnchor.constraint(equalTo: self.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5)
        
        ].forEach{ $0.isActive = true }
        
        
        addSubview(pageController)
        
        pageController.translatesAutoresizingMaskIntoConstraints = false
        [
            pageController.bottomAnchor.constraint(equalTo: animationView.bottomAnchor),
            pageController.leftAnchor.constraint(equalTo: self.leftAnchor),
            pageController.widthAnchor.constraint(equalTo: self.widthAnchor),
            pageController.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1)
            ].forEach{ $0.isActive = true }
        
        addSubview(carouselView)
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        [
            carouselView.leftAnchor.constraint(equalTo: self.leftAnchor),
            carouselView.topAnchor.constraint(equalTo: animationView.bottomAnchor),
            carouselView.widthAnchor.constraint(equalTo: self.widthAnchor),
            carouselView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5)
            ].forEach{ $0.isActive = true }
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


