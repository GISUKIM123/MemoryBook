//
//  LoginCell.swift
//  MemoryBook
//
//  Created by GISU KIM on 2018-02-20.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

class PageCell: UICollectionViewCell {
    var page : Page? {
        didSet {
            guard let page = page else {
                return
            }
            
            let attributedText = NSMutableAttributedString(string: page.title!, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20, weight: .medium), NSAttributedStringKey.foregroundColor : UIColor.init(white: 0.2, alpha: 1)])
            attributedText.append(NSMutableAttributedString(string: "\n\n\(page.message!)", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.init(white: 0.2, alpha: 1)]))
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let legnth = attributedText.string.characters.count
            attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: legnth))
            
            textView.attributedText = attributedText
//            imageView.image = UIImage(named: loginPage?.imageName)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .yellow
        iv.clipsToBounds = true
        
        
        return iv
    }()
    
    let textView : UITextView = {
        let tv = UITextView()
        tv.text = "Sample text for now"
        tv.isEditable = false
        tv.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        return tv
    }()
    
    let lineSeperator : UIView = {
        let uv = UIView()
        uv.backgroundColor = UIColor.init(white: 0.9, alpha: 1)
        
        return uv
    }()
    
   
    func setupView() {
        addSubview(imageView)
        addSubview(textView)
        addSubview(lineSeperator)
       
        
        imageView.anchorToTop(top: self.topAnchor, left: self.leftAnchor, bottom: textView.topAnchor, right: self.rightAnchor)
    
        textView.anchorWithContantsToTop(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
        textView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3).isActive = true
        
        lineSeperator.anchorToTop(top: nil, left: leftAnchor, bottom: textView.topAnchor, right: rightAnchor)
        lineSeperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
