//
//  FolderTableViewController.swift
//  Translate:Drawable
//
//  Created by Jacques Castonguay on 2/21/18.
//  Copyright © 2018 JaxLab. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class FolderTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var fetchResultController: NSFetchedResultsController<WordMO>!
    var timesRightGoal = 3
    
    var vocabularyArray:[WordMO] = []
//        Word(englishWord: "To know", spanishWord: "Saber", englishHint: Hint(), spanishHint: Hint(phrase: "cuando se tiene una respuesta", imageName: "cap")),
//        Word(englishWord: "To Speak", spanishWord: "hablar", englishHint: Hint(phrase: "synonym: decir", imageName: "<man speaking photo>"), spanishHint: Hint(phrase:"usando su voz"))
//        ]
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logout(sender: UIButton) {
        do {
            try Auth.auth().signOut()
        } catch {
            let alertController = UIAlertController(title: "Logout Error", message: error.localizedDescription, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okayAction)
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        //Present the welcome view
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeView") {
            UIApplication.shared.keyWindow?.rootViewController = viewController
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Download images from Firebase
//        let postDatabaseRef = Database.database().reference().child("cards")
//        postDatabaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
//
//            print("Total number of posts: \(snapshot.childrenCount)")
//            for item in snapshot.children.allObjects as! [DataSnapshot] {
//                let postInfo = item.value as? [String: Any] ?? [:]
//
//                print("------")
//                print("Post ID: \(item.key)")
//                print("Image URL: \(postInfo["imageHintForEngFileURL"] ?? "")")
//                print("user: \(postInfo["user"] ?? "")")
//            }
//
//        })
        //get recent cards from firebase
        getRecentCards(limit: 3) { (newCards) in
            
            newCards.forEach({ (card) in
                print("----------")
                print("Post ID: \(card.postId)")
                print("Image URL: \(card.imageHintForEngFileURL)")
                print("User: \(card.user)")
                print("English Word: \(card.englishWord)")
                print("Spanish Word: \(card.spanishWord)")
                })
            
        }

        //Fetch request to get objs we want to see ples sortDescriptor on how we want to sort them (englishWord for now, will want something like "visibleWord" eventually when we can flip starting face up side)
        let fetchRequest: NSFetchRequest<WordMO> = WordMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "englishWord", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    vocabularyArray = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return vocabularyArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FolderTableViewCell

        // Configure the cell...
        cell.folderName.text = vocabularyArray[indexPath.row].englishWord
        cell.timesRight.text = String(vocabularyArray[indexPath.row].timesRight) + "/" + String(timesRightGoal)

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            //Delete from DB
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                let wordToDelete = self.fetchResultController.object(at: indexPath)
                context.delete(wordToDelete)
                appDelegate.saveContext()
            }
            completionHandler(true)
        }
        //Add sharing, editing, more
        
        deleteAction.backgroundColor = UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeConfiguration
    }
    
    
    //Next couple funcs let us see our word after we've added it
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    
    //When content has changed this is called
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        //CRUD stuff
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let IndexPath = indexPath {
                tableView.deleteRows(at: [IndexPath], with: .fade)
            }
        case .update:
            if let IndexPath = indexPath {
                tableView.reloadRows(at: [IndexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects {
            vocabularyArray = fetchedObjects as! [WordMO]
        }
    }
    
    
    //animate changes
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    //Pull posts from Firebase
    func getRecentCards(start timestamp: Int? = nil, limit: UInt, completionHandler: @escaping([Card]) -> Void) {
        var cardQuery = PostService.shared.POST_DB_REF.queryOrdered(byChild: Card.PostInfoKey.timestamp)
        if let latestPostTimestamp = timestamp, latestPostTimestamp > 0 {
            //If the timestamp is specified, we will get the posts with timestamps newer than the given value.
            cardQuery = cardQuery.queryStarting(atValue: latestPostTimestamp + 1, childKey: Card.PostInfoKey.timestamp).queryLimited(toLast: limit)
        } else {
            //Otherwise, we will just get the most recent posts
            cardQuery = cardQuery.queryLimited(toLast: limit)
        }
        
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
                newCards.sort(by: {$0.timestamp > $1.timestamp})
                //ADD newCards TO LOCAL DB (USE COMMENTED OUT CODE IN NEWWORDCONTROLLER TO TURN IT INTO A CARD)
                //This is local data way
                //Top line is getting AppDelegate object
                for card in newCards {
                    //Download Image
                    
                    
                    
                    var word: WordMO!
                    if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                        word = WordMO(context: appDelegate.persistentContainer.viewContext)
                        word.englishWord = card.englishWord
                        word.englishTextHint = card.englishTextHint
                        word.spanishWord = card.spanishWord
                        word.spanishTextHint = card.spanishTextHint
                        word.timesRight = 0
                        
//                        if let img = imageHintForSpanishWord.image {
//                            //This lets us get the data in the form of PNG
//                            if img != UIImage(named: "photo"){
//                                word.englishImageHint = UIImagePNGRepresentation(img)
//                            }
//
//                        }
                        
//                        if let img = imageHintForEnglishWord.image {
//                            if img != UIImage(named: "photo"){
//                                word.spanishImageHint = UIImagePNGRepresentation(img)
//                            }
//                        }
                        appDelegate.saveContext()
                    }
                }

            }
            
            completionHandler(newCards)
        })
        
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showVocabCard"{
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! VocabCardViewController
                
                destinationController.vocabWord = vocabularyArray[indexPath.row]
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
