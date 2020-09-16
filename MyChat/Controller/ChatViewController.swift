//
//  ChatViewController.swift
//  MyChat
//
//  Created by Aukmate  Chayapiwat on 10/9/2563 BE.
//  Copyright © 2563 Aukmate  Chayapiwat. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MsgCell"

class ChatViewController: UICollectionViewController {

    public var user : UserProfile?
    var messages = [Message]()
    var fromCurrentUser = true
    
    private lazy var inpView : MsgInputView = {
        let inv = MsgInputView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        inv.delegate = self
        return inv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        configureNavigationBar()
        configureCell()
        fetchMsg()
    }
    
    override var inputAccessoryView: UIView?{
        get {return inpView}
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func configureNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isHidden = false
        self.navigationItem.setHidesBackButton(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = user?.username
        let apperance = UINavigationBarAppearance()
        apperance.titleTextAttributes = [.foregroundColor : UIColor.white]
        apperance.backgroundColor = .systemGreen
        navigationController?.navigationBar.standardAppearance = apperance
        navigationController?.navigationBar.scrollEdgeAppearance = apperance
        navigationController?.navigationBar.compactAppearance = apperance
        navigationController?.navigationBar.isTranslucent = true
    }

    func configureCell() {
        collectionView.register(MsgCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical = true
    }
    
    func fetchMsg() {
        MessageService.shared.fetchMessage(user!) { [weak self] (messages) in
            self?.messages = messages
            self?.collectionView.reloadData()
            self?.collectionView.scrollToItem(at: IndexPath(item: messages.count-1, section: 0), at: .bottom, animated: true)
        }
    }
}

extension ChatViewController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MsgCell
        cell.message = messages[indexPath.row]
        cell.message?.user = user
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
}

extension ChatViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let estimatedSizeCell = MsgCell(frame: frame)
        estimatedSizeCell.message = messages[indexPath.row]
        estimatedSizeCell.layoutIfNeeded()
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(targetSize)
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: -10)
    }
    
   
}

extension ChatViewController : MsgInputViewDelegate {
    func inputView(inputView: UIView, text: String) {
        MessageService.shared.uploadMessage(text, toUser: user!) { (error) in
            if let error = error {
                print("Failed to upload message")
                return
            }
        }
        collectionView.reloadData()
    }
    
}
