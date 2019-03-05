//
//  LoginViewController.swift
//  BabySelfie
//
//  Created by Juliana Lacerda on 2019-02-25.
//  Copyright © 2019 Juliana Lacerda. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class LoginViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textSenha: UITextField!
    @IBOutlet var facebookButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var newAccountButton: UIButton!
    @IBOutlet var forgotPassButton: UIButton!
    
    @IBOutlet weak var viewCadastro: UIView!
    @IBOutlet weak var textCadNome: UITextField!
    @IBOutlet weak var textCadEmail: UITextField!
    @IBOutlet weak var textCadSenha: UITextField!
    @IBOutlet weak var textCadRepSenha: UITextField!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var registerButton: UIButton!
    
    // MARK: - Constraints
    @IBOutlet weak var posYViewCadastro: NSLayoutConstraint!
    @IBOutlet weak var posYViewLogin: NSLayoutConstraint!
    
    var openApp:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.openApp = false
        
        if FirebaseManager.instance.isLoggedIn() {
            self.startApp()
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.textEmail.text = ""
        self.textSenha.text = ""
    }
    
    //MARK: - Methods
    
    func configure() {
        
        self.posYViewCadastro.constant += 200
        self.viewCadastro.alpha = 0
        
        self.textEmail.placeholder = NSLocalizedString("field_email", comment: "")
        self.textEmail.setLeftPaddingPoints(35)
        self.textSenha.placeholder = NSLocalizedString("field_pass", comment: "")
        self.textSenha.setLeftPaddingPoints(35)
        
        self.loginButton.setTitle(NSLocalizedString("btn_login", comment: ""), for: .normal)
        self.facebookButton.setTitle(NSLocalizedString("btn_facebook", comment: ""), for: .normal)
        self.forgotPassButton.setTitle(NSLocalizedString("btn_forgot", comment: ""), for: .normal)
        self.newAccountButton.setTitle(NSLocalizedString("btn_newaccount", comment: ""), for: .normal)
        
        self.titleLabel.text = NSLocalizedString("register_title", comment: "")
        self.textCadNome.placeholder = NSLocalizedString("field_name", comment: "")
        self.textCadSenha.placeholder = NSLocalizedString("field_pass", comment: "")
        self.textCadEmail.placeholder = NSLocalizedString("field_email", comment: "")
        self.textCadRepSenha.placeholder = NSLocalizedString("field_repass", comment: "")
        self.registerButton.setTitle(NSLocalizedString("btn_register", comment: ""), for: .normal)
        self.cancelButton.setTitle(NSLocalizedString("btn_cancel", comment: ""), for: .normal)
        
    }
    
    func startApp() {
        
        if (!self.openApp) {
            self.openApp = true
            
            let frequence = ProfileManager.getFrequence()
            if (frequence != nil) {
                
                let takePicture:TakePictureViewController = self.storyboard!.instantiateViewController(withIdentifier: "TakePictureView") as! TakePictureViewController;
                self.navigationController?.pushViewController(takePicture, animated: true)
                
            } else {
                
                let frequence:FrequenceViewController = self.storyboard!.instantiateViewController(withIdentifier: "FrequenceView") as! FrequenceViewController;
                self.navigationController?.pushViewController(frequence, animated: true)
            }
            
        }
        
    }
    
    // MARK: - Buttons
    
    @IBAction func signInEmail(sender: AnyObject) {
        
        let email = self.textEmail.text
        let password = self.textSenha.text
        
        if (isValidEmail(email!) && email != "") {
        
            FirebaseManager.instance.signInByEmail(email!, password: password!, success: { () in
                self.startApp()
                
            }) { (message) in
                if message != nil {
                    self.showAlert(nil, message:message! as String)
                }
            }
            
        } else {
            showAlert(nil, message:NSLocalizedString("valid_email", comment: "") as String)
        }
        
    }

    @IBAction func signUpEmail(sender: AnyObject) {
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.posYViewLogin.constant += 200
            self.viewLogin.alpha = 0
            self.imgLogo.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
            self.posYViewCadastro.constant -= 200
            self.viewCadastro.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }

    @IBAction func signInUpFacebook(sender: AnyObject) {
        
        FirebaseManager.instance.signInUpByFacebook(self, success: { () in
            self.startApp()
            
        }) { (message) in
            if message != nil {
                self.showAlert(nil, message:message! as String)
            }
        }
        
    }

    @IBAction func registerUser(sender: AnyObject) {
        
        let name = self.textCadNome.text
        let email = self.textCadEmail.text
        let password = self.textCadSenha.text
        let repassword = self.textCadRepSenha.text
        
        if (name != "") {
            if (isValidEmail(email!) && email != "") {
                if (password != "" && (password?.count)! > 5) {
                    if (password == repassword) {
                        
                        FirebaseManager.instance.signUpByEmail(name!, email: email!, password: password!, success: { () in
                            self.startApp()
                            
                        }) { (message) in
                            if message != nil {
                                self.showAlert(nil, message:message! as String)
                            }
                        }
                    
                    } else {
                        showAlert(nil, message:NSLocalizedString("valid_pass", comment: "") as String)
                    }
                    
                } else {
                    showAlert(nil, message:NSLocalizedString("valid_count_pass", comment: "") as String)
                }
                
            } else {
                showAlert(nil, message:NSLocalizedString("valid_email", comment: "") as String)
            }
            
        } else {
            showAlert(nil, message:NSLocalizedString("valid_name", comment: "") as String)
        }
        
    }

    
    @IBAction func cancelRegister(sender: AnyObject) {
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
            self.posYViewLogin.constant -= 200
            self.viewLogin.alpha = 1
            self.imgLogo.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.posYViewCadastro.constant += 200
            self.viewCadastro.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }

    @IBAction func forgotPassword(sender: AnyObject) {
        
        let email = self.textEmail.text
        
        if (isValidEmail(email!) && email != "") {
            
            FirebaseManager.instance.forgotPassword(email!, success: { () in
                self.showAlert(nil, message:NSLocalizedString("success_resend_email", comment: "") as String)
                
            }) { (message) in
                self.showAlert(nil, message:NSLocalizedString("error_resend_email", comment: "") as String)
            }

        } else {
            showAlert(nil, message:NSLocalizedString("alert_email_needed", comment: "") as String)
        }
        
    }
    
}
