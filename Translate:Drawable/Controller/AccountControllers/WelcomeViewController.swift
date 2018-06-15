//
//  WelcomeViewController.swift
//  Translate:Drawable
//
//  Created by Jacques Castonguay on 3/31/18.
//  Copyright © 2018 JaxLab. All rights reserved.
//

import UIKit
import Firebase
import SwiftyPlistManager

class WelcomeViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftyPlistManager.shared.start(plistNames: ["TranslateDataProperties"], logging: true)
        guard let lastUpdate = SwiftyPlistManager.shared.fetchValue(for: "lastUpdate", fromPlistWithName: "TranslateDataProperties") as? Int else {
            SwiftyPlistManager.shared.save(0, forKey: "lastUpdate", toPlistWithName: "TranslateDataProperties") { (err) in
                if err == nil {
                    print("saved last update as 0")
                }
            }
            return
        }
        //Reset timestamp to zero for testing
        //SwiftyPlistManager.shared.save(0, forKey: "lastUpdate", toPlistWithName: "TranslateDataProperties") { (err) in if err == nil { print("reset 'lastUpdate' to 0 for testing.") } }
        let auth = Auth.auth()
        auth.addStateDidChangeListener { [weak self] (_, user) in
            if let user = user {
                print("logged in " + user.displayName!)                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "MainView")
                self?.present(controller, animated: true, completion: nil)
                    
                
            } else {
                print("not logged in")
            }
            
        }
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
