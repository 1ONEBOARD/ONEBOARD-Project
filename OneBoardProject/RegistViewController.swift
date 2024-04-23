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
//        addUserInform()
//        getData()
    }
    
    func resetForm() {
        registNmaeTextField.text = ""
        registIDTextField.text = ""
        registPasswordTextField.text = ""
        checkPasswordTextField.text = ""
        
    }
    
    func resetLabelForm() {
        nameInformLabel.isHidden = true
        idInformLabel.text = "영문, 숫자를 포함한 8-16자"
        idInformLabel.textColor = UIColor(named: "defaultsColor")
        passwordInformLabel.text = "영문, 숫자를 포함한 8-16자"
        passwordInformLabel.textColor = UIColor(named: "defaultsColor")
        passwordCheckInformLabel.isHidden = true
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
        if let name = registNmaeTextField.text {
            if let errorMessage = invalidName(name) {
                nameInformLabel.isHidden = false
                nameInformLabel.text = errorMessage
                nameInformLabel.textColor = .red
            }
            else if name.isEmpty {
                nameInformLabel.isHidden = true
            } else {
                nameInformLabel.text = "환영합니다."
                nameInformLabel.textColor = UIColor(named: "GcooColor")
            }
        }
    }
    
    func invalidName(_ value: String) -> String? {
        let reqularExpression = "^[가-힣\\s]*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        if !predicate.evaluate(with: value) {
            return "알맞지 않은 형식입니다."
        }
        return nil
        
    }
    
    @IBAction func idChanged(_ sender: Any) {
        if let id = registIDTextField.text {
            if let errorMessage = invalidID(id) {
                idInformLabel.text = errorMessage
                idInformLabel.textColor = .red
            } else if id.isEmpty {
                idInformLabel.text = "영문, 숫자를 포함한 8-16자"
                idInformLabel.textColor = UIColor(named: "defaultsColor")
            }
            else {
                idInformLabel.text = "사용 가능한 아이디입니다."
                idInformLabel.textColor = UIColor(named: "GcooColor")
            }
        }
    }
    
    func invalidID(_ value: String) -> String? {
        let reqularExpression = "[A-Za-z0-9]{8,16}"
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
            } else if password.isEmpty {
                passwordInformLabel.text = "영문, 숫자를 포함한 8-16자"
                passwordInformLabel.textColor = UIColor(named: "defualtsColor")
            }
            else {
                passwordInformLabel.text = "사용 가능한 비밀번호입니다."
                passwordInformLabel.textColor = UIColor(named: "GcooColor")
            }
        }
    }
    
    
    func invalidPassword(_ value: String) -> String? {
        let reqularExpression = "[A-Za-z0-9]{8,16}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        if !predicate.evaluate(with: value) {
            return "알맞지 않은 형식입니다"
        }
        return nil
    }
    
    // 회원가입 버튼 기능
    
    @IBAction func addUserInfomButton(_ sender: Any) {
        let alert = UIAlertController(title: "회원가입 하시겠습니까?", message: "입력하신 정보로 회원가입이 진행됩니다.", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "예", style: .default, handler: { [self]_ in
            addUserInform()
            resetForm()
            resetLabelForm()
            registDone()
        })
        let cancel = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func registDone() {
        let doneTitle = "환영합니다!"
        let doneMessage = "로그인 버튼을 눌러 로그인을 해주세요."
        
        let alert = UIAlertController(title: doneTitle, message: doneMessage, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            
        }
        
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    // 로그인 버튼
    @IBAction func moveToLoginViewButton(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "loginViewController") else {return}
        self.present(nextVC, animated: true)
    }
    
    
    // coredata에 추가
    func addUserInform() {
        guard let context = self.persistentContainer?.viewContext else {return}
        
        let userInform = Users(context: context)
        
        userInform.userName = registNmaeTextField.text
        userInform.userID = registIDTextField.text
        userInform.userPassword = registPasswordTextField.text
        
        try? context.save()
        
    }
    
    
    
//     확인용
//    func getData() {
//        guard let context = self.persistentContainer?.viewContext else {return}
//
//        let request = Users.fetchRequest()
//        let user = try? context.fetch(request)
//
//        print(user?.count)
//    }
//    
    
    
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
    
    // 회원가입 버튼 활성화
    @objc func TextFieldDidChanged(_ sender: UITextField) {
        if !(self.registNmaeTextField.text?.isEmpty ?? true) &&
            !(self.registIDTextField.text?.isEmpty ?? true) &&
            !(self.registPasswordTextField.text?.isEmpty ?? true) &&
            !(self.checkPasswordTextField.text?.isEmpty ?? true) &&
            isSamePassword(registPasswordTextField, checkPasswordTextField) &&
            (idInformLabel.text == "사용 가능한 아이디입니다.") &&
            (passwordInformLabel.text == "사용 가능한 비밀번호입니다.") &&
            (nameInformLabel.text == "환영합니다.") {
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


