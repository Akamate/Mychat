//
//  AuthenManager.swift
//  MyChat
//
//  Created by Aukmate  Chayapiwat on 8/9/2563 BE.
//  Copyright © 2563 Aukmate  Chayapiwat. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

struct RegisCredential {
    let email : String
    let password : String
    let username : String
    let profileImage : UIImage
}

class AuthenManager {
    static let shared  = AuthenManager()
    
    func userSignIn(email : String , password : String,completion : @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password,completion: completion)
        
    }
    
    func createUser (credentials : RegisCredential,completion : ((Error?)->Void)?){
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else {return }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images\(filename)")
        
        ref.putData(imageData,metadata: nil){ (meta,error) in
            if let error = error {
                print(error)
                return
            }
            ref.downloadURL { (url, error) in
                if let error = error {
                    print(error)
                    return
                }
                let profileImgUrl = url?.absoluteString
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                    guard let uid = result?.user.uid else {return}
                    let data = [
                        "email" : credentials.email,
                        "username" : credentials.username,
                        "password" : credentials.password,
                        "profileImgUrl" : profileImgUrl,
                        "uid" : uid
                    ]
                    
                    Firestore.firestore().collection("users").document(uid).setData(data as [String : Any],completion: completion)
                }
                
            }
        }
    }
    
    func userLogout (){
        
    }
}
