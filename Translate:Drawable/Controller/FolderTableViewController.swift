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
//import GoogleMobileAds

class FolderTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
//    lazy var adBannerView: GADBannerView = {
//        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
//        adBannerView.adUnitID = "ca-app-pub-1650577861408675/7964305103"
//        adBannerView.delegate = self
//        adBannerView.rootViewController = self
//        return adBannerView
//    }()
    
    var fetchResultController: NSFetchedResultsController<WordMO>!
    var timesRightGoal = 3
    
    var searchController: UISearchController?
    var searchResults: [WordMO] = []
    
    var vocabularyArray:[WordMO] = []

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
        //Ads
        //let request = GADRequest()
        //request.testDevices = [kGADSimulatorID, "3285462873ff73f1ce0b9c8e6c3a580a704ec628"]
        //adBannerView.load(request)
        
        
        //Firebase commented out to focus on local changes
        //TESTING to see if I can add locally, without firebase
        //getRecentCards()
        searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        searchController!.searchResultsUpdater = self
        searchController!.dimsBackgroundDuringPresentation = false
        
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
        //Pull down to refresh
        //refreshControl = UIRefreshControl()
        //refreshControl?.addTarget(self, action: #selector(getRecentCards), for: UIControlEvents.valueChanged)
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
        if searchController!.isActive {
            return searchResults.count
        } else {
        return vocabularyArray.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FolderTableViewCell

        //determine if we use search or normal
        let vocabWord = (searchController!.isActive) ? searchResults[indexPath.row] : vocabularyArray[indexPath.row]
        
        // Configure the cell...
//        cell.folderName.text = vocabularyArray[indexPath.row].englishWord
//        cell.timesRight.text = String(vocabularyArray[indexPath.row].timesRight) + "/" + String(timesRightGoal)
        cell.folderName.text = vocabWord.englishWord
        cell.timesRight.text = String(vocabWord.timesRight) + "/" + String(timesRightGoal)

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
    @objc func getRecentCards() {
        PostService.shared.getRecentCards()
        self.refreshControl?.endRefreshing()
        //Use this when debugging to download all posts
        //TimeTracker.shared.WriteTime(newTime: String(0))
    }

    func filterContent(for searchText: String){
        searchResults = vocabularyArray.filter({ (vocabularyArrayItem) -> Bool in
            //change to chapter once created to search for vocab from chapters
            if let englishWord = vocabularyArrayItem.englishWord {
                let isMatch = englishWord.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }
            
            return false
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {    }
    */


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showVocabCard"{
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! VocabCardViewController
                
                destinationController.vocabWord = (searchController!.isActive) ? searchResults[indexPath.row] : vocabularyArray[indexPath.row]
            }
        }
    }
    

}

/*extension FolderTableViewController: GADBannerViewDelegate {

    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("banner loaded successfully")
        tableView.tableHeaderView?.frame = bannerView.frame
        tableView.tableHeaderView = bannerView
    }

    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Failed to receive ads")
        print(error)
    }
}*/
