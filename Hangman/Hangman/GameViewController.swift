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
    
    @IBOutlet weak var guessButton: UIButton!
    
    @IBOutlet weak var hangmanStateImage: UIImageView!
    
    @IBOutlet weak var incorrectGuesses: UILabel!
    
    @IBOutlet weak var letterGuessed: UITextField!
    
    var globalPhrase:String = ""
    var unfilledBlanks: String = ""
    var incorrectGuessesString: String = ""
    var numberOfIncorrectGuesses: Int = 0
    var allGuesses = Set<Character>()
    
    @IBAction func resetGame(sender: AnyObject) {
        globalPhrase = ""
        unfilledBlanks = ""
        incorrectGuessesString = ""
        numberOfIncorrectGuesses = 0
        allGuesses = Set<Character>()
        guessButton.enabled = true
        letterGuessed.enabled = true
        incorrectGuesses.text = ""
        
        initializeGame()
    }
    func initializeGame() {
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
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeGame()
        playGame()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playGame() {
        
        guessButton.addTarget(self, action: "makeAGuess:", forControlEvents: .TouchUpInside)
    }
    
    func validateLetterGuessed(character: String) -> Bool {
        
        if character == "" || (character.characters.count) != 1 {
            return false;
        }
        
        let guessedLetter = character.uppercaseString
        let unicodeValueOfCharacter = Int(guessedLetter.unicodeScalars[guessedLetter.unicodeScalars.startIndex].value)
        
        if (unicodeValueOfCharacter > 90 || unicodeValueOfCharacter < 65) {
            let alert = UIAlertController(title: "Incorrect Input", message: "Only Alphabets are allowed!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "I'll Be Careful Next Time", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return false;
        }
        
        if allGuesses.contains(Character(guessedLetter)) {
            let alert = UIAlertController(title: "Incorrect Input", message: "You have already guessed this letter! Try another one.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "I'll Be Careful Next Time", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return false;
        }
        
        return true;
    }
    
    func makeAGuess(sender:UIButton!) {
        
        var guessedCorrectly = false;
        if let text = letterGuessed.text where !text.isEmpty && (validateLetterGuessed(text)) {
            let guessedCharacter = Character(text.uppercaseString)
            allGuesses.insert(guessedCharacter)
            let numberOfCharacters = unfilledBlanks.characters.count
            for index in 0...numberOfCharacters-1 {
                let characterOfHiddenPhrase = globalPhrase[globalPhrase.startIndex.advancedBy(index)]
                if characterOfHiddenPhrase == guessedCharacter {
                    guessedCorrectly = true
                    let aRange = Range<String.Index>(start: unfilledBlanks.startIndex.advancedBy(index), end: unfilledBlanks.startIndex.advancedBy(index+1))
                    unfilledBlanks = unfilledBlanks.stringByReplacingCharactersInRange(aRange, withString: String(characterOfHiddenPhrase))
                    
                }
            }
            
            wordToBeGuessed.text = unfilledBlanks
            if (!guessedCorrectly) {
                guessedIncorrectly(guessedCharacter)
            } else {
                if checkForWin() {
                    let alert = UIAlertController(title: "Congratulations, you won!", message: "You have won the impossible game of Hangman.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "I had soooo much fun!", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    guessButton.enabled = false
                    letterGuessed.enabled = false
                    
                }
            }
            guessedCorrectly = false
            letterGuessed.text = ""
        }
        
        else {
            letterGuessed.text = ""
        }
    }
    
    func checkForWin() -> Bool {
        let numberOfCharacters = unfilledBlanks.characters.count
        for index in 0...numberOfCharacters-1 {
            let characterOfHiddenPhrase = unfilledBlanks[unfilledBlanks.startIndex.advancedBy(index)]
            if characterOfHiddenPhrase == "-" {
                return false
            }
        }
        return true
    }
    
    func guessedIncorrectly(guessedCharacter:Character) {
        numberOfIncorrectGuesses += 1
        hangmanStateImage.image = UIImage(named: "hangman" + String(numberOfIncorrectGuesses + 1) + ".gif")
        incorrectGuesses.text = incorrectGuesses.text! + " " + String(guessedCharacter)
        if numberOfIncorrectGuesses == 6 {
            let alert = UIAlertController(title: "You Lost :(", message: "You have run out of moves", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Gotta practice my words.", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            guessButton.enabled = false
            letterGuessed.enabled = false
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
