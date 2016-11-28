//
//  ProfileVC.swift
//  SocialMe
//
//  Created by Luke Klepfer on 11/28/16.
//  Copyright © 2016 Luke. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {

    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var usernameTxtView: CustomTextField!
    @IBOutlet weak var emailTxtView: CustomTextField!
    @IBOutlet weak var passwordTxtView: CustomTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        if FIRAuth.auth()?.currentUser?.uid == KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("LUKE: View Owner's profile page")
            settupUserProfile()
        }else{
            print("LUKE: View someone else's profile page")
            settupGuestProfile()
        }
    }
    
    @IBAction func feedBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: "ShowFeedVC", sender: nil)
    }

    func settupUserProfile(){
    
        let ref = DataService.ds.REF_USER_CURRENT
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            let provider = value?["provider"] as? String ?? ""
            //let likes = value?["likes"] as? Dictionary<String,Bool>
            //print(username, provider, likes)
            
            self.usernameTxtView.text = username
            self.emailTxtView.text = provider
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        //usernameTxtView.text = FIRAuth.auth()?.currentUser?.displayName
        //emailTxtView.text = FIRAuth.auth()?.currentUser?.email
        //DataService.ds.REF_USER_CURRENT.child("username").setValue("Luke Klepfer")
    }
    func settupGuestProfile(){
        
    }

}
