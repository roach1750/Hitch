//
//  LoginVC.swift
//  Hitch
//
//  Created by Andrew Roach on 10/20/16.
//  Copyright © 2016 Andrew Roach. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var driverSwitch: UISwitch!

    @IBOutlet weak var riderSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: {});

    }

    @IBAction func createUserButtonPressed(_ sender: UIButton) {
        
        print(firstNameTextField.text!)
        print(lastNameTextField.text!)
        
        
        
        let user = User().createUser(firstNameTextField.text!, lastName: lastNameTextField.text!, driver: driverSwitch.isOn, rider: riderSwitch.isOn)
        User().login(user)
    
        dismiss(animated: true, completion: nil)
    }


}
