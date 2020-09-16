//
//  UserService.swift
//  MyChat
//
//  Created by Aukmate  Chayapiwat on 9/9/2563 BE.
//  Copyright © 2563 Aukmate  Chayapiwat. All rights reserved.
//

import Foundation
import Firebase

class UserService {
    static let shared = UserService()
    
    func fetchAllUsers(completion: @escaping([UserProfile])->Void) {
        var users = [UserProfile]()
        Firestore.firestore().collection("users").getDocuments { [weak self] (snapshot, error) in
            snapshot?.documents.forEach({ (document) in
                let data = document.data()
                let user = UserProfile(data: data)
                users.append(user)
            })
            completion(users)
        }
    }
}
