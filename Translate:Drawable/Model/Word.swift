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
    var englishHint: Hint
    var spanishHint: Hint
    
    init(englishWord: String, spanishWord: String, englishHint: Hint, spanishHint: Hint){
        self.englishWord = englishWord
        self.spanishWord = spanishWord
        self.englishHint = englishHint
        self.spanishHint = spanishHint
    }
}
