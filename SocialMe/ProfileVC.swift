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
    
    var tappedPost: Post!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    override func viewDidAppear(_ animated: Bool) {
        
        if FIRAuth.auth()?.currentUser?.uid == KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("LUKE: View Owner's profile page")
            settUpUI()
        }
    }
    
    @IBAction func feedBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: "ShowFeedVC", sender: nil)
    }

    func settUpUI(){
        
    }
}
