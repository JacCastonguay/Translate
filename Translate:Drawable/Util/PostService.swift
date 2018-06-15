import Foundation
import Firebase
import SwiftyPlistManager


final class PostService {
    //Properties
    static let shared: PostService = PostService()
    
    private init() { }
    
    let lastUpdateName = "lastUpdate"
    let translateDataPropertiesName = "TranslateDataProperties"
    
    //Firebase Database References
    
    let BASE_DB_REF: DatabaseReference = Database.database().reference()
    let POST_DB_REF: DatabaseReference = Database.database().reference().child("cards")
    
    //Firebase Storage Ref
    let PHOTO_STORAGE_REF: StorageReference = Storage.storage().reference().child("photos")
    
    func UploadImage(englishImage:UIImage, englishWord:String, spanishWord:String, textHintForEnglishWord:String, textHintForSpanishWord:String ) -> Void {
        //Firebase upload stuff
        
        //Generate a Unique ID for the post and prepare te post DB
        //this accesses .child("cards")
        let postDatabaseRef = PostService.shared.POST_DB_REF.childByAutoId()
        
        //Use the unique key as the image name and prepare the storage reference
        //This accesses .child("photos")
        let imageStorageRef = PostService.shared.PHOTO_STORAGE_REF.child("\(postDatabaseRef.key).jpg")
        
        //NOTE: Make this optional eventually
        let scaledImageHintForEnglishWord = englishImage.scale(newWidth: 640)
        guard let imageData4Eng = UIImageJPEGRepresentation(scaledImageHintForEnglishWord, 0.9) else {
            print("HA! you've activated my 'photo couldn't be turned to jpe card'")
            return
        }
        
        
        //Create the file metadate
        //right now we can only upload one photo at a time
        let metadata4Eng = StorageMetadata()
        metadata4Eng.contentType = "image/jpg"
        
        //Prepare the upload task
        let uploadTask4Eng = imageStorageRef.putData(imageData4Eng, metadata: metadata4Eng)
        
        //Observe the upload status
        uploadTask4Eng.observe(.success) { (snapshot) in
            guard let displayName = Auth.auth().currentUser?.displayName else {
                return
            }
            
            //Add a reference to the DB
            if let imageFileURL = snapshot.metadata?.downloadURL()?.absoluteString {
                let timestamp = Int(NSDate().timeIntervalSince1970 * 1000)
                
                let card: [String : Any] = [Card.PostInfoKey.imageHintForEngFileURL: imageFileURL,
                                            Card.PostInfoKey.user: displayName,
                                            Card.PostInfoKey.englishWord: String(describing: englishWord),
                                            Card.PostInfoKey.spanishWord: String(describing: spanishWord),
                                            Card.PostInfoKey.englishTextHint: String(describing: textHintForEnglishWord),
                                            Card.PostInfoKey.spanishTextHint: String(describing: textHintForSpanishWord),
                                            Card.PostInfoKey.timesRight: Int(0),
                                            Card.PostInfoKey.timestamp:timestamp
                                            ]
                
                postDatabaseRef.setValue(card)
                
            }
            //change to a completion handler if need be.
            //self.dismiss(animated: true, completion: nil)
        }
        
        uploadTask4Eng.observe(.progress) { (snapshot) in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            print("Uploading \(postDatabaseRef.key).jpg... \(percentComplete)% complete")
        }
        
        uploadTask4Eng.observe(.failure) { (snapshot) in
            if let error = snapshot.error {
                print(error.localizedDescription)
            }
        }
        
        //dismiss(animated: true, completion: nil)
    }
    
    
    //Pull posts from Firebase
    fileprivate func updatePlist(_ card: Card) {
        SwiftyPlistManager.shared.save(card.timestamp, forKey: lastUpdateName, toPlistWithName: "TranslateDataProperties", completion: { (err) in
            if err == nil {
                print("successfully updated 'lastUpdate'")
            } else {
                print("there was an error updating 'lastUpdate':")
                print(err!)
            }
        })
    }
    
    func getRecentCards() {
        var cardQuery = PostService.shared.POST_DB_REF.queryOrdered(byChild: Card.PostInfoKey.timestamp)
        //initted in welcomeViewController
        guard let lastUpdate = SwiftyPlistManager.shared.fetchValue(for: "lastUpdate", fromPlistWithName: translateDataPropertiesName) else {return}
        let compareTime = lastUpdate as! Int
        cardQuery = cardQuery.queryStarting(atValue: compareTime + 1, childKey: Card.PostInfoKey.timestamp)
        
        // Call Firebase API to retrieve the latest records
        cardQuery.observeSingleEvent(of: .value, with: { (snapshot) in
            
            var newCards: [Card] = []
            for item in snapshot.children.allObjects as! [DataSnapshot] {
                let cardInfo = item.value as? [String: Any] ?? [:]
                if let card = Card(postId: item.key, postInfo: cardInfo) {
                    newCards.append(card)
                }
            }
            
            if newCards.count > 0 {
                //Order in descending order (i.e. the latest card becomes the first card)
                newCards.sort(by: {$0.timestamp < $1.timestamp})
                
                for card in newCards {
                    if card.timestamp > compareTime {
                        self.updatePlist(card)
                        //Download Image
                        var cardImage: UIImage?
                        if let url = URL(string: card.imageHintForEngFileURL) {
                            let downloadTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                                guard let imageData = data else {
                                    return
                                }
                                
                                OperationQueue.main.addOperation {
                                    guard let image = UIImage(data: imageData) else { return }
                                    cardImage = image
                                    Card.addLocaclly(englishWord: card.englishWord, englishTextHint: card.englishTextHint, spanishWord: card.spanishWord, spanishTextHint: card.spanishTextHint, englishImageHint: cardImage)
                                }
                                
                                if let err = error {
                                    print("An error occurred:")
                                    print(err.localizedDescription)
                                }
                            })
                            downloadTask.resume()
                        } else {print("url was not properly set")}
                    } else {print("card was not newer")}
                }
            }
        })
    }
    
    
}
