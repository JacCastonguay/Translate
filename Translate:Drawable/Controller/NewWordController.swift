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
    var photoRow:Int!
    
    @IBOutlet var englishWordField: RoundedTextField! {
        didSet {
            englishWordField.tag = 1
            englishWordField.becomeFirstResponder()
            englishWordField.delegate = self
        }
    }
    
    @IBOutlet var textHintForSpanishWord: RoundedTextField! {
        didSet {
            textHintForSpanishWord.tag = 2
            textHintForSpanishWord.delegate = self
        }
    }
    @IBOutlet var imageHintForSpanishWord: UIImageView!
    
    @IBOutlet var spanishWordField: RoundedTextField! {
        didSet {
            spanishWordField.tag = 3
            spanishWordField.delegate = self
        }
    }
    
    @IBOutlet var textHintForEnglishWord: RoundedTextField! {
        didSet {
            textHintForEnglishWord.tag = 4
            textHintForEnglishWord.delegate = self
        }
    }
    
    @IBOutlet var imageHintForEnglishWord: UIImageView!

    
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 || indexPath.row == 7 {
            
            photoRow = indexPath.row
            //Instantiate pop up Alert (Giving it a message)
            let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
            //Instantiate an alert action (camera choice)(need to add it to photoSourceRequestController after)
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = false
                    //this is the part that makes it a camera
                    imagePicker.sourceType = .camera
                    
                    self.present(imagePicker, animated: true, completion:  nil)
                }
            })
            //Instantiate another alert action (photo library choice)
            let photoLibraryAction = UIAlertAction(title: "Photo library", style: .default, handler: { (action) in
                if UIImagePickerController.isSourceTypeAvailable( .photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = false
                    //this part makes it the photoLibrary
                    imagePicker.sourceType = .photoLibrary
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            // Add these alert actions to the controller so we can pick the choices
            photoSourceRequestController.addAction(cameraAction)
            photoSourceRequestController.addAction(photoLibraryAction)
            //Make controller visible
            present(photoSourceRequestController, animated: true, completion:  nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        
        return true
    }
    //recall, action need to be set, just like outlets, sender being ANyObject just means the type accepted.
    @IBAction func saveButtonTapped(sender: AnyObject) {
        //If anything is empty pop up an alert controller
        if englishWordField.text == "" || spanishWordField.text == "" {
            let alertController = UIAlertController(title: "Oops", message: "Please enter both English definition and Spanish definition", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            
            return
        }
        //Top line is getting AppDelegate object
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            word = WordMO(context: appDelegate.persistentContainer.viewContext)
            word.englishWord = englishWordField.text
            word.englishTextHint = textHintForSpanishWord.text
            word.spanishWord = spanishWordField.text
            word.spanishTextHint = textHintForEnglishWord.text
            word.timesRight = 0
            
            if let img = imageHintForSpanishWord.image {
                //This lets us get the data in the form of PNG
                if img != UIImage(named: "photo"){
                   word.englishImageHint = UIImagePNGRepresentation(img)
                }
                
            }
            if let img = imageHintForEnglishWord.image {
                if img != UIImage(named: "photo"){
                    word.spanishImageHint = UIImagePNGRepresentation(img)
                }
            }
            appDelegate.saveContext()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        let viewForThisImage = photoRow == 3 ? imageHintForSpanishWord! : imageHintForEnglishWord!
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //temperary hard code for spanish Hint image until I can differentiate
            viewForThisImage.image = selectedImage
            viewForThisImage.contentMode = .scaleAspectFill
            viewForThisImage.clipsToBounds = true
        }
        
        let leadingConstraint = NSLayoutConstraint(item: viewForThisImage, attribute: .leading, relatedBy: .equal, toItem: viewForThisImage.superview, attribute: .leading, multiplier: 1, constant: 0)
        leadingConstraint.isActive = true
        
        let trailingConstraint = NSLayoutConstraint(item: viewForThisImage, attribute: .trailing, relatedBy: .equal, toItem: viewForThisImage.superview, attribute: .trailing, multiplier: 1, constant: 0)
        trailingConstraint.isActive = true
        
        let topConstraint = NSLayoutConstraint(item: viewForThisImage, attribute: .top, relatedBy: .equal, toItem: viewForThisImage.superview, attribute: .top, multiplier: 1, constant: 0)
        topConstraint.isActive = true
        
        let bottomConstraint = NSLayoutConstraint(item: viewForThisImage, attribute: .bottom, relatedBy: .equal, toItem: viewForThisImage.superview, attribute: .bottom, multiplier: 1, constant: 0)
        bottomConstraint.isActive = true
        
        dismiss(animated: true, completion: nil)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 8
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
