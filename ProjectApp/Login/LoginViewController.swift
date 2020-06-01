//
//  LoginViewController.swift
//  ProjectApp
//
//  Created by Николай Рыбин on 03.03.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var LoginTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var SignInButton: UIButton!
    @IBOutlet weak var loginView: UIView!
    
    var isLoginViewMoved: Bool = false
    
    var startViewY: CGFloat?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startViewY = loginView.frame.origin.y
        loginView.translatesAutoresizingMaskIntoConstraints = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        LoginTextField.addTarget(self, action: #selector(LoginViewController.checkInputFiedls(_:)), for: .editingChanged)
        PasswordTextField.addTarget(self, action: #selector(LoginViewController.checkInputFiedls(_:)), for: .editingChanged)
        
        self.LoginTextField.delegate = self
        self.PasswordTextField.delegate = self
        
        changeButtonState(false, 0.3);
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if loginView.frame.origin.y == startViewY {
                loginView.frame.origin.y -= keyboardSize.height / 3
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if loginView.frame.origin.y != startViewY {
            loginView.frame.origin.y = startViewY!
        }
    }
    
    @objc func checkInputFiedls(_ textField: UITextField){
        if LoginTextField.text != "" && PasswordTextField.text != "" {
            SignInButton.isEnabled = true
            SignInButton.alpha = 1
        }else{
            SignInButton.isEnabled = false
            SignInButton.alpha = 0.3
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == LoginTextField{
            PasswordTextField.becomeFirstResponder()
        }else{
            signInButton(SignInButton)
        }
        return false
    }
    
    func changeButtonState(_ status: Bool,_ alpha: CGFloat){
        SignInButton.isEnabled = status
        SignInButton.alpha = alpha
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //функция авторизации пользователя в приложении
    @IBAction func signInButton(_ sender: UIButton)
    {
        
        if LoginTextField.text != nil && PasswordTextField.text != nil && sender.isEnabled == true
        {
            if isConnectedToInternet{
                
                let login = LoginTextField.text!
                let password = PasswordTextField.text!
                let parameters = ["email": login, "password": password] as [String : Any]
                
                request("https://event-admin.tapir.ws/api/login", method: .post, parameters: parameters, headers: nil).responseJSON { response in
                    
                    do {
                        let jsonData = response.data!
                        
                        let otvet = try JSONDecoder().decode(AuthResponse.self, from: jsonData)
                        let token = otvet.accessToken
                        let deathTime  = NSDate().timeIntervalSince1970 + Double(otvet.expiresIn)
                        
                        RequestInfo.header["AccessToken"]  = token
                        
                        DataManager().isAppAuthorized = true
                        let authInfo = AuthInfo(status: true, login: login, password: password, token: token, deathTime: deathTime)
                        DataManager().SaveData(input: authInfo)
                        
                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    } catch {
                        print(error.localizedDescription)
                        
                         PopUpViewController.ShowErrorView(message: "Неправильный логин или пароль" , parent: self, hideMessage: true)
                        
                        //self.ShowErrorView(message: "Неправильный логин или пароль")
                    }
                }
                
            }else{
                 PopUpViewController.ShowErrorView(message: "Проблемы с доступом к сети" , parent: self, hideMessage: true)
                //ShowErrorView(message: "Проблемы с доступом к сети")
            }
        }
    }
    
    var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
//    func ShowErrorView(message: String){
//        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpVCid") as! PopUpViewController
//        popUpVC.showMessage(message: message, parentVC: self)
//    }
}

extension UITextField
{
    func roundCorners(corners:UIRectCorner, radius: CGFloat)
    {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        maskLayer.fillColor = CGColor.init(srgbRed: 255, green: 1, blue: 255, alpha: 1)
        self.layer.mask = maskLayer
    }
}
