//
//  LoginPageController.swift
//  OneBoardProject
//

import UIKit

class LoginPageController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var IDTextField: UITextField!
    @IBOutlet weak var PWTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var errorAlertLabel: UILabel!
    @IBOutlet weak var loginButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var autoLoginCheck: UIImageView!
    
    // MARK: - Properties
    var showPasswordButton = UIButton(type: .custom)
    let clearButtonID = UIButton(type: .custom)
    let clearButtonPW = UIButton(type: .custom)
    
    var autoLoginEnabled = false
    var userCoreDataManager = UserCoreDataManager.shared
    var userDefaultsManager = UserDefaultsManager.shared

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        print(UserDefaults.standard.bool(forKey: UserDefault.autoLoginEnabled.rawValue))
        
        if UserDefaults.standard.bool(forKey: UserDefault.autoLoginEnabled.rawValue) {
            print("UserDefaults-user")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.navigateToMainPage()
            }
        } else {
            print("No UserDefaults-user found")
            
            errorAlertLabel.isHidden = true
            
            IDTextField.delegate = self
            PWTextField.delegate = self
            
            IDTextField.placeholder = "ID"
            PWTextField.placeholder = "password"
            
            PWTextField.isSecureTextEntry = true
            PWTextField.textContentType = .password
            PWTextField.keyboardType = .asciiCapable
            
            IDTextField.keyboardType = .asciiCapable
            
            // clearButtonID
            clearButtonID.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            clearButtonID.frame = CGRect(x: 40, y: 0, width: 20, height: 20)
            clearButtonID.tintColor = UIColor(named: "defaultsColor")
            
            let IDbuttonContainer = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 20))
            IDbuttonContainer.backgroundColor = .clear
            
            IDbuttonContainer.addSubview(clearButtonID)
            
            IDTextField.rightView = IDbuttonContainer
            IDTextField.rightViewMode = .always
            
            // showPasswordButton
            showPasswordButton.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
            showPasswordButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            showPasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
            showPasswordButton.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
            showPasswordButton.tintColor = UIColor(named: "defaultsColor")
            
            // clearButtonPW
            clearButtonPW.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            clearButtonPW.frame = CGRect(x: 40, y: 0, width: 20, height: 20)
            clearButtonPW.tintColor = UIColor(named: "defaultsColor")
            
            let PWbuttonContainer = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 20))
            
            PWbuttonContainer.addSubview(clearButtonPW)
            PWbuttonContainer.addSubview(showPasswordButton)
            
            PWTextField.rightView = PWbuttonContainer
            PWTextField.rightViewMode = .always
            
            // clear-button, show-password-button 초기 설정
            clearButtonID.isHidden = true
            clearButtonPW.isHidden = true
            showPasswordButton.isHidden = true
            
            clearButtonPW.addTarget(self, action: #selector(clearText(_:)), for: .touchUpInside)
            clearButtonID.addTarget(self, action: #selector(clearText(_:)), for: .touchUpInside)
            
            // auto-login check
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(autoLoginCheckTapped))
            autoLoginCheck.isUserInteractionEnabled = true
            autoLoginCheck.addGestureRecognizer(tapGesture)
            
        }
    }
    
    // text-field isEmpty? hidden
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == IDTextField {
            clearButtonPW.isHidden = true
            showPasswordButton.isHidden = true
            
            clearButtonID.isHidden = textField.text?.isEmpty ?? true
        } else if textField == PWTextField {
            clearButtonID.isHidden = true
            
            clearButtonPW.isHidden = textField.text?.isEmpty ?? true
            showPasswordButton.isHidden = textField.text?.isEmpty ?? true
        }
    }
    
    // MARK: - Button Actions
    // log-in button
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        view.endEditing(true)

        guard let userID = IDTextField.text, !userID.isEmpty else {
            print("Please enter a user ID")
            showErrorAlert(message: "아이디를 입력해 주세요.")
            return
        }
        
        guard let userPassword = PWTextField.text, !userPassword.isEmpty else {
            print("Please enter a password")
            showErrorAlert(message: "비밀번호를 입력해 주세요.")
            return
        }
        
        // login -> main 화면 전환
        guard let users = userCoreDataManager.getUserData() else { return }
        
        if users.filter({ $0.userID == userID && $0.userPassword == userPassword }).count != 0 {
            print("Login successful: \(userID)")
            let userName = userCoreDataManager.getUserNameData(userID: userID)
            userDefaultsManager.setUserDefaults(userID: userID, userName: userName, autoLoginEnabled: autoLoginEnabled)
            navigateToMainPage()
        } else {
            print("아이디 또는 비밀번호가 일치하지 않습니다")
            showErrorAlert(message: "아이디 또는 비밀번호가 일치하지 않습니다.")
        }
        
        print("userID: \(userID)")
        print("password: \(userPassword)")
    }


    // sign-up button
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        let targetStoryboard = UIStoryboard(name: "UserStoryboard", bundle: nil)
        guard let signUpVC = targetStoryboard.instantiateViewController(withIdentifier: "SignUpPage") as? RegistViewController else {
            print("Failed to instantiate RegistViewController from UserStoryboard.")
            return
        }
        
        signUpVC.modalPresentationStyle = .fullScreen
        present(signUpVC, animated: true, completion: nil)
    }
    
    
    // password hidden button
    @objc func togglePasswordVisibility() {
        PWTextField.isSecureTextEntry.toggle()
        let imageName = PWTextField.isSecureTextEntry ? "eye.slash" : "eye"
        showPasswordButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    
    // text-field clear
    @objc func clearText(_ sender: UIButton) {
        if sender == clearButtonPW {
            PWTextField.text = ""
        } else if sender == clearButtonID {
            IDTextField.text = ""
        }
    }
    
    
    // auto-login check
    @objc func autoLoginCheckTapped() {
        UIView.transition(with: autoLoginCheck, duration: 0.3, options: .transitionCrossDissolve, animations: {
            if self.autoLoginCheck.image == UIImage(systemName: "checkmark.circle.fill") {
                self.autoLoginCheck.image = UIImage(systemName: "circle")
                self.autoLoginCheck.tintColor = UIColor(named: "defaultsColor")
                self.autoLoginEnabled = false
            } else {
                self.autoLoginCheck.image = UIImage(systemName: "checkmark.circle.fill")
                self.autoLoginCheck.tintColor = UIColor(named: "GcooColor")
                self.autoLoginEnabled = true
                
            }
        }, completion: nil)
    }

    
    
    // MARK: - Alert Message
    func showErrorAlert(message: String) {
        errorAlertLabel.text = message
        
        UIView.animate(withDuration: 0.3) {
            self.errorAlertLabel.isHidden = false
            self.errorAlertLabel.alpha = 1.0
            self.view.layoutIfNeeded()
        }
    }

    
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""

        UIView.animate(withDuration: 0.3) {
            self.errorAlertLabel.isHidden = true
            self.errorAlertLabel.alpha = 0.3
            self.view.layoutIfNeeded()
        }
    }
    
    
    private func navigateToMainPage() {
        let targetStoryboard = UIStoryboard(name: "UserStoryboard", bundle: nil)
        guard let targetVC = targetStoryboard.instantiateViewController(withIdentifier: "MainPage") as? UINavigationController else {
            print("Failed to instantiate UINavigationController from UserStoryboard.")
            return
        }
        
        targetVC.modalPresentationStyle = .fullScreen
        present(targetVC, animated: true, completion: nil)
    }
}
