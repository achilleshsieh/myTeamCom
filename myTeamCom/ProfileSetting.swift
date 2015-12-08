//
//  ProfileSetting.swift
//  myTeamCom
//
//  Created by aloha kids on 12/6/15.
//  Copyright © 2015 Richard. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class ProfileSetting: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var profileImg: UIImageView!
    
    var userProfileRef: Firebase!
    var userProfileImgRef: Firebase!
    var request: Request?
    var currentUser: User!
    var imageSelected = false
    var imagePicker: UIImagePickerController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        
        // instantiate imagePicker
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        DataService.ds.REF_USER_CURRENT.observeEventType(.Value, withBlock: { snapshot in
            if let snap = snapshot.value.allObjects as? FDataSnapshot {
                if let currentUserDict = snap.value as? Dictionary<String, AnyObject> {
                    let key = snapshot.key
                    self.currentUser = User(userKey: key, dict: currentUserDict)
                }
            }
            
            if self.currentUser.userName == "" {
                self.userNameField.text = ""
            } else {
                self.userNameField.text = self.currentUser.userName
            }
            
            if self.currentUser.profileImgUrl == "" {
                self.profileImg.image = UIImage(named: "camera-g")
            } else {
                self.request = Alamofire.request(.GET, self.currentUser.profileImgUrl).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, err in
                    if err == nil {
                        let img = UIImage(data: data!)!
                        self.profileImg.image = img
                        
                    }
                })
            }
            
            }, withCancelBlock: { error in
                print(error.description)
        })
        
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        profileImg.image = image
        imageSelected = true
        
    }
    
    @IBAction func selectImg(sender: UITapGestureRecognizer) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func profileUpdatePressed(sender: MaterialButton) {
        
        if let img = profileImg.image where imageSelected == true {
            
            let urlStr = "https://post.imageshack.us/upload_api.php"
            let url = NSURL(string: urlStr)!
            
            // iOS is very big on 3.5 MB file upload size
            // to have a quicker upload speed, the image needs to be compressed
            // the compression ratio: 0 is fully compressed, 1 is not compressed at all
            let imgData = UIImageJPEGRepresentation(img, 0.2)!
            
            // Alamofire requires all data posted to be converted to NSData
            let keyData = "049CMPSYc8f1d5c674bfa2feb8c3d99c7457c1e2".dataUsingEncoding(NSUTF8StringEncoding)!
            let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
            
            // upload image to ImageShack using Alamofire
            Alamofire.upload(.POST, url, multipartFormData: { multipartFormData in
                
                multipartFormData.appendBodyPart(data: imgData, name: "fileupload", fileName: "image", mimeType: "image/jpg")
                multipartFormData.appendBodyPart(data: keyData, name: "key")
                multipartFormData.appendBodyPart(data: keyJSON, name: "format")
                
                }) { encodingResult in
                    
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseJSON(completionHandler: { response in
                            
                            if let info = response.result.value as? Dictionary<String, AnyObject> {
                                
                                if let links = info["links"] as? Dictionary<String, AnyObject> {
                                    if let imgLink = links["image_link"] as? String {
                                        
                                        // print("Links: \(imgLink)")
                                        self.postToFirebase(imgLink)
                                    }
                                }
                            }
                        })
                    case .Failure(let error):
                        print(error)
                    }
                    
            }
        } else {
            self.postToFirebase(nil)
        }
    }
    
    func postToFirebase(imgUrl: String?) {
        
        // get current user information
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        
        // prepare post data
        
        var currentUser: Dictionary<String, AnyObject> = [
            "username": userNameField.text!
        ]
        if imgUrl != nil {
            currentUser["imageUrl"] = imgUrl!
        }
        
        // create a new child object under "posts" on Firebase, with UID
        let firebasePost = DataService.ds.REF_USERS.childByAppendingPath(uid)
        firebasePost.setValue(currentUser)
            
    }
}
