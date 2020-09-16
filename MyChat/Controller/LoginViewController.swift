//
//  LoginViewController.swift
//  MyChat
//
//  Created by Aukmate  Chayapiwat on 8/9/2563 BE.
//  Copyright © 2563 Aukmate  Chayapiwat. All rights reserved.
//

import UIKit
import Combine
import JGProgressHUD
class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    private let LoginVM = LoginViewModel()
    var cancellables = Set<AnyCancellable>()


    private var readyToLogIn: AnyPublisher<Bool, Never> {
       return Publishers
          .CombineLatest(
             emailTextField.textPublisher, passwordTextField.textPublisher
          )
          .map { email, password in
             !email.isEmpty && !password.isEmpty
          }
          .eraseToAnyPublisher()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureGradientLayer()
        configureButton()
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        view.backgroundColor = .systemYellow
    }
    
    func configureGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemGreen.cgColor,UIColor.systemYellow.cgColor]
        gradient.locations = [0,1]
        view.layer.insertSublayer(gradient, at: 0)
        gradient.frame = view.frame
        
    }
    
    func configureButton() {
        loginButton.isEnabled = false
        readyToLogIn
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: loginButton)
            .store(in: &cancellables)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        guard let email = emailTextField.text else {return }
        guard let password = passwordTextField.text else {return }
        showLoader(show: true,text: "Signing In")
        AuthenManager.shared.userSignIn(email: email, password: password) { (result, error) in
            if let error = error {
                self.showLoader(show: false)
                print(error)
                return
            }
            self.showLoader(show: false)
            self.performSegue(withIdentifier: "goToChannels", sender: nil)
        }
    }
}

extension UITextField {

    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField }
            .map { $0.text ?? "" }
            .eraseToAnyPublisher()
    }

}

extension UIViewController {
    static let spinner = JGProgressHUD(style: .dark)
    func showLoader(show : Bool,text : String? = "Loading"){
        UIViewController.spinner.textLabel.text = text
        
        if show {
            UIViewController.spinner.show(in: view)
        }
        else {
            UIViewController.spinner.dismiss()
        }
        
    }
}
