//
//  User.swift
//  Hitch
//
//  Created by Andrew Roach on 10/20/16.
//  Copyright © 2016 Andrew Roach. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftyJSON


class User: NSObject {

    func createUser() {
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, email, last_name, id, picture.type(large)"]).start { (connection, result, error) -> Void in
            
            
            let resultsJSON = JSON(result!).dictionaryValue
            
            let givenName = resultsJSON["first_name"]?.rawString()
            let surname = resultsJSON["last_name"]?.rawString()
            let userId = resultsJSON["id"]?.rawString()
            let email = resultsJSON["email"]?.rawString()

            
            let userName = givenName! + "_" + surname! + "_" + userId!
            
            KCSUser.checkUsername(userName, withCompletionBlock: { (userName, alreadyTaken, error) in
                if alreadyTaken {
                    print("this user already exists...attempting to login")
                    
                    KCSUser.login(withUsername: userName, password: "hitch", withCompletionBlock: { (user, error, resultAction) in
                        if user != nil {
                            print("logged in with existing userName")
                            
                        } else if let error = error as? NSError {
                            print(error.localizedDescription)
                        }
                    })
                }
                else {
                    print("creating a new kinvey user")
                    
                    KCSUser.user(withUsername: userName, password: "hitch", fieldsAndValues: [
                        KCSUserAttributeEmail : email!,
                        KCSUserAttributeGivenname : givenName!,
                        KCSUserAttributeSurname : surname!, "Facebook User ID" : userId!],
                                 
                                 withCompletionBlock: { (user, error, resultAction) in
                                    if error == nil {
                                        print("Created new user")
                                        print(KCSUser.active())

                                    } else {
                                        print(error!)
                                    }
                    })
                }
            })
        }
        
    }

    
    var fetchedUser: KCSUser?
    
    func fetchUser(withID: String) {
        
        print("Fetching User for ID \(withID)...")
            
        KCSUserDiscovery.lookupUsers(forFieldsAndValues: ["_id" : withID], completionBlock: { (result, error) in
            if error == nil {
                self.fetchedUser = result?.first as? KCSUser
                NotificationCenter.default.post(name: Notification.Name(rawValue: "UserDownloaded"), object: nil)

            }
            else {
            
            }
            
            }, progressBlock: nil)
    }
    
    var fetchedUserPicture: Data?

    
    func fetchFBUserProfilePicture(id: String){
        if let url = NSURL(string: "https://graph.facebook.com/\(id)/picture?width=640&height=640"){
            do {
                fetchedUserPicture = try Data(contentsOf: url as URL)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "UserPictureDownloaded"), object: nil)

            
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    
}
