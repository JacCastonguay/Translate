//
//  SignUpViewController.swift
//  Translate:Drawable
//
//  Created by Jacques Castonguay on 3/31/18.
//  Copyright © 2018 JaxLab. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerAccount(sender: UIButton){
        //GitGud at getting values
        guard let name = nameTextField.text, name != "",
            let emailAdress = emailTextField.text, emailAdress != "",
            let password = passwordTextField.text, password != "" else {
                let alertController = UIAlertController(title: "Registration Error", message: "please provide a name, email, and password", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                present(alertController, animated: true, completion: nil)
                
                return
        }
        
        //Register the user account on Firebase
        Auth.auth().createUser(withEmail: emailAdress, password: password, completion: { (user, error) in
            //if there's an error show error if not continue to changeRequesr
            if let error = error {
                let alertController = UIAlertController(title: "Registration Error", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                return
                
            }
            //Save the name of the user
            if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                changeRequest.displayName = name
                changeRequest.commitChanges(completion: { (error) in
                    if let error = error {
                        print("Failed to change the display name: \(error.localizedDescription)")
                    }
                })
            }
            //Dismiss keyboard
            self.view.endEditing(true)
            
            //Send verification email
            user?.sendEmailVerification(completion: nil)
            
            let alertController = UIAlertController(title: "Email Verification", message: "We've just sent a confirmation email to your email address. Please check your inbox and click the verification link to sign up.", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: {(action) in
                //Dismiss the current view controller
                self.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(okayAction)
            self.present(alertController, animated: true, completion: nil)
            
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
