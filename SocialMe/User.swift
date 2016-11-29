//
//  User.swift
//  SocialMe
//
//  Created by Luke Klepfer on 11/29/16.
//  Copyright © 2016 Luke. All rights reserved.
//

import Foundation
import Firebase

class User {
    
    private var _username: String!
    private var _profileImgUrl: String!
    private var _provider: String!
    private var _likeIDs: Dictionary<String,Bool>!
    private var _friendIDs: Dictionary<String,Bool>!
    
    
    init(uid: String) {
        
        _username = uid
        
        let ref = DataService.ds.REF_USERS.child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? "Nil"
            let provider = value?["provider"] as? String ?? "Nil"
            let likes = value?["likes"] as? Dictionary<String,Bool>
            
            
            self._username = username
            self._provider = provider
            self._likeIDs = likes
            //self._friendsIDs
            print("LUKE: \(self._username, self._provider, self._likeIDs)")
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    var username: String{
        return _username
    }
    var profileImgUrl: String{
        return _profileImgUrl
    }
    var likeIDs: Dictionary<String,Bool>{
        return _likeIDs
    }
    var friendIDs: Dictionary<String,Bool>{
        return _friendIDs
    }
}
