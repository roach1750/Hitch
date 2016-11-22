//
//  LoginVC.swift
//  Hitch
//
//  Created by Andrew Roach on 10/20/16.
//  Copyright © 2016 Andrew Roach. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginVC: UIViewController, FBSDKLoginButtonDelegate {

    
    @IBOutlet weak var profilePictureView: FBSDKProfilePictureView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func viewDidLoad() {
        nameLabel.text = ""
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = self.view.center
        loginButton.delegate = self
        self.view.addSubview(loginButton)
        
        super.viewDidLoad()
    }


    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: {});

    }
    func login() {
        
        if FBSDKAccessToken.current() != nil {
            //facebook login succesfull, create user:
            let user = User()
            user.createUser()
            
        }
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
    {
        print("login to facebook complete")
        print(result)
        
        
        login()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        if KCSUser.active() != nil {
            KCSUser.active().logout()
        }
        configureContinueButton()
        print("User Logged Out")
        
    }
    
    func configureContinueButton() {
        
        if FBSDKAccessToken.current() != nil && KCSUser.active() != nil {
            print("Logged in with Facebook & Kinvey")
            
        }
        else {
            print("Not Login")
            
            
        }
    }
    

}
