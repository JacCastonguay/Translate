//
//  FirebaseWord.swift
//  Translate:Drawable
//
//  Created by Jacques Castonguay on 4/19/18.
//  Copyright © 2018 JaxLab. All rights reserved.
//

import Foundation
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
}
