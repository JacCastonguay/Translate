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
    

}
