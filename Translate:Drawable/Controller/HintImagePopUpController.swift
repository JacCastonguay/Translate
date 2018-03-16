//
//  HintImagePopUpController.swift
//  Translate:Drawable
//
//  Created by Jacques Castonguay on 3/9/18.
//  Copyright © 2018 JaxLab. All rights reserved.
//

import UIKit

class HintImagePopUpController: UIViewController {

    @IBOutlet weak var BackButton: UIButton!
    @IBOutlet weak var HintImage: UIImageView!
    @IBOutlet var backgroundView: UIView!
    var hintText:String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let hint = hintText {
            HintImage.image = UIImage(named: hint)
        }
        backgroundView.backgroundColor = UIColor(white: 1, alpha: 0.5)
    }
    
    @IBAction func ClosePopUp(_ sender: Any) {
        dismiss(animated: true, completion:nil )
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
