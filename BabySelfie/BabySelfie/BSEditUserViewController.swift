//
//  BSEditUserViewController.swift
//  BabySelfie
//
//  Created by Juliana Lima on 4/15/16.
//  Copyright © 2016 Juliana Lacerda. All rights reserved.
//

import UIKit
import Firebase
import SwiftLoader

class BSEditUserViewController: UIViewController {

    @IBOutlet weak var textSenhaAtual: UITextField!
    @IBOutlet weak var txtNovaSenha: UITextField!
    @IBOutlet weak var txtRepNovaSenha: UITextField!
    
    // MARK: Properties
    let ref = Firebase(url:"https://babyselfie.firebaseio.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 150
        config.spinnerColor = .grayColor()
        config.foregroundColor = .whiteColor()
        config.foregroundAlpha = 0.8
        config.backgroundColor = .clearColor()
        config.titleTextColor = .grayColor()
        
        SwiftLoader.setConfig(config)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BSViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @IBAction func salvarNovaSenha(sender: AnyObject) {
        
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let email = userDefaults.valueForKey("userEmail") as? String
        
        let oldPassword = self.textSenhaAtual.text
        let newPassword = self.txtNovaSenha.text
        let rePassword = self.txtRepNovaSenha.text
        
        if (oldPassword != "") {
            if (newPassword != "" && newPassword?.characters.count > 5) {
                if (newPassword == rePassword) {
                    
                    SwiftLoader.show(title: "Salvando...", animated: true)
                    ref.changePasswordForUser(email, fromOld: oldPassword, toNew: newPassword, withCompletionBlock: { (error) in
                        
                        SwiftLoader.hide()
                        if ((error) != nil) {
                            self.showAlert("Erro ao redefinir a senha! Tente novamente.");
                        } else {
                            self.showAlert("Senha redefinida com sucesso!");
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                        
                    })
                    
                } else {
                    self.showAlert("Repetir a senha corretamente!")
                }
                
            } else {
                self.showAlert("Preencha o campo SENHA com no mínimo 6 caracteres!")
            }
        } else {
            self.showAlert("Preencha o campo SENHA ATUAL!")
        }
        
    }
    
    @IBAction func closeEdit(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func showAlert(description: NSString) {
        
        let ac = UIAlertController(title: "Atenção", message: description as String, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
