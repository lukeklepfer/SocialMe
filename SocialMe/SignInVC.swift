//
//  ViewController.swift
//  SocialMe
//
//  Created by Luke Klepfer on 11/22/16.
//  Copyright © 2016 Luke. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: CustomTextField!
    @IBOutlet weak var passwordField: CustomTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func facebookBtn(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Facebook Auth Login: \(error)")
            }else if result?.isCancelled == true {
                //no error but user didnt allow it to open
                print("User cancelled Facebook Auth")
            }else{
                print("Facebook Auth Succeded")
                let cred = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(cred)
            }
        }
    }
    
    @IBAction func signinTapped(_ sender: Any) {
        
        if let email = emailField.text, let pwd = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    //signed in!
                    print("Email User Authenticated with Firebase")
                }else{
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil{
                            print("Email User can not be created \(error.debugDescription)")
                        }else{
                            print("Email User Created")
                        }
                    })
                }
            })
        }
    }
    
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Unable to authenticate with Firebase: \(error)")
            }else{
                print("Authenticated with Firebase")
            }
        })
    }


}

