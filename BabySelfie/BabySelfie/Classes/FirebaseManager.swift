//
//  FirebaseManager.swift
//  BabySelfie
//
//  Created by Juliana Lacerda on 2019-02-27.
//  Copyright © 2019 Juliana Lacerda. All rights reserved.
//

import Foundation
import Firebase
import FBSDKLoginKit

typealias firebaseSuccess = () -> Void
typealias firebaseError = (_ message: String?) -> Void

class FirebaseManager {
    
    static let instance = FirebaseManager()
    
    // MARK: - Auth
    
    func signUpByEmail(_ name:String, email:String, password:String, success: @escaping firebaseSuccess, failure: @escaping firebaseError) {
    
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if error != nil {
                print(error!.localizedDescription)
                failure(NSLocalizedString("failed_register", comment: "") as String)
                
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch (errCode) {
                    case .emailAlreadyInUse:
                        failure(NSLocalizedString("alert_user_exist", comment: "") as String)
                    default:
                        print(error!.localizedDescription)
                        failure(NSLocalizedString("failed_register", comment: "") as String)
                    }
                }
                
            } else {
                
                self.createUserProfile(name)
                print(authResult!.user.uid)
                let profile = Profile(authResult!.user.uid, displayName: name)
                ProfileManager.instance.setProfile(profile)
                success()

            }
        }
    }
    
    func signInByEmail(_ email:String, password:String, success: @escaping firebaseSuccess, failure: @escaping firebaseError) {
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            if error != nil {
                
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch (errCode) {
                    case .userNotFound:
                        failure(NSLocalizedString("alert_user_invalid", comment: "") as String)
                    case .invalidEmail:
                        failure(NSLocalizedString("alert_email_invalid", comment: "") as String)
                    case .wrongPassword:
                        failure(NSLocalizedString("alert_pass_invalid", comment: "") as String)
                    default:
                        print(error!.localizedDescription)
                        failure(NSLocalizedString("failed_login", comment: "") as String)
                    }
                }
                
            } else {
                
                print(authResult!.user.uid)
                self.getCurrentUser()
                success()
            }
        }
        
    }
    
    func signInUpByFacebook(_ viewController: UIViewController, success: @escaping firebaseSuccess, failure: @escaping firebaseError) {
        
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["public_profile", "email"], from: viewController) { (result, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                failure(NSLocalizedString("failed_login", comment: "") as String)
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                failure(NSLocalizedString("failed_login", comment: "") as String)
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            Auth.auth().signInAndRetrieveData(with: credential, completion: { (authResult, error) in
                
                if error != nil {
                    print(error!.localizedDescription)
                    failure(NSLocalizedString("failed_login", comment: "") as String)
                }
                
                FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start {
                    (connection, graphResult, error) in
                    
                    if error != nil {
                        print("Failed to Start Graph Request")
                        failure(NSLocalizedString("failed_login", comment: "") as String)
                    }
                    
                    let facebookDetail = graphResult as! NSDictionary
                    //let userID = facebookDetail["id"]
                    let fullName = facebookDetail["name"] as! String
                    //let email = facebookDetail["email"] as! String
                    
                    self.createUserProfile(fullName)
                    let profile = Profile(authResult!.user.uid, displayName: fullName)
                    ProfileManager.instance.setProfile(profile)
                    success()

                }

            })
        }
        
    }
    
    func createUserProfile(_ name:String) {
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges { (error) in
            //..
        }
    }
    
    func forgotPassword(_ email:String, success: @escaping firebaseSuccess, failure: @escaping firebaseError) {
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in

            if error != nil {
                failure(nil)
                
            } else {
                success()
            }
        }
        
    }
    
    func isLoggedIn() -> Bool {
        
        if Auth.auth().currentUser != nil {
            // User is signed in.
            getCurrentUser()
            return true
        } else {
            // No user is signed in.
            return false
        }
    }
    
    func logout() {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    private func getCurrentUser()
    {
        let user = Auth.auth().currentUser
        if let user = user {
            
            print(user.uid)
            print(user.displayName!)
            
            let profile = Profile(user.uid, displayName: user.displayName!)
            ProfileManager.instance.setProfile(profile)
        }
    }
    
}
