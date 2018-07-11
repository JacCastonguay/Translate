//
//  NewWordController.swift
//  Translate:Drawable
//
//  Created by Jacques Castonguay on 3/17/18.
//  Copyright © 2018 JaxLab. All rights reserved.
//

import UIKit
import Firebase

class NewWordController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var word: WordMO!
    var photoRow:Int!
    var imageSelected = false
    
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
    @IBOutlet var imageHint: UIImageView!
    
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
        if indexPath.row == 3 {//|| indexPath.row == 7 {
            
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
        
        //Firebase upload stuff
        //TODO: see if passing null image leads to any errors.
        if(imageSelected){
            PostService.shared.UploadImage(hintImage: self.imageHint.image!, englishWord: self.englishWordField.text!, spanishWord: self.spanishWordField.text!, textHintForEnglishWord: self.textHintForEnglishWord.text!, textHintForSpanishWord: self.textHintForSpanishWord.text!)
            Card.addLocaclly(englishWord: self.englishWordField.text!, englishTextHint: self.textHintForEnglishWord.text!, spanishWord: self.spanishWordField.text!, spanishTextHint: self.textHintForSpanishWord.text!, englishImageHint:self.imageHint.image!)
        } else {
            PostService.shared.uploadNonImage(englishWord: self.englishWordField.text!, spanishWord: self.spanishWordField.text!, textHintForEnglishWord: self.textHintForEnglishWord.text!, textHintForSpanishWord: self.textHintForSpanishWord.text!)
            Card.addLocaclly(englishWord: self.englishWordField.text!, englishTextHint: self.textHintForEnglishWord.text!, spanishWord: self.spanishWordField.text!, spanishTextHint: self.textHintForSpanishWord.text!)

        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        let viewForThisImage = imageHint!
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
        
        imageSelected = true
        
        dismiss(animated: true, completion: nil)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

}
