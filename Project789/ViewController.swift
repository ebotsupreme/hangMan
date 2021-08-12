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
    var usedLettersView: UIView!
    
    var usedLetters = [String]()
    var allWords = [String]()
    var allLetters = [UILabel]()
    
    let alphabets = "abcdefghijklmnopqrstuvwxyz"
    var currentWord = ""
    var promptWord = ""
    
    var wrongAnswers = 0
    var score = 0 {
        didSet {
            scoresLabel.text = "Score: \(score)"
        }
    }
    var chance = 7 {
        didSet {
            chancesLabel.text = "Chance(s): \(chance)"
        }
    }
    
    var rowCount: ClosedRange<Int> = 0...5
    var colCount: ClosedRange<Int> = 0...4

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async { [weak self] in
            if let filepathURL = Bundle.main.url(forResource: "wordList", withExtension: "txt") {
                if let wordContents = try? String(contentsOf: filepathURL) {
                    self?.allWords = wordContents.components(separatedBy: "\n")
                }
            }
        }
        
        view = UIView()
        view.backgroundColor = .white
        
        chancesLabel = UILabel()
        chancesLabel.translatesAutoresizingMaskIntoConstraints = false
        chancesLabel.text = "Chance(s): 7"
        chancesLabel.textAlignment = .right
        chancesLabel.font = UIFont.systemFont(ofSize: 20)
        
        scoresLabel = UILabel()
        scoresLabel.translatesAutoresizingMaskIntoConstraints = false
        scoresLabel.text = "Score: 0"
        scoresLabel.font = UIFont.systemFont(ofSize: 20)
        scoresLabel.textAlignment = .right
        
        currentWordLabel = UILabel()
        currentWordLabel.translatesAutoresizingMaskIntoConstraints = false
        currentWordLabel.sizeToFit()
        currentWordLabel.text = "????????"
        currentWordLabel.font = UIFont.systemFont(ofSize: 46)
        currentWordLabel.textAlignment = .center
        currentWordLabel.numberOfLines = 0
        currentWordLabel.backgroundColor = .green
        
        answersLabel = UITextField()
        answersLabel.delegate = self
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.placeholder = "Enter Letter"
        answersLabel.returnKeyType = .done
        answersLabel.font = UIFont.systemFont(ofSize: 30)
        answersLabel.textAlignment = .center
        answersLabel.backgroundColor = .red
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        
        usedLettersView = UIView()
        usedLettersView.translatesAutoresizingMaskIntoConstraints = false
        usedLettersView.layer.borderWidth = 1
        usedLettersView.layer.borderColor = UIColor.gray.cgColor
        usedLettersView.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        usedLettersView.backgroundColor = .cyan
        
        let topHalfContainerView = UIView()
        topHalfContainerView.translatesAutoresizingMaskIntoConstraints = false
        topHalfContainerView.backgroundColor = .blue
        view.addSubview(topHalfContainerView)
        
        let bottomHalfContainerView = UIView()
        bottomHalfContainerView.translatesAutoresizingMaskIntoConstraints = false
        bottomHalfContainerView.backgroundColor = .gray
        view.addSubview(bottomHalfContainerView)
        
        topHalfContainerView.addSubview(chancesLabel)
        topHalfContainerView.addSubview(scoresLabel)
        topHalfContainerView.addSubview(currentWordLabel)
        topHalfContainerView.addSubview(answersLabel)
        topHalfContainerView.addSubview(submit)
        topHalfContainerView.addSubview(clear)
        bottomHalfContainerView.addSubview(usedLettersView)
        
        NSLayoutConstraint.activate([
            topHalfContainerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            topHalfContainerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            topHalfContainerView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            topHalfContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            bottomHalfContainerView.topAnchor.constraint(equalTo: topHalfContainerView.bottomAnchor),
            bottomHalfContainerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            bottomHalfContainerView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            bottomHalfContainerView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            
            chancesLabel.topAnchor.constraint(equalTo: topHalfContainerView.topAnchor),
            chancesLabel.trailingAnchor.constraint(equalTo: topHalfContainerView.trailingAnchor, constant: -100),
            
            scoresLabel.topAnchor.constraint(equalTo: topHalfContainerView.topAnchor),
            scoresLabel.trailingAnchor.constraint(equalTo: topHalfContainerView.trailingAnchor),
            
            currentWordLabel.topAnchor.constraint(equalTo: scoresLabel.bottomAnchor, constant: 20),
            currentWordLabel.leadingAnchor.constraint(equalTo: topHalfContainerView.leadingAnchor),
            currentWordLabel.trailingAnchor.constraint(equalTo: topHalfContainerView.trailingAnchor),
            currentWordLabel.centerXAnchor.constraint(equalTo: topHalfContainerView.centerXAnchor),
            currentWordLabel.heightAnchor.constraint(equalTo: topHalfContainerView.heightAnchor, multiplier: 0.3),
            
            answersLabel.topAnchor.constraint(equalTo: currentWordLabel.bottomAnchor, constant: 20),
            answersLabel.widthAnchor.constraint(equalTo: topHalfContainerView.widthAnchor, multiplier: 0.6),
            answersLabel.centerXAnchor.constraint(equalTo: topHalfContainerView.centerXAnchor),
            answersLabel.heightAnchor.constraint(equalTo: topHalfContainerView.heightAnchor, multiplier: 0.2),
            
            submit.topAnchor.constraint(equalTo: answersLabel.bottomAnchor, constant: 10),
            submit.centerXAnchor.constraint(equalTo: topHalfContainerView.centerXAnchor, constant: -60),
            submit.heightAnchor.constraint(equalTo: topHalfContainerView.heightAnchor, multiplier: 0.1),
            
            clear.topAnchor.constraint(equalTo: answersLabel.bottomAnchor, constant: 10),
            clear.centerXAnchor.constraint(equalTo: topHalfContainerView.centerXAnchor, constant: 60),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalTo: topHalfContainerView.heightAnchor, multiplier: 0.1),
            
            usedLettersView.topAnchor.constraint(equalTo: bottomHalfContainerView.topAnchor, constant: 10),
            usedLettersView.leadingAnchor.constraint(equalTo: bottomHalfContainerView.leadingAnchor),
            usedLettersView.trailingAnchor.constraint(equalTo: bottomHalfContainerView.trailingAnchor),
            usedLettersView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usedLettersView.bottomAnchor.constraint(equalTo: bottomHalfContainerView.bottomAnchor)
            
        ])

        determinMyDeviceOrientation()

        loadWord()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
    }
 
    func determinMyDeviceOrientation(_ transition: Bool = false) {
        
        if transition {
            if UIDevice.current.orientation.isLandscape  {
                print("Device is in landscape mode")
                rowCount = 0...2
                colCount = 0...9
            } else {
                print("Device is in portrait mode")
                rowCount = 0...5
                colCount = 0...4
            }
        } else {
            if UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height {
                print("Device is in landscape mode")
                rowCount = 0...2
                colCount = 0...9
            } else {
                print("Device is in portrait mode")
                rowCount = 0...5
                colCount = 0...4
            }
        }
       
        createUsedLettersGrid(rowCount, colCount)
        setLettersForUsedLettersView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let transition = true
        determinMyDeviceOrientation(transition)
    }
    
    func createUsedLettersGrid(_ rowCount: ClosedRange<Int>, _ colCount: ClosedRange<Int>) {
        let width = 65
        let height = 40
        
        // empty usedLettersView & allLetters
        usedLettersView.subviews.forEach({ $0.removeFromSuperview() })
        allLetters = []
        
        // grid for used letters
        for row in rowCount {
            for column in colCount {
                if row == 5 && column >= 1 || row == 2 && column >= 6 { continue }
                let letter = UILabel()
                letter.font = UIFont.systemFont(ofSize: 24)
                letter.sizeToFit()
                letter.textAlignment = .center
                letter.text = "A"
                letter.backgroundColor = .yellow
                let frame = CGRect(x: column * width, y: height * row, width: width, height: height)
                letter.frame = frame
                usedLettersView.addSubview(letter)
                allLetters.append(letter)
            }
        }
    }
    
    func shuffleWords () {
        allWords.shuffle()
        currentWord = allWords[0]
        print("Current word: \(currentWord)")
    }
    
    @objc func submitTapped(sender: UIButton) {
        submit()
    }
    
    func submit() {
        guard let submittedLetter = answersLabel.text?.lowercased() else { return }
        print("Submitted Letter: \(submittedLetter)", "typeOf: \(type(of: submittedLetter))")
        
        if submittedLetter == "" { return }
        if usedLetters.contains(submittedLetter) {
            answersLabel.text = ""
            return
        }
        
        usedLetters.append(submittedLetter)
        print("usedLetters: \(usedLetters)")
        
        displayUsedLetters(submittedLetter)
        
        if currentWord.contains(submittedLetter) {
            score += 1
            displayWord()
        } else {
            chance -= 1
            score -= 1
        }
        
        answersLabel.text = ""
        
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
        answersLabel.text = ""
    }

    func loadWord() {
        shuffleWords()
        usedLetters = []
        chance = 77777
        score = 0
        displayWord()
        determinMyDeviceOrientation()
    }
    
    func setLettersForUsedLettersView() {
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
        answersLabel.resignFirstResponder()
        
        var status: String
        var message: String
        
        if youWin {
            print("GAME OVER! YOU WIN")
            status  = "Win"
            message = "Good Game!"
        } else {
            print("GAME OVER! YOU LOSE")
            status = "Lose"
            message = "You ran out of chances."
        }
        
        let ac = UIAlertController(title: "You \(status)!", message: "\(message) Your score: \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: { [weak self] action in
            self?.loadWord()
        }))
        present(ac, animated: true)
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

