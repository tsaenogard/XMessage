//
//  ForgetViewController.swift
//  loginTest
//
//  Created by Eric Chen on 2017/7/13.
//  Copyright © 2017年 MasB1ue. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase

class ForgetViewController: UIViewController {
    var emailTextField: SkyFloatingLabelTextFieldWithIcon!
    var checkBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        self.view.backgroundColor = UIColor.white
        
        self.emailTextField = SkyFloatingLabelTextFieldWithIcon()
        self.emailTextField.placeholder = "請輸入註冊時的e-mail"
        self.emailTextField.title = "e-mail"
        self.emailTextField.iconFont = UIFont.fontAwesome(ofSize: 15)
        self.emailTextField.iconText = "\u{f0e0}"
        self.emailTextField.clearButtonMode = .whileEditing
        self.emailTextField.autocapitalizationType = .none
        self.emailTextField.keyboardType = .emailAddress
        self.emailTextField.autocapitalizationType = .none
        self.emailTextField.returnKeyType = .next
        self.view.addSubview(self.emailTextField)

        self.checkBtn = UIButton()
        self.checkBtn.setTitle("重設密碼", for: .normal)
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
        self.emailTextField.frame = CGRect(x: 40, y: UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height)! + gap, width: UIScreen.main.bounds.width - 80, height: 50)
        
        self.checkBtn.frame = CGRect(x: 0, y: self.emailTextField.frame.maxY + gap * 2, width: 100, height: 50)
        self.checkBtn.center.x = self.view.center.x
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.becomeFirstResponder()
    }
    
    //MARK: - selector
    
    func onBtnAction(_ sender: UIButton) {
        guard let email = emailTextField.text, email != "" else {
            let alertController = UIAlertController(title: "輸入錯誤", message: "請確認所填格式是否符合格式", preferredStyle: .alert)
            let alertAction1 = UIAlertAction(title: "確定", style: .default, handler: nil)
            alertController.addAction(alertAction1)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            let title = (error == nil) ? "Password Reset Follow-up" : "Password Reset Error"
            let message = (error == nil) ? "We have just sent you a password reset amail. Please check your inbox and follow the instruction to reset your password." : error?.localizedDescription
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let alertAction1 = UIAlertAction(title: "確定", style: .default, handler: { (action) in
                if error == nil {
                    self.view.endEditing(true)
                    if let navController = self.navigationController {
                        navController.popViewController(animated: true)
                    }
                }
                
            })
            alertController.addAction(alertAction1)
            self.present(alertController, animated: true, completion: nil)
            
            
            
            
            
        }
        
    }
    
}
