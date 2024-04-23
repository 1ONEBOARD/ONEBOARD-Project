//
//  LoginPageController.swift
//  OneBoardProject
//

import UIKit

class LoginPageController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let targetStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let targetVC = targetStoryboard.instantiateViewController(withIdentifier: "MainPage")
        
        if targetVC != nil {
            targetVC.modalPresentationStyle = .fullScreen
            present(targetVC, animated: true, completion: nil)
        } else {
            print("Failed to instantiate view controller with identifier 'MainPage'")
        }
    }

    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        guard let signUpVC = storyboard?.instantiateViewController(withIdentifier: "SignUpPage") else {
            return
        }
        
        signUpVC.modalPresentationStyle = .fullScreen
        present(signUpVC, animated: true, completion: nil)
    }
}
