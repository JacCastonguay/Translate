//
//  VocabCardView.swift
//  Translate:Drawable
//
//  Created by Jacques Castonguay on 2/27/18.
//  Copyright © 2018 JaxLab. All rights reserved.
//

import UIKit

class VocabCardView: UIView {
    @IBOutlet var wordButton:UIButton!
    @IBOutlet var useHintsbutton:UIButton!
    @IBOutlet var hintLabel:UILabel!
    @IBOutlet var hintImage: UIImageView!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var wrongButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    
    override func setNeedsDisplay() {
        super.setNeedsDisplay()
    }
    


}
