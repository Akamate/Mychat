//
//  MessageService.swift
//  MyChat
//
//  Created by Aukmate  Chayapiwat on 10/9/2563 BE.
//  Copyright © 2563 Aukmate  Chayapiwat. All rights reserved.
//

import Foundation
import Firebase

class MessageService {
    static let shared = MessageService()
    
    func uploadMessage(_ message : String ,toUser : UserProfile, completion : ((Error?)->Void)?){
        guard let currenUserId = Auth.auth().currentUser?.uid else {return }
        let data = ["text" : message , "fromUserId" : currenUserId , "toUserId" : toUser.uid,"timestamp" : Timestamp(date: Date())] as [String : Any]
        Firestore.firestore().collection("messages").document(currenUserId).collection(toUser.uid).addDocument(data: data) { _ in
            Firestore.firestore().collection("messages").document(toUser.uid).collection(currenUserId).addDocument(data: data,completion: completion)
            Firestore.firestore().collection("messages").document(toUser.uid).collection("latest_message").document(currenUserId).setData(data)
            Firestore.firestore().collection("messages").document(currenUserId).collection("latest_message").document(toUser.uid).setData(data)
        }
        
    }
    
    func fetchMessage(_ toUser : UserProfile, completion : @escaping (([Message])->Void)){
        var messages = [Message]()
        guard let currenUserId = Auth.auth().currentUser?.uid else {return }
        let query = Firestore.firestore().collection("messages").document(currenUserId).collection(toUser.uid).order(by: "timestamp")
        
        query.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ change in
                if(change.type == .added){
                    let data = change.document.data()
                    let message = Message(dictionary: data)
                    messages.append(message)
                    completion(messages)
                }
            })
        }
    }

    func fetchAllChannels(completion : @escaping (([Channel])->Void)) {
        guard let currenUserId = Auth.auth().currentUser?.uid else {return }
        var channels = [Channel]()
        let query = Firestore.firestore().collection("messages").document(currenUserId).collection("latest_message").order(by: "timestamp")
        query.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ (change) in
                let dict = change.document.data()
                let message = Message(dictionary: dict)
                self.fetchUser(uid: message.toUserId) { (user) in
                    let channel = Channel(user: user, message: message)
                    channels.append(channel)
                    completion(channels)
                }
            })
        }
    }
    
    func fetchUser(uid : String,completion : @escaping ((UserProfile)->Void)) {
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, error) in
            guard let dict = snapshot?.data() else {return }
            let user = UserProfile(data: dict)
            completion(user)
        }
    }
}

