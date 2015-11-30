//
//  PostCell.swift
//  myTeamCom
//
//  Created by aloha kids on 11/28/15.
//  Copyright © 2015 Richard. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showcaseImg: UIImageView!
    @IBOutlet weak var descText: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likesImg: UIImageView!
    
    var post: Post!
    var request: Request?
    var likeRef: Firebase!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // program tap gesture for repeated view or table view
        // tap gesture cannot configured for any repeated view or table view
        let tap = UITapGestureRecognizer(target: self, action: "likeTapped:")
        tap.numberOfTapsRequired = 1
        likesImg.addGestureRecognizer(tap)
        likesImg.userInteractionEnabled = true
        
    }
    
    override func drawRect(rect: CGRect) {
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        showcaseImg.clipsToBounds = true
    }
    
    func configureCell(post: Post, img: UIImage?) {
        self.post = post
        
        likeRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath("likes").childByAppendingPath(post.postKey)
        
        self.descText.text = post.postDescription
        self.likesLbl.text = "\(post.likes)"
        
        if post.imageUrl != nil {
            
            // the following "if" statement is to check if the cache has an image stored for this post.
            // please refer to "FeedVC.swift" for detail about cache
            if img != nil {
                self.showcaseImg.image = img
            } else {
                request = Alamofire.request(.GET, post.imageUrl!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, err in
                    if err == nil {
                        let img = UIImage(data: data!)!
                        self.showcaseImg.image = img
                        
                        // update cache with the current data and associate it with the url
                        FeedVC.imageCache.setObject(img, forKey: self.post.imageUrl!)
                    }
                })
            }
        } else {
            self.showcaseImg.hidden = true
        }
        
        
        // this will only perform once
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            // in Firebase, if you don't get a value from snapshot, you will get a "NSNull", not "nil" or any other things.
            if let doesNotExist = snapshot.value as? NSNull {
                // This means we have not liked this post yet
                self.likesImg.image = UIImage(named: "heart-empty")
            } else {
                self.likesImg.image = UIImage(named: "heart-full")
            }
        })
        
        
    }
    
    func likeTapped(sender: UITapGestureRecognizer!) {
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            // in Firebase, if you don't get a value from snapshot, you will get a "NSNull", not "nil" or any other things.
            if let doesNotExist = snapshot.value as? NSNull {
                // This means we have not liked this post yet
                self.likesImg.image = UIImage(named: "heart-full")
                self.post.adjustLikes(true)
                // because it is not there, so Firebase will create one for the URL
                self.likeRef.setValue(true)
            } else {
                self.likesImg.image = UIImage(named: "heart-empty")
                self.post.adjustLikes(false)
                // removes the entire entry, including the key and value
                self.likeRef.removeValue()
            }
        })
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
