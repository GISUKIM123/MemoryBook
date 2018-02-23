//
//  LoginCell.swift
//  MemoryBook
//
//  Created by gisu kim on 2018-02-22.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

class LoginCell: UICollectionViewCell {
    
    let logoImageView : UIImageView = {
        let image = UIImage(named: "memorybook_logo")
        let imageView = UIImageView()
        imageView.image = image
        
        return imageView
    }()
    
    let emailTextField : LeftPaddedTextField = {
        let tf = LeftPaddedTextField()
        tf.placeholder = "Enter Email"
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.borderWidth = 1
        tf.keyboardType = .emailAddress
        
        
        return tf
    }()
    
    let passwordTextField : LeftPaddedTextField = {
        let tf = LeftPaddedTextField()
        tf.placeholder = "Enter password"
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.borderWidth = 1
        tf.isSecureTextEntry = true
        
        return tf
    }()
    
    let loginButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .orange
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(logoImageView)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        [
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -16),
            logoImageView.widthAnchor.constraint(equalToConstant: 160),
            logoImageView.heightAnchor.constraint(equalToConstant: 160)
        ].forEach{ $0.isActive = true }
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        [
            emailTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            emailTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
            emailTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            emailTextField.heightAnchor.constraint(equalToConstant: 50)
            ].forEach{ $0.isActive = true }
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        [
            passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50)
        ].forEach{ $0.isActive = true }
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        [
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            loginButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ].forEach{ $0.isActive = true }
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class LeftPaddedTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
}





