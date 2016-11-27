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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    func configureCell(post: Post, img:UIImage? = nil){
        self.post = post
        self.postTextView.text = post.caption
        self.likesLabel.text = ("\(post.likes)")
        
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
    }
}
