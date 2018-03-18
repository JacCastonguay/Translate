//
//  NewWordController.swift
//  Translate:Drawable
//
//  Created by Jacques Castonguay on 3/17/18.
//  Copyright © 2018 JaxLab. All rights reserved.
//

import UIKit
import UIKit

class NewWordController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var word: WordMO!
    
    @IBOutlet var EnglishWordField: RoundedTextField! {
        didSet {
            EnglishWordField.tag = 1
            EnglishWordField.becomeFirstResponder()
            EnglishWordField.delegate = self
        }
    }
    
    @IBOutlet var HintForEnglishWordField: RoundedTextField! {
        didSet {
            HintForEnglishWordField.tag = 2
            HintForEnglishWordField.delegate = self
        }
    }
    @IBOutlet var HintImageForEnglishWord: UIImageView!
    
    @IBOutlet var spanishWordField: RoundedTextField! {
        didSet {
            spanishWordField.tag = 2
            spanishWordField.delegate = self
        }
    }
    
    @IBOutlet var HintForSpanishWordField: RoundedTextField! {
        didSet {
            HintForSpanishWordField.tag = 2
            HintForSpanishWordField.delegate = self
        }
    }
    
    @IBOutlet var HintImageForSpanishWord: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Config navigation bar appearance
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedStringKey.foregroundColor: UIColor(red: 231/255.0, green: 76/255.0, blue: 60/255.0, alpha: 1.0)]
        
        tableView.separatorStyle = .none

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
