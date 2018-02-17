//
//  Extensions.swift
//  MemoryBook
//
//  Created by gisu kim on 2018-02-06.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImageUsingCacheWithUrl(urlString : String) {
        self.image = nil
        
        if let cacheImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cacheImage
            return
        }
        
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let downloadImage = UIImage(data: data!) {
                    imageCache.setObject(downloadImage, forKey: urlString as NSString)
                    self.image = downloadImage
                }
            }
        }
        
        dataTask.resume()
    }
}

extension UIAlertController {
    func alertErrorMessage(message: String, rootController: UIViewController) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        rootController.present(alert, animated: true, completion: nil)
    }
    
    func alertMessage(message : String, rootController : UIViewController) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.5
        rootController.present(alert, animated: true, completion: nil)
        //TODO: set timer for dismiss
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(700)) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
}
