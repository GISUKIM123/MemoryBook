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
    let likeCell = "likeCell"
    let categoryCell = "categoryCell"
    let settingCell = "settingCell"
    // access to navigationBarView
    var navigationBarView : NavigationBarView?
    // selected Image
    var selectedImage : UIImage?
    // current User
    var currentUser : User?
    // mainpage image Array
    var imageUrls : [String] = [String]()
    
    var mainCell : MainCell?
    
    // image zoom in and out
    
    // remind original size of an image
    var startingFrame : CGRect?
    // backgroundView when an image is zoomed in
    var blackBackgroundView : UIView?
    // contains info of original imageView and image
    var imageView : UIImageView?
    
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
        self.navigationItem.title = "MemoryBook"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Zapfino", size: 20)!, NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add
            , target: self, action: #selector(handleAddImage))
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "memorybook_category2")
        self.view.insertSubview(backgroundImage, at: 0)
        setupUserBased()
        setupNavigationBar()
        setupMainView()
        
    }
    
    @objc func handleLogout() {
        print(1)
    }
    
    @objc func handleAddImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(picker, animated: true, completion: nil)
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
                        
                        self.setupimageUrlArray()
                    }
                })
//                let user = User()
//                user.firstName = "gisu"
//                user.lastName = "Kim"
//                user.email = "gisu@gmail.com"
//                let userValues = ["firstName" : user.firstName, "lastName": user.lastName, "email": user.email]
//                ref.updateChildValues(userValues)
                
            }
            
        }
    }
    
    func setupimageUrlArray() {
        if let userImageUrls = currentUser?.imageUrls {
            self.imageUrls = userImageUrls
        }
        
        self.mainCell?.reloadData()
    }
    
    func setupLikeView() {
        let likeCell = LikeCell()
        self.view.addSubview(likeCell)
        setupContratinsForCell(cell: likeCell)
        likeCell.currentUser = self.currentUser!
        likeCell.carouselView.delegate = self
        likeCell.carouselView.dataSource = self
        likeCell.carouselView.type = .coverFlow
        likeCell.setupScrollView(width: self.view.frame.width, height: self.view.frame.height)
    }
    
    func setupCategoryView() {
        
        let categoryCell = CategoryCell()
        self.view.addSubview(categoryCell)
        
        setupContratinsForCell(cell: categoryCell)
    }
    
    func setupSettingView() {
        let settingCell = SettingCell()
        self.view.addSubview(settingCell)
        setupContratinsForCell(cell: settingCell)
        
        settingCell.settingTableView.dataSource = self
        settingCell.settingTableView.delegate = self
    }
    
    func setupMainView() {
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
    
    func setupNavigationBar() {
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
        return self.imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageCell
        cell.imageView.loadImageUsingCacheWithUrl(urlString: imageUrls[indexPath.item])
        //        cell.imageCellDelegate = self
        cell.mainViewController = self
        
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
    
    func handleImageClicked(imageView: UIImageView) {
        zoomInAndOutLauncher.setupLauncher(imageView: imageView)
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
                        self.storeWithUserID(imageUrl: imageUrl)
                    }
                }
            })
        }
    }
    
    func storeWithUserID(imageUrl : String) {
        let databaseRef = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!)
        self.imageUrls.append(imageUrl)
        //TODO: should be user-based
        let values = ["firstName": "gisu", "lastName": "Kim", "email": "gisu@gmail.com","imageUrls": self.imageUrls] as [String : Any]
        databaseRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
            }
            
            //TODO: update UI to see the image added
            DispatchQueue.main.async {
                //TODO: update current user's info with a new image added
                self.currentUser?.imageUrls?.append(imageUrl)
                self.mainCell?.reloadData()
                UIAlertController().alertMessage(message: "Your picture added 💖", rootController: self)
            }
        }
    }
}
    
extension MainViewController : iCarouselDelegate, iCarouselDataSource {
   
    func numberOfItems(in carousel: iCarousel) -> Int {
        return self.imageUrls.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        let imageView = UIImageView()
        imageView.loadImageUsingCacheWithUrl(urlString: imageUrls[index])
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
}
    