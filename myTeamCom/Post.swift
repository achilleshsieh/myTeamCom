//
//  Post.swift
//  myTeamCom
//
//  Created by aloha kids on 11/28/15.
//  Copyright © 2015 Richard. All rights reserved.
//

import Foundation
import Firebase

class Post {
    private var _postDescription: String!
    private var _imageUrl: String?
    private var _likes: Int!
    private var _userId: String!
    private var _postKey: String!
    private var _postTimeStamp : String!
    private var _postRef: Firebase!
    
    var postDescription: String {
        return _postDescription
    }
    var imageUrl: String? {
        return _imageUrl
    }
    var likes: Int {
        return _likes
    }
    var userId: String {
        return _userId
    }
    var postKey: String {
        return _postKey
    }
    var postTimeStamp: String {
        return _postTimeStamp
    }
    
    init(description: String, imageLink: String?, userIdExt: String) {
        self._postDescription = description
        self._imageUrl = imageLink
        self._userId = userIdExt
    }
    
    init(postKey: String, dict: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let likes = dict["likes"] as? Int {
            self._likes = likes
        }
        if let imgUrl = dict["imageUrl"] as? String {
            self._imageUrl = imgUrl
        }
        if let desc = dict["description"] as? String {
            self._postDescription = desc
        }
        if let timeStamp = dict["timeStamp"] as? String {
            self._postTimeStamp = timeStamp
        }
        if let usrId = dict["userId"] as? String {
            self._userId = usrId
        }
        self._postRef = DataService.ds.REF_POSTS.childByAppendingPath(self._postKey)
    }
    
    func adjustLikes(addLike: Bool) {
        if addLike {
            self._likes = self._likes + 1
        } else {
            self._likes = self._likes - 1
        }
        _postRef.childByAppendingPath("likes").setValue(_likes)
    }
}