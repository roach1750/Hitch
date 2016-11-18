//
//  User.swift
//  Hitch
//
//  Created by Andrew Roach on 10/20/16.
//  Copyright © 2016 Andrew Roach. All rights reserved.
//

import UIKit



class User: NSObject {

    var firstName: String?
    var lastName: String?
    var driver: Bool?
    var rider: Bool?
    
    
    
    
    func createUser(_ firstname: String, lastName: String, driver: Bool, rider: Bool) -> User {
        
        let user = User()
        user.firstName = firstname
        user.lastName = lastName
        user.driver = driver
        user.rider = rider
        return user
    }
    
    func login(_ user: User) {
        
        print(user)
        
        let userName = user.firstName! + "_" + user.lastName!
        
        KCSUser.checkUsername(userName, withCompletionBlock: { (userName, alreadyTaken, error) in
            if alreadyTaken {
                print("this user already exists...attempting to login")
                
                KCSUser.login(withUsername: userName, password: "bounce", withCompletionBlock: { (user, error, resultAction) in
                    if user != nil {
                        print("logged in with existing userName")
                        
                    } else if let error = error as? NSError {
                        print(error.localizedDescription)
                    }
                })
            }
            else {
                print("creating a new kinvey user")
                
                KCSUser.user(withUsername: userName, password: "bounce", fieldsAndValues: [
                    "rider" : user.rider!, "driver" : user.driver!, "rating" : 0.0,
                    KCSUserAttributeGivenname : user.firstName!,
                    KCSUserAttributeSurname : user.lastName!],
                             
                             withCompletionBlock: { (user, error, resultAction) in
                                if error == nil {
                                    print("Created new user")
                                    
                                    let defaults = UserDefaults.standard
                                    defaults.set(userName, forKey: "userName")
                                    
                                    
                                    print(KCSUser.active())

                                } else {
                                    print(error as! String)
                                }
                })
            }
        })

        
        
    }
    
    
}
