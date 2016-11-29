//
//  DataService.swift
//  SocialMe
//
//  Created by Luke Klepfer on 11/26/16.
//  Copyright © 2016 Luke. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference() //Url refs saved in GoogleService-info.plist
let STOR_BASE = FIRStorage.storage().reference()

class DataService {
    
    static let ds = DataService()//creates singletin
    
    
    //Database
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts") //https://socialme-24e0c.firebaseio.com/posts
    private var _REF_USERS = DB_BASE.child("users")
    
    //Storage
    private var _REF_STOR_POST_PICS = STOR_BASE.child("post-pics")
    private var _REF_STOR_PROFILE_PICS = STOR_BASE.child("profile-pics")
    
    var REF_USER_CURRENT: FIRDatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID) //keychain uid matches firebase uid
        let user = REF_USERS.child(uid!)// reference to current uid
        return user
    }
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    var REF_STOR_POST_PICS: FIRStorageReference {
        return _REF_STOR_POST_PICS
    }
    var REF_STOR_PROFILE_PICS: FIRStorageReference {
        return _REF_STOR_PROFILE_PICS
    }
    
    
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String,String>) {
        REF_USERS.child(uid).updateChildValues(userData)//child might not exist, this will create one or add to it.
    }
    
    
    
}
