//
//  LoginViewViewController.swift
//  iOSGigs
//
//  Created by Dongwoo Pae on 5/30/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class LoginViewViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpandLogInSegmentedControl: UISegmentedControl!
    @IBOutlet weak var signUpLogInButton: UIButton!
    
    var gigController: GigController!
    
    enum LoginType {
        case signUp
        case logIn
    }
    
    var loginType = LoginType.signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpLogInButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
        signUpLogInButton.tintColor = .white
        signUpLogInButton.layer.cornerRadius = 8.0
        
        signUpLogInButton.setTitle("Sign Up", for: .normal)

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation

    
    @IBAction func signUpLogInTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.loginType = .signUp
            self.signUpLogInButton.setTitle("Sign Up", for: .normal)
        } else {
            self.loginType = .logIn
            self.signUpLogInButton.setTitle("Log In", for: .normal)
        }
    }
    
    
    
    
    @IBAction func signUpLogInButtonTapped(_ sender: Any) {
        if let username = self.usernameTextField.text,
            !username.isEmpty,
            let password = self.passwordTextField.text,
            !password.isEmpty {
            let user = User(username: username, password: password)
            
            if loginType == .signUp {
                self.gigController.signUp(with: user) { (error) in
                    if let error = error {
                        NSLog("Error occurred during sign up: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in", preferredStyle: .actionSheet)
                            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true, completion: {
                                self.loginType = .logIn
                                self.signUpandLogInSegmentedControl.selectedSegmentIndex = 1
                                self.signUpLogInButton.setTitle("Log In", for: .normal)
                            })
                        }
                    }
                }
            } else {
                gigController.signUp(with: user) { (error) in
                    if let error = error {
                        NSLog("Error occurred during sign up: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
}
