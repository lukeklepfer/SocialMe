//
//  Post.swift
//  SocialMe
//
//  Created by Luke Klepfer on 11/26/16.
//  Copyright © 2016 Luke. All rights reserved.
//

import Foundation
import Firebase


class Post {
    
    private var _caption: String!
    private var _imgUrl: String!
    private var _likes: Int!
    private var _postKey: String!
    private var _postRef: FIRDatabaseReference!
    private var _posterName: String!
    
    var caption: String{
        return _caption
    }
    var imgUrl: String{
        return _imgUrl
    }
    var likes: Int{
        return _likes
    }
    var postKey: String{
        return _postKey
    }
    var posterName: String{
        return _posterName
    }
    
    init(caption: String, imgUrl: String, likes: Int) {
        
        self._caption = caption
        self._imgUrl = imgUrl
        self._likes = likes
    }
    
    init(postKey: String, postData: Dictionary<String, Any>) {
        self._postKey = postKey
        
        if let caption = postData["caption"] {
            self._caption = caption as? String
        }
        if let imgUrl = postData["imageUrl"]{
            self._imgUrl = imgUrl as? String
        }
        if let likes = postData["likes"]{
            self._likes = likes as? Int
        }
        if let poster = postData["poster"]{
            self._posterName = poster as? String
        }
        
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
    }
    
    func likes(add: Bool){
        if add {
            _likes = _likes + 1
        }else{
            _likes = _likes - 1
        }
        _postRef.child("likes").setValue(_likes)
    }
}
