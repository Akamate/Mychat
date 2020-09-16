//
//  MsgCell.swift
//  MyChat
//
//  Created by Aukmate  Chayapiwat on 10/9/2563 BE.
//  Copyright © 2563 Aukmate  Chayapiwat. All rights reserved.
//

import UIKit
import SDWebImage
class MsgCell: UICollectionViewCell {
    
    var message : Message? {
        didSet {
            setMsg()
        }
    }
    
    var textContainerLeftAnchor : NSLayoutConstraint!
    var textContainerRightAnchor : NSLayoutConstraint!
    
    public let profileImgView : UIImageView = {
        let imv = UIImageView()
        imv.contentMode = .scaleAspectFill
        imv.clipsToBounds = true
        return imv
    }()
    
    public let usernameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    public let msgTextContainer : UIView = {
        let tc = UIView()
        tc.backgroundColor = .systemGreen
        return tc
    }()
    
    public let msgTextView : UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textColor = .white
        textView.text = "Hello Lady and Gentleman"
        textView.backgroundColor = .clear
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureProfileImageView()
        configureMsgContainer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureProfileImageView() {
        addSubview(profileImgView)
        profileImgView.translatesAutoresizingMaskIntoConstraints = false
        profileImgView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        profileImgView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        profileImgView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImgView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        profileImgView.layer.cornerRadius = 16
    }
    
    func configureMsgContainer(){
        addSubview(msgTextContainer)
        msgTextContainer.translatesAutoresizingMaskIntoConstraints = false
        
        msgTextContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        msgTextContainer.layer.cornerRadius = 12
        textContainerLeftAnchor = msgTextContainer.leftAnchor.constraint(equalTo: profileImgView.rightAnchor, constant: 5)
        textContainerLeftAnchor.isActive = false
        textContainerRightAnchor = msgTextContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
        textContainerRightAnchor.isActive = false
        
        msgTextContainer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        msgTextContainer.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        msgTextContainer.addSubview(msgTextView)
        msgTextView.leftAnchor.constraint(equalTo: msgTextContainer.leftAnchor, constant: 5).isActive = true
        msgTextView.topAnchor.constraint(equalTo: msgTextContainer.topAnchor, constant: 1).isActive = true
        msgTextView.rightAnchor.constraint(equalTo: msgTextContainer.rightAnchor, constant: -12).isActive = true
        msgTextView.bottomAnchor.constraint(equalTo: msgTextContainer.bottomAnchor, constant: -1).isActive = true
        msgTextView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setMsg() {
        guard let msg = message else {return }
        let msgVM = MessageViewModel(message: msg)
        msgTextContainer.backgroundColor = msgVM.msgBackgroundColor
        msgTextView.textColor = msgVM.msgTextColor
        msgTextView.text = msg.text
        textContainerLeftAnchor.isActive = msgVM.leftAnchorActive
        textContainerRightAnchor.isActive = msgVM.rightAnchorActive
        profileImgView.isHidden = msgVM.shouldHideImgProfile
        if(msgVM.profileImgURL != nil) {
            profileImgView.sd_setImage(with: msgVM.profileImgURL)
        }
    }
}
