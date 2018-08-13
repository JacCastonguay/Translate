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
    var randomIndex: [Int]!
    var visibleWord:SingleLang = SingleLang(word: "")
    var OtherWord:SingleLang = SingleLang(word: "", textHint: "")
    var isShuffle: Bool!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        randomIndex = []
        for i in 0...(wordArray.count-1) {
            randomIndex.append(i)
        }
        
        //randomIndex = randomIndex.shuffled()
        print(randomIndex)
        //Ads, not working right now
        //let request = GADRequest()
        //request.testDevices = [kGADSimulatorID, "3285462873ff73f1ce0b9c8e6c3a580a704ec628"]
        //adBanner.adUnitID = "ca-app-pub-1650577861408675/7964305103"
        //adBanner.rootViewController = self
        //adBanner.load(request)
        
        //If shuffleButton got us here
        if isShuffle == false {
        wordView.shuffleButton.setTitleColor(UIColor(displayP3Red: 0, green: 122/255, blue: 1, alpha: 1.0), for: .normal)
            print("shuffle is off now")
            index = randomIndex[index]
            randomIndex.sort()
        } else {
            wordView.shuffleButton.setTitleColor(.blue, for: .normal)
            print("shuffle is on now")
            randomIndex = randomIndex.shuffled()
        }
        
        //set visible word & otherWord
        SetEnglishVisible()
    }
    
    fileprivate func SetEnglishVisible() {
        visibleWord = SingleLang(word: vocabWord.englishWord!, textHint: vocabWord.englishTextHint, imageHint: vocabWord.englishImageHint)
        OtherWord = SingleLang(word: vocabWord.spanishWord!, textHint: vocabWord.spanishTextHint, imageHint: vocabWord.spanishImageHint)
        //Set views&button
        UpdateViews()
    }
    
    //Reacts to any button being pressed (besides the top bar's back button)
    @IBAction func DidTapSwapButton(_ sender: Any) {
        //Switch card size
        swap(&visibleWord, &OtherWord)
        UpdateViews()
    }
    
    @IBAction func DidTapUseHints(_ sender: Any) {
        wordView.hintLabel?.alpha = 1
        wordView.hintImage?.alpha = 1
    }
    
    @IBAction func DidTapTimesRight(_ sender: Any){
        if vocabWord.timesRight < 3{
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
                vocabWord.timesRight += 1
                appDelegate.saveContext()
            }
        }
    }
    
    @IBAction func DidTapNext(_ sender: Any){
        if(index < (wordArray.count - 1)){
            //Increase everything as normal
            index = index + 1
        }else{
            index = 0
        }
        vocabWord = wordArray[randomIndex[index]]
        SetEnglishVisible()
        //make a counter that once hits the length of the list brings user back to folder or "Notes completed" screen
    }
    
    @IBAction func DidTapLast(_ sender: Any){
        if(index > 0){
            //Increase everything as normal
            index = index - 1
        }else{
            index = wordArray.count - 1
        }
        vocabWord = wordArray[index]
        SetEnglishVisible()
        //make a counter that once hits the length of the list brings user back to folder or "Notes completed" screen
    }
    
    @IBAction func ToggleShuffle(_ sender: Any){
        if isShuffle == true {
            isShuffle = false
            //default color
            wordView.shuffleButton.setTitleColor(UIColor(displayP3Red: 0, green: 122/255, blue: 1, alpha: 1.0), for: .normal)
            print("shuffle is off now")
            index = randomIndex[index]
            randomIndex.sort()
        } else {
            isShuffle = true
            wordView.shuffleButton.setTitleColor(.blue, for: .normal)
            print("shuffle is on now")
            randomIndex = randomIndex.shuffled()

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
