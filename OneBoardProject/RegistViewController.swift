//
//  RegistViewController.swift
//  OneBoardProject
//
//  Created by 문기웅 on 4/22/24.
//

import UIKit
import CoreData

class RegistViewController: UIViewController, UITextFieldDelegate {
    
    // PersistentContainer에 접근
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }

    @IBOutlet weak var registNmaeTextField: UITextField!
    @IBOutlet weak var registIDTextField: UITextField!
    @IBOutlet weak var registPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    func registTextFieldSetUp() {
        // TextField 라운드 처리
        registNmaeTextField.borderStyle = .roundedRect
        registIDTextField.borderStyle = .roundedRect
        registPasswordTextField.borderStyle = .roundedRect
        
        // TextField 클리어 기능
        registNmaeTextField.clearButtonMode = .always
        registIDTextField.clearButtonMode = .always
        registPasswordTextField.clearButtonMode = .always
    }
    
    // 화면 터치 시 TextField 키보드 내려가는 기능
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
             self.view.endEditing(true)
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registTextFieldSetUp()
        
        // 회원가입 버튼 라운드처리
        self.registerButton.layer.masksToBounds = true
        self.registerButton.layer.cornerRadius = 6
        
        self.registNmaeTextField.delegate = self
        self.registIDTextField.delegate = self
        self.registPasswordTextField.delegate = self
        
        // TextField 입력값 변경 감지
        self.registNmaeTextField.addTarget(self, action: #selector(self.TextFieldDidChanged(_:)), for: .editingChanged)
        self.registIDTextField.addTarget(self, action: #selector(self.TextFieldDidChanged(_:)), for: .editingChanged)
        self.registPasswordTextField.addTarget(self, action: #selector(self.TextFieldDidChanged(_:)), for: .editingChanged)
    }
    
    // TextField 입력값 변하면 유효성 검사
    @objc func TextFieldDidChanged(_ sender: UITextField) {
        // 3개의 TextField가 채워졌는지 확인
        if !(self.registNmaeTextField.text?.isEmpty ?? true) && !(self.registIDTextField.text?.isEmpty ?? true) && !(self.registPasswordTextField.text?.isEmpty ?? true) {
            updateRegisterButton(willActive: true)
        } else {
            updateRegisterButton(willActive: false)
        }
    }
    
    func updateRegisterButton(willActive: Bool) {
        if (willActive == true) {
            self.registerButton.backgroundColor = UIColor(named: "GcooColor")
        } else {
            self.registerButton.backgroundColor = UIColor(named: "defaultsColor")
        }
    }

}
