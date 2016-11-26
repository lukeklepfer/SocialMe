//
//  DataService.swift
//  SocialMe
//
//  Created by Luke Klepfer on 11/26/16.
//  Copyright © 2016 Luke. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference() //Url ref saved in GoogleService-info.plist: https://socialme-24e0c.firebaseio.com/

class DataService {
    
    static let ds = DataService()//creates singletin
    
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts") //https://socialme-24e0c.firebaseio.com/posts
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String,String>) {
        REF_USERS.child(uid).updateChildValues(userData)//child might not exist, this will create one or add to it.
    }
    
}
