    //
//  ViewController.swift
//  MemoryBook
//
//  Created by gisu kim on 2018-02-02.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class MainViewController: UIViewController{
    let cellId = "cellId"
    // access to navigationBarView
    var navigationBarView : NavigationBarView?
    // selected Image
    var selectedImage : UIImage?
    // current User
    var currentUser : User?
    // mainpage image Array
    var imageIds : [String] = [String]()
    // assigning imageUrl array to maincell to display
    var userImages : [Image] = [Image]()
    // images filted by a category
    var filteredImages : [Image] = [Image]()
    var mainCell : MainCell?
    
    //database reference
    let databaseRef = Database.database().reference()
    // image zoom in and out
    
    // remind original size of an image
    var startingFrame : CGRect?
    // backgroundView when an image is zoomed in
    var blackBackgroundView : UIView?
    // contains info of original imageView and image
    var imageView : UIImageView?
    // a view providing a selection of category
    var categorySelectingView : CategorySelectingView?
    // detect a category of a selected image
    var selectedCategory : String?
    
    var settingArray : [String] = ["About", "Instagram", "Rate", "Share", "Theme"]
    
    var settingIconImages = ["memorybook_about", "memorybook_instagram", "memorybook_rate", "memorybook_share", "memorybook_theme"]
    
    lazy var zoomInAndOutLauncher : ZoomInAndOutLauncher = {
        let launcher = ZoomInAndOutLauncher()
        launcher.mainViewController = self
        
        return launcher
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: styling Title
        setupNavigationBar()    
        setupUserBased()
        setupMenuBar()
        setupMainView()
        
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "MemoryBook"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Zapfino", size: 20)!, NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add
            , target: self, action: #selector(handleAddImage))
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "memorybook_category2")
        self.view.insertSubview(backgroundImage, at: 0)
        
    }
    
    var loginAndRegisterController : LoginAndRegisterController?
    
    @objc func handleLogout() {
        loginAndRegisterController = LoginAndRegisterController()
        
        self.present(loginAndRegisterController!, animated: true, completion: nil)
    }
    
    @objc func handleAddImage() {
        self.categorySelectingView = CategorySelectingView()
        self.categorySelectingView?.mainViewController = self
        self.view.addSubview(categorySelectingView!)
        self.categorySelectingView?.frame = CGRect(x: 0, y: 500, width: self.view.frame.width, height: self.view.frame.height)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.categorySelectingView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    func setupUserBased() {
        Auth.auth().signIn(withEmail: "gisu@gmail.com", password: "123123") { (user, error) in
            if error != nil {
                //TODO: error handling
            } else {
                let ref = Database.database().reference().child("users")
                ref.observeSingleEvent(of: .childAdded, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String : Any] {
                        self.currentUser = User(dictionary: dictionary)
                        
                        self.setupImageArray()
                    }
                })
            }
        }
    }
    
    func setupImageArray() {
        databaseRef.child("images").observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String : String] else {
                return
            }
            
            if dictionary["userId"] == Auth.auth().currentUser?.uid {
                let image = Image(dictionary: dictionary)
                self.userImages.append(image)
            }
            
            DispatchQueue.main.async {
                self.filteredImages = self.userImages
                self.mainCell?.reloadData()
            }
        })
    }
    
    var likeCell : LikeCell?
    
    func setupLikeView() {
        
        likeCell = LikeCell()
        self.view.addSubview(likeCell!)
        setupContratinsForCell(cell: likeCell!)
        likeCell?.mainViewController = self
        likeCell?.currentUser = self.currentUser!
        likeCell?.carouselView.delegate = self
        likeCell?.carouselView.dataSource = self
        likeCell?.carouselView.type = .coverFlow
        likeCell?.setupScrollView(width: self.view.frame.width, height: self.view.frame.height)
        
    }
    
    var categoryCell : CategoryCell?
    
    func setupCategoryView() {
        
        categoryCell = CategoryCell()
        categoryCell?.mainViewController = self
        self.view.addSubview(categoryCell!)
        
        setupContratinsForCell(cell: categoryCell!)
    }
    
    
    var settingCell : SettingCell?
    
    func setupSettingView() {
        
        settingCell = SettingCell()
        self.view.addSubview(settingCell!)
        settingCell?.settingTableView.dataSource = self
        settingCell?.settingTableView.delegate = self
        
        setupContratinsForCell(cell: settingCell!)
    }
    
    
    
    func setupMainView() {
        if self.mainCell != nil {
           self.mainCell?.removeFromSuperview()
        }
        
        let customizedFlowLayout = CustomizedFlowlayout()
        mainCell = MainCell(frame: .zero, collectionViewLayout: customizedFlowLayout)
        self.mainCell?.collectionViewLayout = customizedFlowLayout
        if let layout = self.mainCell?.collectionViewLayout as? CustomizedFlowlayout {
            layout.delegate = self
        }
        self.view.addSubview(mainCell!)
        
        mainCell?.mainViewController = self
        mainCell?.dataSource = self
        mainCell?.delegate = self
        
        setupContratinsForCell(cell: mainCell!)
    }
    
    func setupContratinsForCell(cell: UIView) {
        cell.translatesAutoresizingMaskIntoConstraints = false
        [
            cell.topAnchor.constraint(equalTo: self.view.topAnchor),
            cell.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            cell.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            cell.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.9)
            
        ].forEach{ $0.isActive = true}
    }
    
    func setupMenuBar() {
        navigationBarView = NavigationBarView()
        self.view.addSubview(navigationBarView!)
        navigationBarView?.mainViewController = self
        navigationBarView?.translatesAutoresizingMaskIntoConstraints = false
        [
            navigationBarView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            navigationBarView?.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            navigationBarView?.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            navigationBarView?.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1)
            
        ].forEach{ $0?.isActive = true }
    }
}
    
extension MainViewController :  UICollectionViewDataSource, UICollectionViewDelegate  {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageCell
        cell.imageView.loadImageUsingCacheWithUrl(urlString: self.filteredImages[indexPath.row].imageUrl!)
        cell.mainViewController = self
        cell.imageUrl = self.filteredImages[indexPath.row].imageUrl
        
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
    
    func handleImageClicked(imageView: UIImageView, imageUrl: String) {
        zoomInAndOutLauncher.setupLauncher(imageView: imageView, imageUrl: imageUrl)
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

extension MainViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
   @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let choseImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        uploadImageToDatabase(image: choseImage)
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploadImageToDatabase(image : UIImage) {
        let imageName = NSUUID().uuidString
        let ref = Storage.storage().reference().child("images").child("\(imageName).jpg")
        if let uploadData = UIImageJPEGRepresentation(image, 0.1) {

            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error!)
                }else {
                    if let imageUrl = metadata?.downloadURL()?.absoluteString {
                        self.storeImage(imageUrl: imageUrl, imageName: imageName)
                    }
                }
            })
        }
    }
    
    func storeWithUserID(imageUrl : String, imageName: String) {
        //TODO: should be user-based
        var imageIds: [String] = (self.currentUser?.imageIds) == nil ? [String]() : (self.currentUser?.imageIds)!
        let likeImageIds: [String] = (self.currentUser?.likeImageUrls) == nil ? [String]() : (self.currentUser?.likeImageUrls)!
        imageIds.append(imageName)
        
        let values = ["firstName": "gisu"                               ,
                      "lastName": "Kim"                                 ,
                      "email": "gisu@gmail.com"                         ,
                      "imageIds": imageIds                              ,
                      "likeImageUrls": likeImageIds                     ] as [String : Any]
        
        databaseRef.child("users").child((Auth.auth().currentUser?.uid)!).updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
            }
            
            DispatchQueue.main.async {
                UIAlertController().alertMessage(message: "Your picture added 💖", rootController: self)
            }
        }
    }
    
    func storeImage(imageUrl: String, imageName: String) {
        if let cateogry = selectedCategory {
            let values = ["category": cateogry, "userId": Auth.auth().currentUser?.uid, "imageUrl": imageUrl] as? [String : String]
            databaseRef.child("images").child(imageName).setValue(values, withCompletionBlock: { (error, ref) in
                if error != nil {
                    return
                }
                
                self.storeWithUserID(imageUrl: imageUrl, imageName: imageName)
            })
        }
    }
}
    
extension MainViewController : iCarouselDelegate, iCarouselDataSource {
   
    func numberOfItems(in carousel: iCarousel) -> Int {
        return self.currentUser?.likeImageUrls?.count == 0 ? 0 : (self.currentUser?.likeImageUrls?.count)!
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        let imageView = UIImageView()
        imageView.loadImageUsingCacheWithUrl(urlString: (self.currentUser?.likeImageUrls![index])!)
        view.addSubview(imageView)
        imageView.frame = view.frame
        
        return view
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.spacing {
            return value * 1.1
        }
        
        return value
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
    
extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingId", for: indexPath)
        cell.backgroundColor = UIColor.black
        cell.alpha = 0.9
        let iconImageView = UIImageView(image: UIImage(named: self.settingIconImages[indexPath.row])?.withRenderingMode(.alwaysTemplate))
        iconImageView.tintColor = .white
        cell.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        [
            iconImageView.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            iconImageView.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -16),
            iconImageView.widthAnchor.constraint(equalToConstant: 28),
            iconImageView.heightAnchor.constraint(equalToConstant: 28)
            
        ].forEach{ $0.isActive = true }
        
        cell.textLabel?.text = settingArray[indexPath.row]
        cell.textLabel?.textColor = .white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = .white
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = UIColor.black
        
    }
}
    
