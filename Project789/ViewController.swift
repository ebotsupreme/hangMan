//
//  ViewController.swift
//  Project789
//
//  Created by Eddie Jung on 8/10/21.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    var currentWordLabel: UILabel!
    var answersLabel: UITextField!
    var scoresLabel: UILabel!
    
    var usedLetters = [String]()
    var allWords = [String]()
    
    var currentWord = ""
    
    var wrongAnswers = 0
    var score = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let filepathURL = Bundle.main.url(forResource: "wordList", withExtension: "txt") {
            if let wordContents = try? String(contentsOf: filepathURL) {
                allWords = wordContents.components(separatedBy: "\n")
            }
        }
        allWords.shuffle()
        currentWord = allWords[0]
        print(currentWord)
//        title = "Current word: \(currentWord). Score: \(score)"
        
        view = UIView()
        view.backgroundColor = .white
        
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
        
    }
    
    @objc func submitTapped(sender: UIButton) {
        guard let submittedLetter = answersLabel.text else { return }
        print(submittedLetter)
    }
    
    @objc func clearTapped(sender: UIButton) {
        
    }

    func loadWord() {
        
    }
    
    // set textField to 1 letter max
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = answersLabel.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 1
    }

}

