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

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    func login(_ user: User) {
//        
//        let userName = user.firstName! + "_" + user.lastName!
//        
//        KCSUser.checkUsername(userName, withCompletionBlock: { (userName, alreadyTaken, error) in
//            if alreadyTaken {
//                print("this user already exists...attempting to login")
//                
//                KCSUser.login(withUsername: userName, password: "bounce", withCompletionBlock: { (user, error, resultAction) in
//                    if user != nil {
//                        print("logged in with existing userName")
//                        
//                    } else if let error = error as? NSError {
//                        print(error.localizedDescription)
//                    }
//                })
//            }
//            else {
//                print("creating a new kinvey user")
//                
//                KCSUser.user(withUsername: userName, password: "bounce", fieldsAndValues: [
//                    "rider" : user.rider!, "driver" : user.driver!, "rating" : 0.0,
//                    KCSUserAttributeGivenname : user.firstName!,
//                    KCSUserAttributeSurname : user.lastName!],
//                             
//                             withCompletionBlock: { (user, error, resultAction) in
//                                if error == nil {
//                                    print("Created new user")
//                                    
//                                    let defaults = UserDefaults.standard
//                                    defaults.set(userName, forKey: "userName")
//                                    
//                                    
//                                    print(KCSUser.active())
//
//                                } else {
//                                    print(error as! String)
//                                }
//                })
//            }
//        })
//
//        
//        
//    }
    
    
}
