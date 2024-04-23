//
//  RegistViewController.swift
//  OneBoardProject
//
//  Created by 문기웅 on 4/22/24.
//

import UIKit
import CoreData

class RegistViewController: UIViewController {
    
    // PersistentContainer에 접근
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    @IBOutlet weak var registNmaeTextField: UITextField!
    @IBOutlet weak var registIDTextField: UITextField!
    @IBOutlet weak var registPasswordTextField: UITextField!
    @IBOutlet weak var checkPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var nameInformLabel: UILabel!
    @IBOutlet weak var idInformLabel: UILabel!
    @IBOutlet weak var passwordInformLabel: UILabel!
    @IBOutlet weak var passwordCheckInformLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registTextFieldSetUp()
        
        self.registNmaeTextField.delegate = self
        self.registIDTextField.delegate = self
        self.registPasswordTextField.delegate = self
        self.checkPasswordTextField.delegate = self
        
        
        // 회원가입 버튼 라운드처리
        self.registerButton.layer.masksToBounds = true
        self.registerButton.layer.cornerRadius = 6
        
        // TextField 입력값 변경 감지
        self.registNmaeTextField.addTarget(self, action: #selector(self.TextFieldDidChanged(_:)), for: .editingChanged)
        self.registIDTextField.addTarget(self, action: #selector(self.TextFieldDidChanged(_:)), for: .editingChanged)
        self.registPasswordTextField.addTarget(self, action: #selector(self.TextFieldDidChanged(_:)), for: .editingChanged)
        self.checkPasswordTextField.addTarget(self, action: #selector(self.TextFieldDidChanged(_:)), for: .editingChanged)
        
        resetForm()
    }
    
    func resetForm() {
        registNmaeTextField.text = ""
        registIDTextField.text = ""
        registPasswordTextField.text = ""
        checkPasswordTextField.text = ""
    }
    
    //가리기 버튼
    
    @IBOutlet weak var passwordEyeButton: UIButton!
    @IBAction func tappedPWEyeButton(_ sender: Any) {
        registPasswordTextField.isSecureTextEntry.toggle()
        passwordEyeButton.isSelected.toggle()
    }
    
    
    @IBOutlet weak var pwCheckEyeButton: UIButton!
    @IBAction func tappedPWCheckEyeButton(_ sender: Any) {
        checkPasswordTextField.isSecureTextEntry.toggle()
        pwCheckEyeButton.isSelected.toggle()
    }
    
    
    
    // TextField 유효성 검사
    @IBAction func nameChanged(_ sender: Any) {
        
    }
    
    @IBAction func idChanged(_ sender: Any) {
        if let id = registIDTextField.text {
            if let errorMessage = invalidID(id) {
                idInformLabel.text = errorMessage
                idInformLabel.textColor = .red
            }
            else {
                idInformLabel.text = "사용 가능한 아이디입니다."
                idInformLabel.textColor = UIColor(named: "GcooColor")
            }
        }
    }
    
    func invalidID(_ value: String) -> String? {
        let reqularExpression = "^(?=.*[A-Za-z])(?=.*[0-9]).{8,16}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        if !predicate.evaluate(with: value) {
            return "알맞지 않은 형식입니다."
        }
        return nil
    }
    
    
    @IBAction func passwordChanged(_ sender: Any) {
        if let password = registPasswordTextField.text {
            if let errorMessage = invalidPassword(password) {
                passwordInformLabel.text = errorMessage
                passwordInformLabel.textColor = .red
            }
            else {
                passwordInformLabel.text = "사용 가능한 비밀번호입니다."
                passwordInformLabel.textColor = UIColor(named: "GcooColor")
            }
        }
    }
    
    func invalidPassword(_ value: String) -> String? {
        let reqularExpression2 = "^(?=.*[A-Za-z])(?=.*[0-9]).{8,16}"
        let predicate2 = NSPredicate(format: "SELF MATCHES %@", reqularExpression2)
        if !predicate2.evaluate(with: value) {
            return "알맞지 않은 형식입니다"
        }
        return nil
    }
    
}

extension RegistViewController: UITextFieldDelegate {
    func registTextFieldSetUp() {
        // TextField 라운드 처리
        registNmaeTextField.borderStyle = .roundedRect
        registIDTextField.borderStyle = .roundedRect
        registPasswordTextField.borderStyle = .roundedRect
        checkPasswordTextField.borderStyle = .roundedRect
        
        // TextField 클리어 기능
        registNmaeTextField.clearButtonMode = .always
        registIDTextField.clearButtonMode = .always
        registPasswordTextField.clearButtonMode = .always
        checkPasswordTextField.clearButtonMode = .always
        
        // TextField 키보드 형태 설정
        registNmaeTextField.keyboardType = .default
        registIDTextField.keyboardType = .asciiCapable
        registPasswordTextField.keyboardType = .asciiCapable
        checkPasswordTextField.keyboardType = .asciiCapable
        
        // inform label 숨기기
        nameInformLabel.isHidden = true
        passwordCheckInformLabel.isHidden = true
        
        // 회원가입 버튼 기본 비활성화
        registerButton.isEnabled = false
    }
    
    // 화면 터치 시 TextField 키보드 내려가는 기능
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
             self.view.endEditing(true)
       }
    
    // 비밀번호 확인
    func isSamePassword(_ first: UITextField, _ second: UITextField) -> Bool {
        if (first.text == second.text) {
            self.passwordCheckInformLabel.isHidden = false
            self.passwordCheckInformLabel.text = "비밀번호가 일치합니다."
            self.passwordCheckInformLabel.textColor = UIColor(named: "GcooColor")
            return true
        } else {
            self.passwordCheckInformLabel.isHidden = false
            self.passwordCheckInformLabel.text = "비밀번호가 일치하지 않습니다."
            self.passwordCheckInformLabel.textColor = .red
            return false
        }
    }
    
    // TextField 입력값 변하면 유효성 검사
    @objc func TextFieldDidChanged(_ sender: UITextField) {
        // 4개의 TextField가 채워졌는지 확인 & 비밀번호 일치성 여부확인
        if !(self.registNmaeTextField.text?.isEmpty ?? true) && !(self.registIDTextField.text?.isEmpty ?? true) && !(self.registPasswordTextField.text?.isEmpty ?? true) && !(self.checkPasswordTextField.text?.isEmpty ?? true) && isSamePassword(registPasswordTextField, checkPasswordTextField) {
            updateRegisterButton(willActive: true)
        } else {
            updateRegisterButton(willActive: false)
        }
    }
    
    func updateRegisterButton(willActive: Bool) {
        if (willActive == true) {
            self.registerButton.backgroundColor = UIColor(named: "GcooColor")
            registerButton.isEnabled = true
        } else {
            self.registerButton.backgroundColor = UIColor(named: "defaultsColor")
            registerButton.isEnabled = false
        }
    }
    

}


