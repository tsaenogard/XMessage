//
//  LoginViewController.swift
//  loginTest
//
//  Created by Eric Chen on 2017/7/13.
//  Copyright © 2017年 MasB1ue. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
import FontAwesome_swift


class LoginViewController: UIViewController {
    var emailTextField: SkyFloatingLabelTextFieldWithIcon!
    var passwordTextField: SkyFloatingLabelTextFieldWithIcon!
    var loginBtn: UIButton!
    var registerBtn: UIButton!
    var forgetBtn: UIButton!
    var fbLoginBtn: FBSDKLoginButton!
    var googleLoginBtn: GIDSignInButton!
    
    //MARK: - override

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        self.view.backgroundColor = UIColor.white
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        self.emailTextField = SkyFloatingLabelTextFieldWithIcon()
        self.emailTextField.placeholder = "請輸入e-mail"
        self.emailTextField.title = "e-mail"
        self.emailTextField.iconFont = UIFont.fontAwesome(ofSize: 15)
        self.emailTextField.iconText = "\u{f0e0}"
        self.emailTextField.clearButtonMode = .whileEditing
        self.emailTextField.autocapitalizationType = .none
        self.emailTextField.keyboardType = .emailAddress
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
        self.passwordTextField.returnKeyType = .done
        self.view.addSubview(self.passwordTextField)
        
        self.loginBtn = UIButton()
        self.loginBtn.setTitle("登入", for: .normal)
        self.loginBtn.setTitleColor(UIColor.white, for: .normal)
        self.loginBtn.backgroundColor = UIColor.blue
        self.loginBtn.layer.cornerRadius = 25.0
        self.loginBtn.layer.borderWidth = 1.0
        self.loginBtn.layer.borderColor = UIColor.darkGray.cgColor
        self.loginBtn.addTarget(self, action: #selector(onLogin(_:)), for: .touchUpInside)
        self.view.addSubview(self.loginBtn)
        
        self.registerBtn = UIButton()
        self.registerBtn.setTitle("註冊", for: .normal)
        self.registerBtn.setTitleColor(UIColor.white, for: .normal)
        self.registerBtn.backgroundColor = UIColor.blue
        self.registerBtn.layer.cornerRadius = 25.0
        self.registerBtn.layer.borderWidth = 1.0
        self.registerBtn.layer.borderColor = UIColor.darkGray.cgColor
        self.registerBtn.addTarget(self, action: #selector(onRegister(_:)), for: .touchUpInside)
        self.view.addSubview(self.registerBtn)
        
        self.forgetBtn = UIButton()
        self.forgetBtn.setTitle("忘記密碼？", for: .normal)
        self.forgetBtn.setTitleColor(UIColor.black, for: .normal)
        
        self.forgetBtn.addTarget(self, action: #selector(onForget(_:)), for: .touchUpInside)
        self.view.addSubview(self.forgetBtn)
        
        self.fbLoginBtn = FBSDKLoginButton()
        self.fbLoginBtn.delegate = self
//        self.fbLoginBtn.backgroundColor = UIColor.blue
//        self.fbLoginBtn.setTitle("FB Login", for: .normal)
//        self.fbLoginBtn.setTitleColor(UIColor.white, for: .normal)
//        self.fbLoginBtn.addTarget(self, action: #selector(onFBLogin(_:)), for: .touchUpInside)
        self.fbLoginBtn.layer.cornerRadius = 25.0
        
//        self.fbLoginBtn.readPermissions = ["public_profile","email"]
//        self.fbLoginBtn.delegate = self
        self.view.addSubview(self.fbLoginBtn)
        
        self.googleLoginBtn = GIDSignInButton()
//        self.googleLoginBtn.backgroundColor = UIColor.blue
//        self.googleLoginBtn.setTitle("Google Login", for: .normal)
//        self.googleLoginBtn.setTitleColor(UIColor.white, for: .normal)
//        self.googleLoginBtn.addTarget(self, action: #selector(onGGLogin(_:)), for: .touchUpInside)
//        self.googleLoginBtn.layer.cornerRadius = 25.0
        
        self.view.addSubview(self.googleLoginBtn)
        
        
        GIDSignIn.sharedInstance().signOut()
        FBSDKLoginManager().logOut()
        
        self.emailTextField.text = "tsaenogard@gmail.com"
        self.passwordTextField.text = "mark2002"

    }
    override func viewDidAppear(_ animated: Bool) {
        let gap: CGFloat = 10
        
        self.emailTextField.frame = CGRect(x: 40, y: UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height)! + gap, width: UIScreen.main.bounds.width - 80, height: 50)
        
        self.passwordTextField.frame = CGRect(x: 40, y: self.emailTextField.frame.maxY + gap, width: UIScreen.main.bounds.width - 80, height: 50)
        
        self.loginBtn.frame = CGRect(x: 40, y: self.passwordTextField.frame.maxY + gap * 2, width: self.passwordTextField.frame.width * 0.5 - 5, height: 50)
        
        self.registerBtn.frame = CGRect(x: self.loginBtn.frame.maxX + gap, y: self.passwordTextField.frame.maxY + gap * 2, width: self.passwordTextField.frame.width * 0.5 - 5, height: 50)
        
        self.forgetBtn.frame = CGRect(x: UIScreen.main.bounds.midX - 50, y: self.registerBtn.frame.maxY + gap * 2, width: 100, height: 50)
        
        self.fbLoginBtn.frame = CGRect(x: UIScreen.main.bounds.midX - 100, y: self.forgetBtn.frame.maxY + gap * 2, width: 200, height: 50)
        
        self.googleLoginBtn.frame = CGRect(x: UIScreen.main.bounds.midX - 100, y: self.fbLoginBtn.frame.maxY + gap * 2, width: 200, height: 50)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.becomeFirstResponder()
    }
    
    //MARK: - selector
    
    func onLogin(_ sender: UIButton) {
        guard let email = emailTextField.text, email != "",
            let password = passwordTextField.text, password != "" else {
                let alertController = UIAlertController(title: "登入失敗", message: "請確認登入email及密碼正確", preferredStyle: .alert)
                let alertAction1 = UIAlertAction(title: "確定", style: .default, handler: nil)
                alertController.addAction(alertAction1)
                self.present(alertController, animated: true, completion: nil)
                return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                let alertController = UIAlertController(title: "登入失敗", message: error.localizedDescription, preferredStyle: .alert)
                let alertAction1 = UIAlertAction(title: "確定", style: .default, handler: nil)
                alertController.addAction(alertAction1)
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            guard let currentUser = user, currentUser.isEmailVerified else {
                let alertController = UIAlertController(title: "登入失敗", message: "請先驗證你的email", preferredStyle: .alert)
                let alertAction1 = UIAlertAction(title: "再寄一次", style: .default, handler: {
                    (action) in user?.sendEmailVerification(completion: nil)
                })
                let alertAction2 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                alertController.addAction(alertAction1)
                alertController.addAction(alertAction2)
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            self.view.endEditing(true)
            
            let destinVC = ChannelListViewController()
            UIApplication.shared.keyWindow?.rootViewController = UINavigationController(rootViewController: destinVC)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
//    func onFBLogin(_ sender: UIButton) {
//        let fbLoginManager = FBSDKLoginManager()
//        fbLoginManager.logIn(withReadPermissions: ["public_profile","email"], from: self) { (result, error) in
//            if let error = error {
//                print("Failed to login : \(error.localizedDescription)")
//                return
//            }
//            guard let accessToken = FBSDKAccessToken.current() else {
//                print("Failed to get access token")
//                return
//            }
//            
//            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
//            
//            Auth.auth().signIn(with: credential, completion: { (user, error) in
//                if let error = error {
//                    print("Login error: \(error.localizedDescription)")
//                    let alertController = UIAlertController(title: "登入失敗", message: error.localizedDescription, preferredStyle: .alert)
//                    let alertAction1 = UIAlertAction(title: "確定", style: .default, handler: nil)
//                    alertController.addAction(alertAction1)
//                    self.present(alertController, animated: true, completion: nil)
//                    
//                    return
//                }
//                let destinVC = TopViewController()
//                destinVC.info = Auth.auth().currentUser?.displayName
//                UIApplication.shared.keyWindow?.rootViewController = UINavigationController(rootViewController: destinVC)
//                self.dismiss(animated: true, completion: nil)
//                
//            })
//        }
//    }
    
//    func onGGLogin(_ sender: UIButton) {
//        GIDSignIn.sharedInstance().signIn()
//    }
    
    func onRegister(_ sender: UIButton) {
        let destinVC = RegisterViewController()
        navigationController?.pushViewController(destinVC, animated: true)
    }
    
    func onForget(_ sender: UIButton) {
        let destinVC = ForgetViewController()
        navigationController?.pushViewController(destinVC, animated: true)
    }

}


extension LoginViewController: FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print("Failed to login : \(error.localizedDescription)")
            return
        }
        guard let accessToken = FBSDKAccessToken.current() else {
            print("Failed to get access token")
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
        
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                let alertController = UIAlertController(title: "登入失敗", message: error.localizedDescription, preferredStyle: .alert)
                let alertAction1 = UIAlertAction(title: "確定", style: .default, handler: nil)
                alertController.addAction(alertAction1)
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            let destinVC = TopViewController()
            destinVC.info = Auth.auth().currentUser?.displayName
            UIApplication.shared.keyWindow?.rootViewController = UINavigationController(rootViewController: destinVC)
            self.dismiss(animated: true, completion: nil)
            
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
}



extension LoginViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            return
        }
        
        guard let authentication = user.authentication else {
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                let alertController = UIAlertController(title: "登入失敗", message: error.localizedDescription, preferredStyle: .alert)
                let alertAction1 = UIAlertAction(title: "確定", style: .default, handler: nil)
                alertController.addAction(alertAction1)
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            let destinVC = TopViewController()
            destinVC.info = Auth.auth().currentUser?.displayName
            UIApplication.shared.keyWindow?.rootViewController = UINavigationController(rootViewController: destinVC)
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
}
