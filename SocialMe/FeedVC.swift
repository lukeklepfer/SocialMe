//
//  FeedVC.swift
//  SocialMe
//
//  Created by Luke Klepfer on 11/25/16.
//  Copyright © 2016 Luke. All rights reserved.
//

import UIKit
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addImgView: UIImageView!
    @IBOutlet weak var captionTxtField: CustomTextField!
    
    var imgPicker: UIImagePickerController!
    var posts = [Post]()
    static var imgCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.allowsEditing = true
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            self.posts = []
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    //print("LUKE: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, Any>{
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
          self.tableView.reloadData()
        })
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImgView.image = img
        }else{
            print("LUKE: A valid image was not selected")
        }
        imgPicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postBtnTapped(_ sender: Any) {
        
        guard let caption = captionTxtField.text, caption != "" else {
            //not true
            print("LUKE: Can not post with out a post caption")
            return
        }
        guard let img = addImgView.image, img != #imageLiteral(resourceName: "add-image") else{
            print("LUKE: Can not post without an image")
            return
        }
        //its all good, do the do...
        if let imgData = UIImageJPEGRepresentation(img, 0.2){
            let imgUid = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            DataService.ds.REF_STOR_POST_PICS.child(imgUid).put(imgData, metadata: metaData) { (metadata, error) in
                if error != nil {
                    print("LUKE: Unable to upload image to Firebase Storage")
                }else{
                    print("LUKE: Succesfully uploaded image to Firebase Storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString //converts url to raw string
                    if let url = downloadURL {
                        self.postToFirebase(imgUrl: url)
                    }
                }
            }
        }
    }
    
    func postToFirebase(imgUrl: String){
        let post: Dictionary<String, Any> = [
            "caption": captionTxtField.text!,
            "imageUrl": imgUrl,
            "likes": 0
            ]
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionTxtField.text = ""
        addImgView.image = #imageLiteral(resourceName: "add-image")
        tableView.reloadData()
     }
    
    
    
    @IBAction func addImageTapped(_ sender: Any) {
        present(imgPicker, animated: true, completion: nil)
    }
    
    
    @IBAction func tappedSignOut(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("LUKE: ID removed from keychain \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "ShowSignIn", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell{
            
            if let img = FeedVC.imgCache.object(forKey: post.imgUrl as NSString) {
                cell.configureCell(post: post, img: img)
                //return cell
            }else{
                cell.configureCell(post: post)//default value is set
                return cell
            }
            return cell
        }else{
            return PostCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

}
