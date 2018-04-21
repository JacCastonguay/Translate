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
    
//    func uploadImage(image: UIImage, completionHandler: @escaping() -> Void) {
//        //Generate a unique ID for the post and prepare the post DB reference
//        let postDatabaseRef = POST_DB_REF.childByAutoId()
//
//        //Use the unique key as the image name and prepare the storage reference
//        let imageStorageRef = PHOTO_STORAGE_REF.child("\(postDatabaseRef.key).jpg")
//
//        //Resize the image
//        let scaledImage = image.scale(newWidth: 640.0)
//
//        guard let imageData4Eng = UIImageJPEGRepresentation(scaledImage, 0.9) else {
//            return
//        }
//
//        //Create the file metadate
//        //right now we can only upload one photo at a time
//        let metadata4Eng = StorageMetadata()
//        metadata4Eng.contentType = "image/jpg"
//
//        //Prepare the upload task
//        let uploadTask = imageStorageRef.putData(imageData4Eng, metadata: metadata4Eng)
//
//        //Observe the upload status
//        uploadTask.observe(.success) { (snapshot) in
//            guard let displayName = Auth.auth().currentUser?.displayName else {
//                return
//            }
//
//            //Add a reference to the DB
//            if let imageFileURL = snapshot.metadata?.downloadURL()?.absoluteString {
//                let timestamp = Int(NSDate().timeIntervalSince1970 * 1000)
//                //Not sure if I should set up variables for this
//                let card: [String : Any] = [Card.PostInfoKey.imageHintForEngFileURL: imageFileURL,
//                                            Card.PostInfoKey.user: displayName,
//                                            Card.PostInfoKey.englishWord: String(describing: self.englishWordField.text),
//                                            Card.PostInfoKey.spanishWord: String(describing: self.spanishWordField.text),
//                                            Card.PostInfoKey.englishTextHint: String(describing: self.textHintForEnglishWord.text),
//                                            Card.PostInfoKey.spanishTextHint: String(describing: self.textHintForSpanishWord.text),
//                                            Card.PostInfoKey.timesRight: Int(0),
//                                            Card.PostInfoKey.timestamp:timestamp
//                ]
//
//                postDatabaseRef.setValue(card)
//
//            }
//
//            completionHandler()
//        }
//
//        uploadTask.observe(.progress) { (snapshot) in
//
//            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
//            print("Uploading \(postDatabaseRef.key).jpg... \(percentComplete)% complete")
//        }
//
//        uploadTask.observe(.failure) { (snapshot) in
//
//            if let error = snapshot.error {
//                print(error.localizedDescription)
//            }
//        }
//
//
//    }
}
