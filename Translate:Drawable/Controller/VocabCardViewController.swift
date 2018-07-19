//
//  VocabCardViewController.swift
//  Translate:Drawable
//
//  Created by Jacques Castonguay on 2/27/18.
//  Copyright © 2018 JaxLab. All rights reserved.
//

import UIKit
//import GoogleMobileAds

class VocabCardViewController: UIViewController {

    //@IBOutlet weak var adBanner: GADBannerView!
    
//    lazy var adBannerView: GADBannerView = {
//        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
//        adBannerView.adUnitID = "ca-app-pub-1650577861408675/7964305103"
//        adBannerView.delegate = self
//        adBannerView.rootViewController = self
//        return adBannerView
//    }()
    
    @IBOutlet var wordView:VocabCardView!
    
    var vocabWord: WordMO! // = WordMO(englishWord:"", spanishWord:"", englishTextHint: "", englishImageHint: nil, spanishTextHint: "", spanishImageHint: nil)
    var wordArray: [WordMO]!
    var index: Int!
    var visibleWord:SingleLang = SingleLang(word: "")
    var OtherWord:SingleLang = SingleLang(word: "", textHint: "")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //Ads, not working right now
        //let request = GADRequest()
        //request.testDevices = [kGADSimulatorID, "3285462873ff73f1ce0b9c8e6c3a580a704ec628"]
        //adBanner.adUnitID = "ca-app-pub-1650577861408675/7964305103"
        //adBanner.rootViewController = self
        //adBanner.load(request)
        
        //set visible word & otherWord
        visibleWord = SingleLang(word: vocabWord.englishWord!, textHint: vocabWord.englishTextHint, imageHint: vocabWord.englishImageHint)
        OtherWord = SingleLang(word: vocabWord.spanishWord!, textHint: vocabWord.spanishTextHint, imageHint: vocabWord.spanishImageHint)
        //Set views&button
        UpdateViews()

    }
    
    //Reacts to any button being pressed (besides the top bar's back button)
    @IBAction func didTapLoad(_ sender: Any) {
        let buttonPressed = sender as? UIButton
        switch buttonPressed?.tag {
        case 1?:
            //Switch card size
            swap(&visibleWord, &OtherWord)
            UpdateViews()
        case 2?:
            //Use Hint / Make hint visible
            wordView.hintLabel?.alpha = 1
            wordView.hintImage?.alpha = 1
        case 3?:
            //Increase correct count
            if vocabWord.timesRight < 3{
                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
                    vocabWord.timesRight += 1
                    appDelegate.saveContext()
                }
            }
        case 4?:
            //Next button
            if(index < (wordArray.count - 1)){
                //Increase everything as normal
                index = index + 1
            }else{
                index = 0
            }
            vocabWord = wordArray[index]
            visibleWord = SingleLang(word: vocabWord.englishWord!, textHint: vocabWord.englishTextHint, imageHint: vocabWord.englishImageHint)
            OtherWord = SingleLang(word: vocabWord.spanishWord!, textHint: vocabWord.spanishTextHint, imageHint: vocabWord.spanishImageHint)
            UpdateViews()
            //make a counter that once hits the length of the list brings user back to folder or "Notes completed" screen
        case 5?:
            //Last button
            if(index > 0){
                //Increase everything as normal
                index = index - 1
            }else{
                index = wordArray.count - 1
            }
            vocabWord = wordArray[index]
            visibleWord = SingleLang(word: vocabWord.englishWord!, textHint: vocabWord.englishTextHint, imageHint: vocabWord.englishImageHint)
            OtherWord = SingleLang(word: vocabWord.spanishWord!, textHint: vocabWord.spanishTextHint, imageHint: vocabWord.spanishImageHint)
            UpdateViews()
            //make a counter that once hits the length of the list brings user back to folder or "Notes completed" screen
            
            
        default:
            print("Default (nothing) was selected")
            return
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//    }
    
    func UpdateViews ()-> Void {
        //Set views&button
        wordView.wordButton.setTitle(visibleWord.word, for: .normal)
        //NOTE: when switching to MOs UIImage will need to be found by data not named
        if let visibleImage = visibleWord.imageHint {
            wordView.hintImage.image = UIImage(data: visibleImage as Data)
        } else {
            wordView.hintImage.image = nil
        }
        wordView.hintImage?.alpha = 0
        if let phrase = visibleWord.textHint {
            wordView.hintLabel!.text = phrase
        } else {
            wordView.hintLabel!.text = ""
        }
        wordView.hintLabel?.alpha = 0
        
        if (wordView.hintImage.image == nil && (wordView.hintLabel!.text == (""))) {
            wordView.useHintsbutton.setTitleColor(.lightGray, for: .normal)
        } else {
            wordView.useHintsbutton.setTitleColor(.blue, for: .normal)
        }
    }
    
    class SingleLang {
        var word:String
        var textHint:String?
        var imageHint:Data?
        
        init(word: String, textHint:String? = "", imageHint:Data? = nil){
            self.word = word
            self.textHint = textHint
            self.imageHint = imageHint
        }
        
        
    }
}

//extension VocabCardViewController: GADBannerViewDelegate {
//
//    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
//        print("banner loaded successfully")
//        //create a view in storyboard then set it here instead of tableview
//        //maybe just delete this and look at YT tut
//        //tableView.tableHeaderView?.frame = bannerView.frame
//        //tableView.tableHeaderView = bannerView
//        }
//
//    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
//        print("Failed to receive ads")
//        print(error)
//    }
//}
