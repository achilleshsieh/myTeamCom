//
//  ViewController.swift
//  myTeamCom
//
//  Created by aloha kids on 11/23/15.
//  Copyright © 2015 Richard. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var emailField: MaterialTextField!
    @IBOutlet weak var passwdField: MaterialTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The following function will take logged in user directly to the next screen, instead of log in again
    // Segue doesn't work when view did load, but after. So we need this "viewDidAppear" function
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
    }
    
    // Facebook login
    @IBAction func fbBtnPressed(sender: UIButton!) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email"]) { (facebookResult: FBSDKLoginManagerLoginResult!, facebookError: NSError!) -> Void in
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("Successfully logged in Facebook: \(accessToken)")
                
                DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error, authData in
                    
                    if error != nil {
                        print("Login failed. \(error)")
                    } else {
                        print("Login Successfully \(authData)")
                        
                        // it is better to do the "if let" statement. But it will require error handler etc. 
                        // to keep it simple, we used "!" instead. 
                        
                        let user = ["provider": authData.provider!, "blah": "test"]
                        DataService.ds.createFirebaseUser(authData.uid, user: user)
                        
                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                    
                        self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                    }
                })
            }
        }
    }
    
    // Email login
    @IBAction func emailBtnPressed(sender: UIButton!) {
        if let email = emailField.text where email != "", let pwd = passwdField.text where pwd != "" {
            if email.rangeOfString("@") != nil {
                
                DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { error, authData in
                    if error != nil {
                        if error.code == STATUS_ACCT_NONEXIST {
                            DataService.ds.REF_BASE.createUser(email, password: pwd, withValueCompletionBlock: { errCreateUser, resultCreateUser in
                                
                                // there are a lot of different error code for creating account
                                // should explore further later
                                if errCreateUser != nil {
                                    self.showErrorAlert("Could not create account", msg: "Try something different")
                                } else {
                                    // Option1 to get user UID information
                                    NSUserDefaults.standardUserDefaults().setValue(resultCreateUser[KEY_UID], forKey: KEY_UID)
                                    // log into the app using information passed from OAuth
                                    DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { errorLogIn, resultLogIn in
                                        // this will not have any error because we are creating the user
                                        // and log in using the same information
                                        
                                        // it is better to do the "if let" statement. But it will require error handler etc.
                                        // to keep it simple, we used "!" instead.
                                        
                                        // Option2 to get user UID information
                                        // NSUserDefaults.standardUserDefaults().setValue(resultLogIn.uid, forKey: KEY_UID)
                                        let user = ["provider": resultLogIn.provider!, "blah": "emailTest"]
                                        DataService.ds.createFirebaseUser(resultLogIn.uid, user: user)
                                        
                                    })
                                    
                                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                                }
                            })
                        } else if error.code == STATUS_ACCT_WR_PWD {
                            self.showErrorAlert("Wrong Password", msg: "Please reenter your password")
                        } else {
                            self.showErrorAlert("Something is wrong", msg: "Please check your username")
                        }
                    } else {
                        // if there is no error, that means the user name and password are correct
                        // then directly sign the guy in
                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                        
                        self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                    }
                    
                })
                
            } else {
                showErrorAlert("Invalid Email Address", msg: "Please enter a valid email address")
            }
            
        } else {
            showErrorAlert("Email and Password Required", msg: "You must enter an email and a password")
        }
    }
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }


}

