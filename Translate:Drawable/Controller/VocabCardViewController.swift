//
//  VocabCardViewController.swift
//  Translate:Drawable
//
//  Created by Jacques Castonguay on 2/27/18.
//  Copyright © 2018 JaxLab. All rights reserved.
//

import UIKit

class VocabCardViewController: UIViewController {

    @IBOutlet var wordView:VocabCardView!
    
    var vocabWord: WordMO! // = WordMO(englishWord:"", spanishWord:"", englishTextHint: "", englishImageHint: nil, spanishTextHint: "", spanishImageHint: nil)
    var visibleWord:SingleLang = SingleLang(word: "")
    var OtherWord:SingleLang = SingleLang(word: "", textHint: "")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //set visible word & otherWord
        visibleWord = SingleLang(word: vocabWord.englishWord!, textHint: vocabWord.englishTextHint, imageHint: vocabWord.englishImageHint)
        OtherWord = SingleLang(word: vocabWord.spanishWord!, textHint: vocabWord.spanishTextHint, imageHint: vocabWord.spanishImageHint)
        //Set views&button
        UpdateViews()

    }
    
    
    @IBAction func didTapLoad(_ sender: Any) {
        let buttonPressed = sender as? UIButton
        switch buttonPressed?.tag {
        case 1?:
            swap(&visibleWord, &OtherWord)
            UpdateViews()
        case 2?:
            wordView.hintLabel?.alpha = 1
            wordView.hintImage?.alpha = 1
        default:
            return
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        if (segue.identifier == "PopUp") {
//            //set destination
//            let destinationController = segue.destination as! HintImagePopUpController
//            //
//            if (wordView.wordButton.currentTitle == vocabWord.englishWord) {
//                if let imageName = vocabWord.englishHint.imageName{
//                    destinationController.hintText = imageName
//                }
//            } else {
//                if let imageName = vocabWord.spanishHint.imageName{
//                    destinationController.hintText = imageName
//                }
//
//            }
//        }
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
