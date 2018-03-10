//
//  hint.swift
//  Translate:Drawable
//
//  Created by Jacques Castonguay on 3/4/18.
//  Copyright © 2018 JaxLab. All rights reserved.
//

import Foundation

class Hint {
    var phrase: String?
    var imageName: String?
    
    init (phrase: String? = nil, imageName: String? = nil){
        self.phrase = phrase
        self.imageName = imageName
    }
}
