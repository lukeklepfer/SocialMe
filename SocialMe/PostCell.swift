//
//  PostCell.swift
//  SocialMe
//
//  Created by Luke Klepfer on 11/25/16.
//  Copyright © 2016 Luke. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var likesImageView: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    
    
    var post: Post!
    var likesRef: FIRDatabaseReference!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likesImageView.isUserInteractionEnabled = true
        likesImageView.addGestureRecognizer(tap)
    }

    func configureCell(post: Post, img:UIImage? = nil){
        self.post = post
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        self.postTextView.text = post.caption
        self.likesLabel.text = ("\(post.likes)")
        self.profileLabel.text = post.posterName
        
        if img != nil {
            self.postImageView.image = img
        }else{
            let ref = FIRStorage.storage().reference(forURL: post.imgUrl)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: {(data, error) in //Calculating = 2MB
                if error != nil {
                    print("LUKE: Unable to download image")
                }else{
                    print("LUKE: Image downloaded")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImageView.image = img
                            FeedVC.imgCache.setObject(img, forKey: post.imgUrl as NSString)
                        }
                    }
                }
            })
        }
        
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likesImageView.image = #imageLiteral(resourceName: "empty-heart")
            }else{
                self.likesImageView.image = #imageLiteral(resourceName: "filled-heart")
            }
            
        })
    }
    
    
    func likeTapped(sender: UITapGestureRecognizer){
    
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likesImageView.image = #imageLiteral(resourceName: "filled-heart")
                self.post.likes(add: true)
                self.likesRef.setValue(true)
            }else{
                self.likesImageView.image = #imageLiteral(resourceName: "empty-heart")
                self.post.likes(add: false)
                self.likesRef.removeValue()
            }
            
        })
    }
}
