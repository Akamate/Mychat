//
//  MsgInputView.swift
//  MyChat
//
//  Created by Aukmate  Chayapiwat on 10/9/2563 BE.
//  Copyright © 2563 Aukmate  Chayapiwat. All rights reserved.
//

import UIKit
protocol MsgInputViewDelegate : class {
    func inputView(inputView : UIView , text : String)
}

class MsgInputView: UIView {
    
    private let msgInputTextView : UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        return textView
    }()
    
    private let sendButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SEND", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(sendMsg), for: .touchUpInside)
        return button
    }()
    
    weak var delegate : MsgInputViewDelegate?
    
    override init(frame : CGRect) {
        super.init(frame: frame)
        autoresizingMask = .flexibleHeight
        layer.shadowOpacity = 0.25
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = .init(width: 0, height: 1)
        backgroundColor = .white
        setupButton()
        setupTextView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButton() {
        addSubview(sendButton)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.topAnchor.constraint(equalTo: topAnchor,constant: 4).isActive = true
        sendButton.rightAnchor.constraint(equalTo: rightAnchor,constant: -8).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupTextView() {
        addSubview(msgInputTextView)
        msgInputTextView.translatesAutoresizingMaskIntoConstraints = false
        msgInputTextView.topAnchor.constraint(equalTo: topAnchor,constant: 12).isActive = true
        msgInputTextView.rightAnchor.constraint(equalTo: sendButton.leftAnchor,constant: -8).isActive = true
        msgInputTextView.leftAnchor.constraint(equalTo: leftAnchor,constant: 20).isActive = true
        msgInputTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,constant: -4).isActive = true
    }
    
    @objc func sendMsg() {
        guard let text = msgInputTextView.text, msgInputTextView.text.count > 1 else {return }
        delegate?.inputView(inputView: self, text: text)
        msgInputTextView.text = ""
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
}
