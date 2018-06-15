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

    let lastUpdateName = "lastUpdate"
    let translateDataPropertiesName = "TranslateDataProperties"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftyPlistManager.shared.start(plistNames: [translateDataPropertiesName], logging: true)
        guard let lastUpdate = SwiftyPlistManager.shared.fetchValue(for: lastUpdateName, fromPlistWithName: translateDataPropertiesName) as? Int else {
            SwiftyPlistManager.shared.save(0, forKey: lastUpdateName, toPlistWithName: translateDataPropertiesName) { (err) in
                if err == nil {
                    print("saved last update as 0")
                }
            }
            return
        }
        //Reset timestamp to zero for testing
        //SwiftyPlistManager.shared.save(0, forKey: lastUpdateName, toPlistWithName: translateDataPropertiesName) { (err) in if err == nil { print("reset 'lastUpdate' to 0 for testing.") } }
        let auth = Auth.auth()
        auth.addStateDidChangeListener { [weak self] (_, user) in
            if let user = user {
                print("logged in " + user.displayName!)                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "MainView")
                self?.present(controller, animated: false, completion: nil)
                    
                
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
