//
//  PostCell.swift
//  myTeamCom
//
//  Created by aloha kids on 11/28/15.
//  Copyright © 2015 Richard. All rights reserved.
//

import UIKit
import Alamofire

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showcaseImg: UIImageView!
    @IBOutlet weak var descText: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    var post: Post!
    var request: Request?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func drawRect(rect: CGRect) {
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        showcaseImg.clipsToBounds = true
    }
    
    func configureCell(post: Post, img: UIImage?) {
        self.post = post
        
        self.descText.text = post.postDescription
        self.likesLbl.text = "\(post.likes)"
        
        if post.imageUrl != nil {
            if img != nil {
                self.showcaseImg.image = img
            } else {
                request = Alamofire.request(.GET, post.imageUrl!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, err in
                    if err == nil {
                        let img = UIImage(data: data!)!
                        self.showcaseImg.image = img
                        FeedVC.imageCache.setObject(img, forKey: self.post.imageUrl!)
                    }
                })
            }
        } else {
            self.showcaseImg.hidden = true
        }
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
