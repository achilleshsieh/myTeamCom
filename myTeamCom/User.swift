//
//  User.swift
//  myTeamCom
//
//  Created by aloha kids on 12/3/15.
//  Copyright © 2015 Richard. All rights reserved.
//

import Foundation
import Firebase

class User {
    private var _userId: String!
    private var _profileImgUrl: String!
    private var _userName: String!
    private var _userRef: Firebase!
    
    var userId: String {
        return _userId
    }
    var profileImgUrl: String {
        return _profileImgUrl
    }
    var userName: String {
        return _userName
    }
    
    init(extUsrId: String, extProfileImgUrl: String) {
        self._userId = extUsrId
        self._profileImgUrl = extProfileImgUrl
    }
    init(userKey: String, dict: Dictionary<String, AnyObject>) {
        self._userId = userKey

        if let imgUrl = dict["imageUrl"] as? String {
            self._profileImgUrl = imgUrl
        } else {
            self._profileImgUrl = ""
        }
        if let usrName = dict["username"] as? String {
            self._userName = usrName
        } else {
            self._userName = ""
        }
    
        self._userRef = DataService.ds.REF_USERS.childByAppendingPath(self._userId)
    }

}
