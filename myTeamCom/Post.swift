//
//  Post.swift
//  myTeamCom
//
//  Created by aloha kids on 11/28/15.
//  Copyright © 2015 Richard. All rights reserved.
//

import Foundation

class Post {
    private var _postDescription: String!
    private var _imageUrl: String?
    private var _likes: Int!
    private var _username: String!
    private var _postKey: String!
    
    var postDescription: String {
        return _postDescription
    }
    var imageUrl: String? {
        return _imageUrl
    }
    var likes: Int {
        return _likes
    }
    var username: String {
        return _username
    }
    
    init(description: String, imageLink: String?, usernameExt: String) {
        self._postDescription = description
        self._imageUrl = imageLink
        self._username = usernameExt
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
    }
}