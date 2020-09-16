//
//  RegistrationViewController.swift
//  MyChat
//
//  Created by Aukmate  Chayapiwat on 8/9/2563 BE.
//  Copyright © 2563 Aukmate  Chayapiwat. All rights reserved.
//

import UIKit
import Firebase
class RegistrationViewController: UIViewController {

    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var profileImage : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGradientLayer()
        profileButton.imageView?.clipsToBounds = true
        // Do any additional setup after loading the view.
    }

    func configureGradientLayer() {
           let gradient = CAGradientLayer()
           gradient.colors = [UIColor.systemGreen.cgColor,UIColor.systemYellow.cgColor]
           gradient.locations = [0,1]
           view.layer.insertSublayer(gradient, at: 0)
           gradient.frame = view.frame
           
       }
    
    @IBAction func selectPhoto(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        present(imagePickerController,animated: true,completion: nil)
    }
    
    @IBAction func handleSignUp(_ sender: Any) {
        guard let email = emailTextfield.text else {return}
        guard let username = usernameTextfield.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let profileImage = profileButton.imageView?.image else {return}
        
        let credential = RegisCredential(email: email, password: password, username: username, profileImage: profileImage)
        showLoader(show: true,text: "Signing Up")
        AuthenManager.shared.createUser(credentials: credential) { (error) in
            if let error = error {
                print(error)
                self.showLoader(show: false)
                return
            }
            self.showLoader(show: false)
            self.showLoader(show: false)
            self.performSegue(withIdentifier: "gotoChannels", sender: nil)
        }
    }
    @IBAction func goBackSignIn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension RegistrationViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        profileButton.setImage(image, for: .normal)
        profileButton.layer.cornerRadius = 200/2
        profileButton.layer.borderWidth = 2.0
        profileButton.imageView?.contentMode = .scaleAspectFill
        dismiss(animated: true, completion: nil)
    }
}
