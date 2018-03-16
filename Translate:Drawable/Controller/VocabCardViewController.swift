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
    
    var vocabWord: Word = Word(englishWord:"", spanishWord:"", englishHint:Hint(), spanishHint:Hint())
    var visibleWord:SingleLang = SingleLang(word: "")
    var OtherWord:SingleLang = SingleLang(word: "")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //set visible word & otherWord
        visibleWord = SingleLang(word: vocabWord.englishWord, hint: vocabWord.englishHint)
        OtherWord = SingleLang(word: vocabWord.spanishWord, hint: vocabWord.spanishHint)
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
        if let visibleImageName = visibleWord.hint?.imageName {
            wordView.hintImage.image = UIImage(named: visibleImageName)
        } else {
            wordView.hintImage.image = nil
        }
        wordView.hintImage?.alpha = 0
        if let phrase = visibleWord.hint?.phrase {
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
        var hint:Hint?
        
        init(word: String, hint:Hint? = nil){
            self.word = word
            self.hint = hint
        }
        
        
    }
}
