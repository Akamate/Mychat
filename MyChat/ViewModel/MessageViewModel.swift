//
//  MessageViewModel.swift
//  MyChat
//
//  Created by Aukmate  Chayapiwat on 10/9/2563 BE.
//  Copyright © 2563 Aukmate  Chayapiwat. All rights reserved.
//

import Foundation
import UIKit

class MessageViewModel {
    private let message : Message
    
    var msgBackgroundColor : UIColor {
        return message.isFromCurrentUser ? .lightGray : .systemGreen
    }
    
    var msgTextColor : UIColor {
        return message.isFromCurrentUser ? .black : .white
    }
    
    var shouldHideImgProfile : Bool {
        return message.isFromCurrentUser
    }
    
    var leftAnchorActive : Bool {
        return !message.isFromCurrentUser
    }
    
    var rightAnchorActive : Bool {
        return message.isFromCurrentUser
    }
    
    var profileImgURL : URL? {
        guard let user = message.user else { return nil}
        return URL(string: user.profileImgUrl)
    }
    init(message : Message) {
        self.message = message
    }
    
    
}
