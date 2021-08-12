//
//  ViewController.swift
//  Project789
//
//  Created by Eddie Jung on 8/10/21.
//

import UIKit

class ViewController: UIViewController {
    var currentWordLabel: UILabel!
    var answersLabel: UITextField!
    var scoresLabel: UILabel!
    var chancesLabel: UILabel!
    
    var usedLetters = [String]()
    var allWords = [String]()
    var allLetters = [UILabel]()
    
    let alphabets = "abcdefghijklmnopqrstuvwxyz"
    var currentWord = ""
    var promptWord = ""
    
    var wrongAnswers = 0
    var score = 0
    var chance = 2 {
        didSet {
            chancesLabel.text = "Chance(s): \(chance)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let filepathURL = Bundle.main.url(forResource: "wordList", withExtension: "txt") {
            if let wordContents = try? String(contentsOf: filepathURL) {
                allWords = wordContents.components(separatedBy: "\n")
            }
        }
        allWords.shuffle()
        currentWord = allWords[0]
        print("Current word: \(currentWord)")
        
        view = UIView()
        view.backgroundColor = .white
        
        chancesLabel = UILabel()
        chancesLabel.translatesAutoresizingMaskIntoConstraints = false
        chancesLabel.text = "Chance: 7"
        chancesLabel.textAlignment = .right
        chancesLabel.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(chancesLabel)
        
        scoresLabel = UILabel()
        scoresLabel.translatesAutoresizingMaskIntoConstraints = false
        scoresLabel.text = "Score: 0"
        scoresLabel.font = UIFont.systemFont(ofSize: 20)
        scoresLabel.textAlignment = .right
        view.addSubview(scoresLabel)
        
        currentWordLabel = UILabel()
        currentWordLabel.translatesAutoresizingMaskIntoConstraints = false
        currentWordLabel.text = "????????"
        currentWordLabel.font = UIFont.systemFont(ofSize: 48)
        currentWordLabel.textAlignment = .center
        currentWordLabel.numberOfLines = 0
        currentWordLabel.backgroundColor = .green
        view.addSubview(currentWordLabel)
        
        answersLabel = UITextField()
        answersLabel.delegate = self
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.placeholder = "Enter Letter"
        answersLabel.returnKeyType = .done
        answersLabel.font = UIFont.systemFont(ofSize: 30)
        answersLabel.textAlignment = .center
        answersLabel.backgroundColor = .red
        view.addSubview(answersLabel)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)
        
        let usedLettersView = UIView()
        usedLettersView.translatesAutoresizingMaskIntoConstraints = false
        usedLettersView.layer.borderWidth = 1
        usedLettersView.layer.borderColor = UIColor.gray.cgColor
        usedLettersView.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        usedLettersView.backgroundColor = .cyan
        view.addSubview(usedLettersView)
        
        NSLayoutConstraint.activate([
            chancesLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            chancesLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            
            scoresLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoresLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            currentWordLabel.topAnchor.constraint(equalTo: scoresLabel.bottomAnchor, constant: 20),
            currentWordLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 15),
            currentWordLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -15),
            currentWordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentWordLabel.heightAnchor.constraint(equalToConstant: 100),
            
            answersLabel.topAnchor.constraint(equalTo: currentWordLabel.bottomAnchor, constant: 20),
            answersLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            answersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            answersLabel.heightAnchor.constraint(equalToConstant: 70),
            
            submit.topAnchor.constraint(equalTo: answersLabel.bottomAnchor, constant: 20),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -60),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 60),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            usedLettersView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            usedLettersView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 15),
            usedLettersView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -15),
            usedLettersView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usedLettersView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
            
        ])
        
        let width = 63
        let height = 40
//        let alphabets = "abcdefghijklmnopqrstuvwxyz"
        
        // grid for used letters
        for row in 0...5 {
            for column in 0...4 {
                if row == 5 && column >= 1 { continue }
                let letter = UILabel()
                letter.font = UIFont.systemFont(ofSize: 26)
                letter.textAlignment = .center
                letter.text = "A"
                letter.backgroundColor = .yellow
                let frame = CGRect(x: column * width, y: height * row, width: width, height: height)
                letter.frame = frame
                usedLettersView.addSubview(letter)
                allLetters.append(letter)
            }
        }

        loadWord()
    }
    
    @objc func submitTapped(sender: UIButton) {
        submit()
    }
    
    func submit() {
        guard let submittedLetter = answersLabel.text?.lowercased() else { return }
        print("Submitted Letter: \(submittedLetter)", "typeOf: \(type(of: submittedLetter))")
        usedLetters.append(submittedLetter)
        print("usedLetters: \(usedLetters)")
        
        displayUsedLetters(submittedLetter)
        
        if currentWord.contains(submittedLetter) {
            displayWord()
        } else {
            chance -= 1
        }
        
        answersLabel.text = ""
        
        // add game over alert if chance == 0
        if chance == 0 {
            let youWin = false
            gameOver(youWin)
        }
    }
    
    func displayUsedLetters(_ letter: String) {
        for i in 0...25 {
            if allLetters[i].text == letter.uppercased() {
                allLetters[i].isHidden = false
            }
            
        }
    }
    
    @objc func clearTapped(sender: UIButton) {
        
    }

    func loadWord() {
        // load new word
        
        // wipe out usedLetters
        
        // restart score and chances
        
        // display word
        displayWord()
        
        // set used letters
        for (index, alphabet) in alphabets.enumerated() {
            if allLetters.count == alphabets.count {
                allLetters[index].text = String(alphabet).uppercased()
            }
            allLetters[index].isHidden = true
        }
 
    }
    
    func displayWord() {
        for letter in currentWord {
            let strLetter = String(letter)
            if usedLetters.contains(strLetter) {
                promptWord += strLetter
            } else {
                promptWord += "?"
            }
        }
        
        print("PromptWord: \(promptWord)")
        currentWordLabel.text = promptWord.uppercased()
        
        if promptWord == currentWord {
            let youWin = true
            gameOver(youWin)
        }
        
        promptWord = ""
        
    }
    
    func gameOver(_ youWin: Bool) {
        if youWin {
            print("GAME OVER! YOU WIN")
            // add alert to restart
        } else {
            print("GAME OVER! YOU LOSE")
        }
        
    }

}

extension ViewController: UITextFieldDelegate {
    // set textField to 1 letter max
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = answersLabel.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        submit()
        // dismiss keyboard
        textField.resignFirstResponder()
        return true
    }
    
}

/* TODO tomorrow
1. x work on the used words container
 a. x create nested forloop to display letters used
 b. x hide and unhide letters.
2. add alerts for winning and losing.
3. add restart functionality
4. add score functionality
5. add clear button funcionality
6. update ui for landscape
7. add GCD
 
 */

