//
//  LoginPageController.swift
//  OneBoardProject
//

import UIKit

class LoginPageController: UIViewController, UITextFieldDelegate {

    // MARK: - User Info
    struct UserInfo {
        var userName: String
        var id: String
        var password: String
    }
    
    let users: [UserInfo] = [
         UserInfo(userName: "user1", id: "userid1", password: "userpw1"),
         UserInfo(userName: "user2", id: "userid2", password: "userpw2"),
         UserInfo(userName: "user3", id: "userid2", password: "userpw3")
    ]
    
    
    // MARK: - Outlets
    @IBOutlet weak var IDTextField: UITextField!
    @IBOutlet weak var PWTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var errorAlertLabel: UILabel!
    @IBOutlet weak var loginButtonTopConstraint: NSLayoutConstraint!
    
    
    // MARK: - Properties
    var showPasswordButton = UIButton(type: .custom)
    let clearButtonID = UIButton(type: .custom)
    let clearButtonPW = UIButton(type: .custom)
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        guard let password = PWTextField.text, !password.isEmpty else {
            print("Please enter a password")
            showErrorAlert(message: "비밀번호를 입력해 주세요.")
            return
        }
        
        // login -> main 화면 전환
        if let matchedUserInfo = users.first(where: { $0.id == userID && $0.password == password }) {
            print("Login successful: \(matchedUserInfo.userName)")
            let targetStoryboard = UIStoryboard(name: "Main", bundle: nil)

            let targetVC = targetStoryboard.instantiateViewController(withIdentifier: "MainPage")

            if targetVC != nil {
                targetVC.modalPresentationStyle = .fullScreen
                present(targetVC, animated: true, completion: nil)
            } else {
                print("화면 전환 실패, login -> main")
            }
        } else {
            print("아이디 또는 비밀번호가 일치하지 않습니다")
            showErrorAlert(message: "아이디 또는 비밀번호가 일치하지 않습니다. 다시 확인해 주세요.")
        }
        
        print("userID: \(userID)")
        print("password: \(password)")
    }


    // sign-up button
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        guard let signUpVC = storyboard?.instantiateViewController(withIdentifier: "SignUpPage") else {
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
    
    
    // MARK: - Alert Message
    func showErrorAlert(message: String) {
        errorAlertLabel.text = message
        
        UIView.animate(withDuration: 0.3) {
            self.errorAlertLabel.isHidden = false
            self.errorAlertLabel.alpha = 1.0
            self.loginButtonTopConstraint.constant = 30
            self.view.layoutIfNeeded()
        }
    }

    
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""

        UIView.animate(withDuration: 0.3) {
            self.errorAlertLabel.isHidden = true
            self.errorAlertLabel.alpha = 0.3
            self.loginButtonTopConstraint.constant = 16
            self.view.layoutIfNeeded()
        }
    }
}
