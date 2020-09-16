//
//  UserCell.swift
//  MyChat
//
//  Created by Aukmate  Chayapiwat on 9/9/2563 BE.
//  Copyright © 2563 Aukmate  Chayapiwat. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class UserCell : UITableViewCell {
    
    public let profileImgView : UIImageView = {
        let imv = UIImageView()
        imv.backgroundColor = .systemRed
        imv.contentMode = .scaleAspectFill
        imv.clipsToBounds = true
        return imv
    }()
    
    public let usernameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    var user : UserProfile? {
        didSet {
            configureCell()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureProfileImageView()
        configureUsernameLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureProfileImageView() {
        addSubview(profileImgView)
        profileImgView.translatesAutoresizingMaskIntoConstraints = false
        profileImgView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImgView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        profileImgView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        profileImgView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImgView.layer.cornerRadius = 60/2
    }
    
    func configureUsernameLabel() {
        addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: profileImgView.rightAnchor, constant: 15).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func configureCell() {
        guard let user = self.user else {return}
        usernameLabel.text = user.username
        guard let url = URL(string: user.profileImgUrl) else {return}
        profileImgView.sd_setImage(with: url, completed: nil)
        
    }
}
