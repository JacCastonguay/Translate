//
//  word.swift
//  Translate:Drawable
//
//  Created by Jacques Castonguay on 2/21/18.
//  Copyright © 2018 JaxLab. All rights reserved.
//

import Foundation
class Word {
    var englishWord: String
    var spanishWord: String
    var spanishTextHint: String
    var spanishImageHint:Data?
    var englishTextHint: String
    var englishImageHint:Data?


    init(englishWord: String, spanishWord: String, spanishTextHint:String = "", spanishImageHint:Data? = nil, englishTextHint:String = "", englishImageHint:Data? = nil){
        self.englishWord = englishWord
        self.spanishWord = spanishWord
        self.spanishTextHint = ""
        self.spanishImageHint = spanishImageHint
        self.englishTextHint = ""
        self.englishImageHint = englishImageHint
    }
    
}
