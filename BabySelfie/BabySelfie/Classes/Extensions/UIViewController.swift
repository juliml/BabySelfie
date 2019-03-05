//
//  UIViewController.swift
//  BabySelfie
//
//  Created by Juliana Lacerda on 2019-03-04.
//  Copyright © 2019 Juliana Lacerda. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func removeKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func showAlert(_ titl:String?, message: String) {
        
        var newTitle = NSLocalizedString("alert_title", comment: "")
        if (titl != nil) {
            newTitle = titl!
        }
        
        let ac = UIAlertController(title: newTitle, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
        
    }
    
}

