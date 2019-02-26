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

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func facebookLogin(_ sender: Any) {
        
        let LoginManager = FBSDKLoginManager()
        
        LoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            // Perform login by calling Firebase APIs
            Auth.auth().signInAndRetrieveData(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                // self.performSegue(withIdentifier: self.signInSegue, sender: nil)
                
                FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email, picture.type(large)"]).start {
                    (connection, graphResult, error) in
                    if error != nil {
                        print("Failed to Start Graph Request")
                        return
                    }
                    //print(graphResult)
                    let facebookDetail = graphResult as! NSDictionary
                    let userID = facebookDetail["id"]
                    let fullName = facebookDetail["name"]
                    let email = facebookDetail["email"]
                    //let providerName = "Facebook"
                    //let userValues = (["Email": email, "Full Name": fullName, "UID": userID, "Provider":providerName])
                    
//                    let databaseRef = Database.database().reference()
//                    let key = databaseRef.child("node").childByAutoId().key ?? ""
//                    let childUpdates = ["/Users/\(userID))/": userValues]
//                    databaseRef.updateChildValues(childUpdates)
                    print(userID!)
                    print(fullName!)
                    print(email!)
                    
                    let firebaseID = Auth.auth().currentUser?.uid
                    print(firebaseID!)
                }
    
            })
        }
    }
    
}

//extension LoginViewController: FBSDKLoginButtonDelegate {
//
//    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
//        if let error = error {
//            print("\n\nFB SignIn Error : \(error.localizedDescription)\n\n")
//            return
//        }
//        // ...
//        guard result.isCancelled == false else {
//            return
//        }
//
//        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
//        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
//            if let error = error {
//                // ...
//                print("\n\nFB SignIn Error : \(error.localizedDescription)\n\n")
//                return
//            }
//            // User is signed in
//            // ...
//            let uid = authResult?.user.uid
//            let name = authResult?.user.displayName
//            let email = authResult?.user.providerID
//
//            print("\n**********************************************************")
//            print("User id: \(uid!)")
//            print("User name: \(name!)")
//            print("User email: \(email!)")
//            print("Credential provider: \(credential.provider)")
//            print("**********************************************************\n")
//        }
//    }
//
//    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
//
//    }
//}
