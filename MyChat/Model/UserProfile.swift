//
//  UserProfile.swift
//  MyChat
//
//  Created by Aukmate  Chayapiwat on 9/9/2563 BE.
//  Copyright © 2563 Aukmate  Chayapiwat. All rights reserved.
//

import Foundation

struct UserProfile {
    let email : String
    let uid : String
    let username : String
    let profileImgUrl : String
    
    init(data : [String : Any]) {
        self.email = data["email"] as? String ?? ""
        self.uid = data["uid"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
        self.profileImgUrl = data["profileImgUrl"] as? String ?? ""
    }
}
