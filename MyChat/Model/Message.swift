//
//  message.swift
//  MyChat
//
//  Created by Aukmate  Chayapiwat on 10/9/2563 BE.
//  Copyright © 2563 Aukmate  Chayapiwat. All rights reserved.
//

import Foundation
import Firebase

struct Message {
    let text : String
    let isFromCurrentUser : Bool
    let fromUserId : String
    let toUserId : String
    var timeStamp : Timestamp!
    var user : UserProfile?
    
    init(dictionary : [String : Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.fromUserId = dictionary["fromUserId"] as? String ?? ""
        self.toUserId = dictionary["toUserId"] as? String ?? ""
        self.timeStamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
        self.isFromCurrentUser = fromUserId == Auth.auth().currentUser?.uid
        
    }
    
}
