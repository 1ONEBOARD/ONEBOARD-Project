//
//  RegistViewController.swift
//  OneBoardProject
//
//  Created by 문기웅 on 4/22/24.
//

import UIKit

class RegistViewController: UIViewController {

    @IBOutlet weak var registNmaeTextField: UITextField!
    @IBOutlet weak var registIDTextField: UITextField!
    @IBOutlet weak var registPasswordTextField: UITextField!
    
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

    }

}
