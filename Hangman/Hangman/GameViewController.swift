//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var wordToBeGuessed: UILabel!
    
    @IBOutlet weak var correctButton: UIButton!
    
    @IBOutlet weak var incorrectButton: UIButton!
    
    @IBOutlet weak var hangmanStateImage: UIImageView!
    
    @IBOutlet weak var incorrectGuesses: UILabel!
    
    @IBOutlet weak var letterGuessed: UITextField!
    
    var globalPhrase:String = ""
    var unfilledBlanks: String = ""
    var incorrectGuessesString: String = ""
    var numberOfIncorrectGuesses: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let hangmanPhrases = HangmanPhrases()
        var phraseToGuess = hangmanPhrases.getRandomPhrase()
        globalPhrase = phraseToGuess
        print(phraseToGuess)
        
        let x = phraseToGuess.characters.count
        for index in 0...x-1 {
            let characterOfGuessWord = phraseToGuess[phraseToGuess.startIndex.advancedBy(index)]
            if characterOfGuessWord != " " {
                unfilledBlanks += "-"
            } else {
                unfilledBlanks += " "
            }
        }
        wordToBeGuessed.text = unfilledBlanks
        hangmanStateImage.image = UIImage(named: "hangman1.gif")
        playGame()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playGame() {
        
                correctButton.addTarget(self, action: "guessedCorrectly:", forControlEvents: .TouchUpInside)
                incorrectButton.addTarget(self, action: "guessedIncorrectly:", forControlEvents: .TouchUpInside)
    }
    
    func guessedCorrectly(sender:UIButton!) {
        let x = unfilledBlanks.characters.count
        for index in 0...x-1 {
            let characterOfGuessWord = unfilledBlanks[unfilledBlanks.startIndex.advancedBy(index)]
            if characterOfGuessWord == "-" {
                let aRange = Range<String.Index>(start: unfilledBlanks.startIndex.advancedBy(index), end: unfilledBlanks.startIndex.advancedBy(index+1))
                print(globalPhrase[globalPhrase.startIndex.advancedBy(index)])
                
                unfilledBlanks = unfilledBlanks.stringByReplacingCharactersInRange(aRange, withString: String(globalPhrase[globalPhrase.startIndex.advancedBy(index)]))
                
                print(unfilledBlanks)
                wordToBeGuessed.text = unfilledBlanks
                break
            }
        }
    }
    
    func guessedIncorrectly(sender:UIButton!) {
        
        if letterGuessed.text != "" && letterGuessed.text?.characters.count == 1 {
            numberOfIncorrectGuesses += 1
            hangmanStateImage.image = UIImage(named: "hangman" + String(numberOfIncorrectGuesses + 1) + ".gif")
            incorrectGuesses.text = incorrectGuesses.text! + " " + letterGuessed.text!
        }
        
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
