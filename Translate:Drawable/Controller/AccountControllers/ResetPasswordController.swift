//
//  ResetPasswordController.swift
//  Translate:Drawable
//
//  Created by Jacques Castonguay on 4/3/18.
//  Copyright © 2018 JaxLab. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    
    @IBAction func resetPassword(sender: UIButton) {
        //Validate input
        guard let emailAdress = emailTextField.text, emailAdress != "" else {
            let alertController = UIAlertController(title: "Input Error", message: "please provide an email for password reset", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okayAction)
            present(alertController, animated: true, completion: nil)
            
            return
        }
        
        //Send the password reset to the email
        Auth.auth().sendPasswordReset(withEmail: emailAdress, completion: {(error) in
            let title = (error == nil) ? "Password reset Follow-up" : "Password Reset Error"
            let message = (error == nil) ? "We have just sent you a password reset email. Please check your inbox and follow the instructions to reset your password." : error?.localizedDescription
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: {
                (action) in
                if error == nil {
                    //Dismiss keyboard
                    self.view.endEditing(true)
                    
                    //Return to the login screen
                    if let navController = self.navigationController {
                        navController.popViewController(animated: true)
                    }
                }
            })
            alertController.addAction(okayAction)
            
            self.present(alertController, animated: true, completion: nil)
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
