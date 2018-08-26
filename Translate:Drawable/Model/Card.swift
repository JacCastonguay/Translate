//
//  FirebaseWord.swift
//  Translate:Drawable
//
//  Created by Jacques Castonguay on 4/19/18.
//  Copyright © 2018 JaxLab. All rights reserved.
//

import Foundation
import UIKit

struct Card {
    var postId: String
    var imageHintForEngFileURL: String
    var user: String
    var englishWord: String
    var spanishWord: String
    var englishTextHint: String
    var spanishTextHint: String
    var timesRight: Int
    var timestamp: Int


    enum PostInfoKey {
        static let imageHintForEngFileURL = "imageHintForEngFileURL"
        static let user = "user"
        static let englishWord = "EnglishWord"
        static let spanishWord = "SpanishWord"
        static let englishTextHint = "EnglishTextHint"
        static let spanishTextHint = "SpanishTextHint"
        static let timesRight = "TimesRight"
        static let timestamp = "Timestamp"
    }

    init(postId: String, imageHintForEngFileURL: String, user: String, englishWord: String, spanishWord: String, englishTextHint: String, spanishTextHint: String, timesRight: Int, timestamp: Int = Int(NSDate().timeIntervalSince1970 * 1000) ){
        self.postId = postId
        self.imageHintForEngFileURL = imageHintForEngFileURL
        self.user = user
        self.englishWord = englishWord
        self.spanishWord = spanishWord
        self.englishTextHint = englishTextHint
        self.spanishTextHint = spanishTextHint
        self.timesRight = timesRight
        self.timestamp = timestamp
    }
    
    init?(postId: String, postInfo: [String: Any]) {
        guard let imageHintForEngFileURL = postInfo[PostInfoKey.imageHintForEngFileURL] as? String,
            let user = postInfo[PostInfoKey.user] as? String,
            let englishWord = postInfo[PostInfoKey.englishWord] as? String,
            let spanishWord = postInfo[PostInfoKey.spanishWord] as? String,
            let englishTextHint = postInfo[PostInfoKey.englishTextHint] as? String,
            let spanishTextHint = postInfo[PostInfoKey.spanishTextHint] as? String,
            let timesRight = postInfo[PostInfoKey.timesRight] as? Int,
            let timestamp = postInfo[PostInfoKey.timestamp] as? Int else {
                return nil
        }
        
        self = Card(postId: postId, imageHintForEngFileURL: imageHintForEngFileURL, user: user, englishWord: englishWord, spanishWord: spanishWord, englishTextHint: englishTextHint, spanishTextHint: spanishTextHint, timesRight: timesRight, timestamp: timestamp)
    }
    
    static func addLocaclly(englishWord:String, englishTextHint:String, spanishWord:String, spanishTextHint:String, englishImageHint:UIImage? = nil, chapter:String) -> Void {
        var word: WordMO!
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            word = WordMO(context: appDelegate.persistentContainer.viewContext)
            word.englishWord = englishWord
            word.englishTextHint = englishTextHint
            word.spanishWord = spanishWord
            word.spanishTextHint = spanishTextHint
            word.timesRight = 0
            word.chapter = chapter
            
            if let img = englishImageHint {
                print("AN ATTEMP WAS MADE TO CONVERT img")
                word.englishImageHint = UIImageJPEGRepresentation(img, 0.9)
            } else {
                print("imageCard was empty when trying to convert to JPEG")
            }
            
            appDelegate.saveContext()
        }
    }
}
