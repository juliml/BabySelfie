Confi//
//  BSLoginViewController.swift
//  BabySelfie
//
//  Created by Juliana Lima on 3/29/16.
//  Copyright © 2016 Juliana Lacerda. All rights reserved.
//

import UIKit
import QuartzCore
import FBSDKLoginKit
import Firebase
import SwiftLoader

class BSLoginViewController: BSViewController {

    
    // MARK: Outlets
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var textEmail: BSTextField!
    @IBOutlet weak var textSenha: BSTextField!
    
    @IBOutlet weak var viewCadastro: UIView!
    @IBOutlet weak var textCadNome: UITextField!
    @IBOutlet weak var textCadEmail: UITextField!
    @IBOutlet weak var textCadSenha: UITextField!
    @IBOutlet weak var textCadRepSenha: UITextField!
    
    // MARK: Constraints
    @IBOutlet weak var posYViewCadastro: NSLayoutConstraint!
    @IBOutlet weak var posYViewLogin: NSLayoutConstraint!
    
    // MARK: Properties
    let ref = Firebase(url:FirebaseUrl)
    let profile = Firebase(url:FirebaseUrl + "profiles")

    var openApp:Bool = false
    
    let facebookLogin = FBSDKLoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.posYViewCadastro.constant += 200
        self.viewCadastro.alpha = 0
        
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 150
        config.spinnerColor = .grayColor()
        config.foregroundColor = .whiteColor()
        config.foregroundAlpha = 0.8
        config.backgroundColor = .clearColor()
        config.titleTextColor = .grayColor()
        
        SwiftLoader.setConfig(config)

    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.openApp = false
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.boolForKey("login")) {
            self.openNextView()
        }
        
    }
    
    func openNextView() {
        
        if (!self.openApp) {
            self.openApp = true
            let userDefaults = NSUserDefaults.standardUserDefaults()
            if ((userDefaults.valueForKey("frequence")) != nil) {
                
                let takePicture:BSTakePictureViewController = self.storyboard!.instantiateViewControllerWithIdentifier("viewTakePicture") as! BSTakePictureViewController;
                self.navigationController?.pushViewController(takePicture, animated: true)
                
            } else {
                
                let frequence:BSFrequenceViewController = self.storyboard!.instantiateViewControllerWithIdentifier("viewFrequence") as! BSFrequenceViewController;
                self.navigationController?.pushViewController(frequence, animated: true)
                
            }
        }
        
    }
    
    @IBAction func signInEmail(sender: AnyObject) {
        
        SwiftLoader.show(title: "Logando...", animated: true)
        ref.authUser(textEmail.text, password: textSenha.text, withCompletionBlock: { (error, auth) -> Void in
            
            SwiftLoader.hide()
            
            if error != nil {

                if let errorCode = FAuthenticationError(rawValue: error.code) {
                    switch (errorCode) {
                    case .UserDoesNotExist:
                        self.showAlert("Usuário inválido! Tente novamente.")
                    case .InvalidEmail:
                        self.showAlert("E-mail inválido! Tente novamente.")
                    case .InvalidPassword:
                        self.showAlert("Senha inválida! Tente novamente.")
                    default:
                        print("Handle default situation")
                    }
                }
            } else {
                
                if auth != nil {
                    let email = self.textEmail.text
                    let photo = (auth.providerData["profileImageURL"] as? String)!
                    
                    self.profile.ref.queryOrderedByChild("email").observeEventType(.ChildAdded, withBlock: { snapshot in
                        if (snapshot.value["email"] as? String == email) {
                            let name = (snapshot.value["name"] as? String)!
                            
                            let userDefaults = NSUserDefaults.standardUserDefaults()
                            userDefaults.setValue(name, forKey: "userName")
                            userDefaults.setValue(email, forKey: "userEmail")
                            userDefaults.setValue(photo, forKey: "userPhoto")
                            userDefaults.setBool(true, forKey: "login")
                            userDefaults.synchronize()
                            
                            self.openNextView()
                            
                        }
                    })
                }
                
            }
        })
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.textEmail.text = ""
        self.textSenha.text = ""
    }
    
    @IBAction func signUpEmail(sender: AnyObject) {
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.posYViewLogin.constant += 200
            self.viewLogin.alpha = 0
            self.imgLogo.alpha = 0
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.3, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.posYViewCadastro.constant -= 200
            self.viewCadastro.alpha = 1
            self.view.layoutIfNeeded()
            }, completion: nil)

    }
   
    @IBAction func signInUpFacebook(sender: AnyObject) {
        
        facebookLogin.logInWithReadPermissions(["email", "public_profile"], fromViewController: self) { (facebookResult, facebookError) in

            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else if facebookResult.isCancelled {
                print("Facebook login was cancelled.")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                self.ref.authWithOAuthProvider("facebook", token: accessToken,
                    withCompletionBlock: { error, authData in
                        if error != nil {
                            print("Login failed. \(error)")
                        } else {
                            //print("Logged in! \(authData)")
                            
                            let fbRequest = FBSDKGraphRequest(graphPath:"me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]);
                            fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                                
                                if error == nil {
                                    
                                    let name = result.objectForKey("name") as! String
                                    let email = result.objectForKey("email") as! String
                                    
                                    let pictureDict = result.objectForKey("picture") as! NSDictionary
                                    let pictureData = pictureDict.objectForKey("data") as! NSDictionary
                                    let pictureURL = pictureData.objectForKey("url") as! String
                                    
                                    self.saveUser(name, email: email, photo: pictureURL)
                                    
                                } else {
                                    
                                    print("Error Getting Info \(error)");
                                    
                                }
                            }
                            
                        }
                })
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
                if (password != "" && password?.characters.count > 5) {
                    if (password == repassword) {
                    
                        SwiftLoader.show(title: "Registrando...", animated: true)
                        self.ref.createUser(email, password: password) { (error: NSError!) in
                            
                            if error == nil {
                                
                                self.ref.authUser(email, password: password, withCompletionBlock: { (error, auth) in
                                    
                                    SwiftLoader.hide()
                                    self.saveUser(name!, email: email!, photo: "")
                                })
                            }
                        }
                    } else {
                        self.showAlert("Repetir a senha corretamente!")
                    }

                } else {
                    self.showAlert("Preencha o campo SENHA com no mínimo 6 caracteres!")
                }
                
            } else {
                self.showAlert("Preencha o campo E-MAIL corretamente!")
            }
            
        } else {
            self.showAlert("Preencha o campo NOME!")
        }
        

    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    @IBAction func cancelRegister(sender: AnyObject) {
        
        UIView.animateWithDuration(0.5, delay: 0.3, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.posYViewLogin.constant -= 200
            self.viewLogin.alpha = 1
            self.imgLogo.alpha = 1
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.posYViewCadastro.constant += 200
            self.viewCadastro.alpha = 0
            self.view.layoutIfNeeded()
            }, completion: nil)
        
    }

    @IBAction func forgotPassword(sender: AnyObject) {
        
        let email = self.textEmail.text
        
        if (isValidEmail(email!) && email != "") {
            ref.resetPasswordForUser(email, withCompletionBlock: { error in
                if error != nil {
                    self.showAlert("Erro! Tente novamente.")
                } else {
                    self.showAlert("Nova senha enviada! Verifique seu e-mail.")
                }
            })
        } else {
            self.showAlert("Preencha o campo E-MAIL para receber sua nova senha.")
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func showAlert(description: NSString) {
        
        let ac = UIAlertController(title: "Atenção", message: description as String, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
        
    }
    
    func saveUser(name:NSString, email:NSString, photo:NSString) {
        
        //save user in device
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(name, forKey: "userName")
        userDefaults.setValue(email, forKey: "userEmail")
        userDefaults.setValue(photo, forKey: "userPhoto")
        userDefaults.setBool(true, forKey: "login")
        userDefaults.synchronize()
        
        //register in Firebase
        let user: NSDictionary = ["name":name, "email":email]
        let profile = self.profile.ref.childByAppendingPath(name as String)
        profile.setValue(user)
        
        //open app
        self.openNextView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
