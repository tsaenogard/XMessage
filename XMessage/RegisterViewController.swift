//
//  RegisterViewController.swift
//  loginTest
//
//  Created by Eric Chen on 2017/7/13.
//  Copyright © 2017年 MasB1ue. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase

class RegisterViewController: UIViewController {
    var nameTextField: SkyFloatingLabelTextFieldWithIcon!
    var emailTextField: SkyFloatingLabelTextFieldWithIcon!
    var passwordTextField: SkyFloatingLabelTextFieldWithIcon!
    var rePasswordTextField: SkyFloatingLabelTextFieldWithIcon!
    var checkBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        self.view.backgroundColor = UIColor.white
        
        self.nameTextField = SkyFloatingLabelTextFieldWithIcon()
        self.nameTextField.placeholder = "請輸入名稱"
        self.nameTextField.title = "名稱"
        self.nameTextField.iconFont = UIFont.fontAwesome(ofSize: 15)
        self.nameTextField.iconText = "\u{f2c0}"
        self.nameTextField.clearButtonMode = .whileEditing
        self.nameTextField.keyboardType = .default
        self.nameTextField.returnKeyType = .next
        self.view.addSubview(self.nameTextField)
        
        self.emailTextField = SkyFloatingLabelTextFieldWithIcon()
        self.emailTextField.placeholder = "請輸入e-mail"
        self.emailTextField.title = "e-mail"
        self.emailTextField.iconFont = UIFont.fontAwesome(ofSize: 15)
        self.emailTextField.iconText = "\u{f0e0}"
        self.emailTextField.clearButtonMode = .whileEditing
        self.emailTextField.autocapitalizationType = .none
        self.emailTextField.keyboardType = .emailAddress
        self.emailTextField.errorColor = UIColor.red
        self.emailTextField.delegate = self
        self.emailTextField.returnKeyType = .next
        self.view.addSubview(self.emailTextField)
        
        self.passwordTextField = SkyFloatingLabelTextFieldWithIcon()
        self.passwordTextField.placeholder = "請輸入密碼"
        self.passwordTextField.title = "密碼"
        self.passwordTextField.iconFont = UIFont.fontAwesome(ofSize: 15)
        self.passwordTextField.iconText = "\u{f023}"
        self.passwordTextField.clearButtonMode = .whileEditing
        self.passwordTextField.autocapitalizationType = .none
        self.passwordTextField.keyboardType = .default
        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.returnKeyType = .next
        self.view.addSubview(self.passwordTextField)
        
        self.rePasswordTextField = SkyFloatingLabelTextFieldWithIcon()
        self.rePasswordTextField.placeholder = "再次輸入密碼"
        self.rePasswordTextField.title = "密碼"
        self.rePasswordTextField.iconFont = UIFont.fontAwesome(ofSize: 15)
        self.rePasswordTextField.iconText = "\u{f023}"
        self.rePasswordTextField.clearButtonMode = .whileEditing
        self.rePasswordTextField.autocapitalizationType = .none
        self.rePasswordTextField.keyboardType = .default
        self.rePasswordTextField.isSecureTextEntry = true
        self.rePasswordTextField.returnKeyType = .done
        self.view.addSubview(self.rePasswordTextField)
        
        self.checkBtn = UIButton()
        self.checkBtn.setTitle("註冊", for: .normal)
        self.checkBtn.setTitleColor(UIColor.white, for: .normal)
        self.checkBtn.backgroundColor = UIColor.blue
        self.checkBtn.layer.cornerRadius = 8.0
        self.checkBtn.layer.borderWidth = 1.0
        self.checkBtn.layer.borderColor = UIColor.darkGray.cgColor
        self.checkBtn.addTarget(self, action: #selector(onBtnAction(_:)), for: .touchUpInside)
        self.view.addSubview(self.checkBtn)
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        let gap: CGFloat = 10
        self.nameTextField.frame = CGRect(x: 40, y: UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height)! + gap, width: UIScreen.main.bounds.width - 80, height: 50)
        
        self.emailTextField.frame = CGRect(x: 40, y: self.nameTextField.frame.maxY + gap, width: UIScreen.main.bounds.width - 80, height: 50)
        
        self.passwordTextField.frame = CGRect(x: 40, y: self.emailTextField.frame.maxY + gap, width: UIScreen.main.bounds.width - 80, height: 50)
        
        self.rePasswordTextField.frame = CGRect(x: 40, y: self.passwordTextField.frame.maxY + gap, width: UIScreen.main.bounds.width - 80, height: 50)
        
        self.checkBtn.frame = CGRect(x: 0, y: self.rePasswordTextField.frame.maxY + gap * 2, width: 100, height: 50)
        self.checkBtn.center.x = self.view.center.x
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.becomeFirstResponder()
    }
    
    //MARK: - selector
    
    func onBtnAction(_ sender: UIButton) {
        guard let name = nameTextField.text, name != "",
            let email = emailTextField.text, email != "",
            let password = passwordTextField.text, password != "",
        rePasswordTextField.text == password else {
                let alertController = UIAlertController(title: "註冊失敗", message: "請確認輸入資料符合格式", preferredStyle: .alert)
                let alertAction1 = UIAlertAction(title: "確定", style: .default, handler: nil)
                alertController.addAction(alertAction1)
                self.present(alertController, animated: true, completion: nil)
                return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                let alertController = UIAlertController(title: "註冊失敗", message: error.localizedDescription, preferredStyle: .alert)
                let alertAction1 = UIAlertAction(title: "確定", style: .default, handler: nil)
                alertController.addAction(alertAction1)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                changeRequest.displayName = name
                changeRequest.commitChanges(completion: { (error) in
                    if let error = error {
                        print("Failed to change the display name: \(error.localizedDescription)")
                    }
                })
            }
            self.view.endEditing(true)
            
            user?.sendEmailVerification(completion: nil)
            
            let alertController = UIAlertController(title: "email驗證", message: "email驗證已經寄至你的信箱，請前往信箱確認以完成註冊", preferredStyle: .alert)
            let alertAction1 = UIAlertAction(title: "確定", style: .default, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
                
            })
            alertController.addAction(alertAction1)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    
}

extension RegisterViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                if (text.characters.count < 3 || !text.contains("@")) {
                    floatingLabelTextField.errorMessage = "Invalid email"
                }else {
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
        return true
    }
}
