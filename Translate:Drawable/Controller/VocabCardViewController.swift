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
    
    @IBAction func didTapLoad(_ sender: Any) {
        
        let buttonPressed = sender as? UIButton
        
        switch buttonPressed?.tag {
        case 1?:
            if (wordView.wordButton.currentTitle == vocabWord.englishWord)
            {
                wordView.wordButton.setTitle(vocabWord.spanishWord, for: .normal)
            }
            else {
                wordView.wordButton.setTitle(vocabWord.englishWord, for: .normal)
            }
            
        case 2?:
            if (wordView.wordButton.currentTitle == vocabWord.englishWord) {
                if let phrase = vocabWord.englishHint.phrase {
                    wordView.hintLabel?.text = phrase
                }
            }
            else {
                if let phrase = vocabWord.spanishHint.phrase {
                    wordView.hintLabel?.text = phrase
                }
            }
            
        default:
            return
        }

        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordView.wordButton.setTitle(vocabWord.englishWord, for: .normal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "PopUp") {
            
            //set destination
            let destinationController = segue.destination as! HintImagePopUpController
            //
            if (wordView.wordButton.currentTitle == vocabWord.englishWord) {
                if let imageName = vocabWord.englishHint.imageName{
                    destinationController.hintText = imageName
                }
            } else {
                if let imageName = vocabWord.spanishHint.imageName{
                    destinationController.hintText = imageName
                }
                
            }
        }
        
    }
    

}
