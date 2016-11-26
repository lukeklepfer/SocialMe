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
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("LUKE: UID Found in Keychain")
            performSegue(withIdentifier: "ShowFeedVC", sender: nil)
        }
    }
    
    @IBAction func facebookBtn(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("LUKE: Unable to authenticate with Facebook - \(error)")
            } else if result?.isCancelled == true {
                print("LUKE: User cancelled Facebook authentication")
            } else {
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                print("LUKE: Sucessfully Authenticated Facebook User")
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("LUKE: Unable to authenticate with Firebase: \(error)")
            }else{
                print("LUKE: Authenticated with Firebase")
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignin(id: user.uid, userData: userData)
                }
            }
        })
    }
    
    @IBAction func signinTapped(_ sender: Any) {
        if let email = emailField.text, let pwd = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    //signed in!
                    print("LUKE: Email User Authenticated with Firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignin(id: user.uid, userData: userData)
                    }
                }else{
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil{
                            print("LUKE: Email User can not be created \(error.debugDescription)")
                        }else{
                            print("LUKE: Email User Created")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignin(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
    }
    
    func completeSignin(id: String, userData: Dictionary<String,String>){
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        print("LUKE: \(id, userData)")
        KeychainWrapper.standard.set(id, forKey: KEY_UID)
        performSegue(withIdentifier: "ShowFeedVC", sender: nil)
        print("LUKE: UID Saved to Keychain")
    }
    
}

