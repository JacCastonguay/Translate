import Foundation
import Firebase

final class PostService {
    //Properties
    static let shared: PostService = PostService()
    
    private init() { }
    
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
    
}
