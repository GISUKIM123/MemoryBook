//
//  SettingCell.swift
//  MemoryBook
//
//  Created by gisu kim on 2018-02-07.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

class SettingCell: UIView {
    
    let userInfoContainer : UIView = {
        let view = UIView()
        
        return view
    }()
    
    let nameLabel : UITextView = {
        let tv = UITextView()
        tv.text = "More Stuff\n theme n' junk"
        tv.textColor = .white
        tv.font = UIFont.boldSystemFont(ofSize: 24)
        tv.backgroundColor = .clear
        return tv
    }()
    
    let settingTableView : UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.black
        tableView.separatorStyle = .none
        
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        
        addSubview(userInfoContainer)
        userInfoContainer.translatesAutoresizingMaskIntoConstraints = false
        [
            userInfoContainer.topAnchor.constraint(equalTo: self.topAnchor),
            userInfoContainer.leftAnchor.constraint(equalTo: self.leftAnchor),
            userInfoContainer.widthAnchor.constraint(equalTo: self.widthAnchor),
            userInfoContainer.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2)
            ].forEach{ $0.isActive = true }
        
        userInfoContainer.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        [
            nameLabel.topAnchor.constraint(equalTo: userInfoContainer.topAnchor, constant: 12),
            nameLabel.leftAnchor.constraint(equalTo: userInfoContainer.leftAnchor, constant: 8),
            nameLabel.widthAnchor.constraint(equalTo: userInfoContainer.widthAnchor, multiplier: 0.5),
            nameLabel.heightAnchor.constraint(equalTo: userInfoContainer.heightAnchor, multiplier: 0.65)
            ].forEach{ $0.isActive = true }
        
        self.settingTableView.register(UITableViewCell.self, forCellReuseIdentifier: "settingId")
        addSubview(settingTableView)
        
        settingTableView.translatesAutoresizingMaskIntoConstraints = false
        [
            settingTableView.topAnchor.constraint(equalTo: userInfoContainer.bottomAnchor),
            settingTableView.leftAnchor.constraint(equalTo: self.leftAnchor),
            settingTableView.widthAnchor.constraint(equalTo: self.widthAnchor),
            settingTableView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8)
            ].forEach{ $0.isActive = true }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
