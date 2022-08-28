//
//  ViewController.swift
//  SwiftyWords
//
//  Created by newbie on 22.08.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private let scoreLabel = UILabel()
    private let answersLabel = UILabel()
    private var currentAnswer = UITextField()
    private let cluesLabel = UILabel()
    private var letterButtons = [UIButton]()
    
    private var score: Double = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    private var level = 1
    private var correctAnswers = 0
    
    private var solutions = [String]()
    private var activatedButtons = [UIButton]()
    
//    private var cluesString = ""
//    private var answersString = ""
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white

        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "Score: 0"
        scoreLabel.textAlignment = .right
        view.addSubview(scoreLabel)
        
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.text = "HINTS"
        cluesLabel.font = .systemFont(ofSize: 24)
        cluesLabel.numberOfLines = 0
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.text = "ANSWERS"
        answersLabel.font = .systemFont(ofSize: 24)
        answersLabel.numberOfLines = 0
        answersLabel.textAlignment = .right
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.textAlignment = .center
        currentAnswer.placeholder = "Pick the letters"
        currentAnswer.font = .systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.setTitle("SUBMIT", for: .normal)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearButtonPressed), for: .touchUpInside)
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        // Static width and height of each button in grid
        let width = 150
        let height = 80
        
        for row in 0...3 {
            for col in 0...4 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = .systemFont(ofSize: 36)
                
                letterButton.setTitle("XXX", for: .normal)
                
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                letterButton.addTarget(self, action: #selector(letterButtonPressed), for: .touchUpInside)
                letterButton.layer.borderColor = UIColor.lightGray.cgColor
                letterButton.layer.borderWidth = 1
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor, constant: 20),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.heightAnchor.constraint(equalToConstant: 44),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLevel()
    }

    @objc private func submitButtonPressed(_ sender: UIButton) {
        guard let answer = currentAnswer.text else { return }
        if let position = solutions.firstIndex(of: answer) {
            guard let hints = answersLabel.text else { return }
            var hintsArray = hints.components(separatedBy: "\n")
            hintsArray[position] = answer
            answersLabel.text = hintsArray.joined(separator: "\n")
            currentAnswer.text = ""
            
            score += 1
            correctAnswers += 1
            
            if correctAnswers % 7 == 0 {
                let ac = UIAlertController(title: "Are you ready to the next level?", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's do it!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
            activatedButtons.removeAll()
        } else {
            clearButtonPressed(sender)
            score -= 0.5
            let ac = UIAlertController(title: "You are wrong", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc private func clearButtonPressed(_ sender: UIButton) {
        currentAnswer.text = ""
        for button in activatedButtons {
            button.isHidden = false
        }
    }
    
    @objc private func letterButtonPressed(_ sender: UIButton) {
        currentAnswer.text! += sender.titleLabel!.text!
        activatedButtons.append(sender)
        sender.isHidden = true
    }
    
    private func loadLevel() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            var bits = [String]()
            var cluesString = ""
            var answersString = ""
            
            if let url = Bundle.main.url(forResource: "level\((self?.level)!)", withExtension: "txt") {
                if let levelContent = try? String(contentsOf: url) {
                    let lines = levelContent.components(separatedBy: "\n")
                    for (index, line) in lines.enumerated() {
                        let parts = line.components(separatedBy: ": ")
                        let clue = parts[1]
                        let answer = parts[0]
                        cluesString += "\(index+1). \(clue).\n"
                        let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                        answersString += "\(solutionWord.count) letters\n"
                        self?.solutions.append(solutionWord)
                        
                        bits.append(contentsOf: answer.components(separatedBy: "|"))
                    }
                }
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.cluesLabel.text = cluesString.trimmingCharacters(in: .whitespacesAndNewlines)
                self?.answersLabel.text = answersString.trimmingCharacters(in: .whitespacesAndNewlines)
                
                bits.shuffle()
                
                if bits.count == self?.letterButtons.count {
                    for index in 0..<(self?.letterButtons.count)! {
                        self?.letterButtons[index].setTitle(bits[index], for: .normal)
                    }
                }
            }
        }
    }
    
    private func levelUp(action: UIAlertAction) {
        level += 1
        score = 0
        
        solutions.removeAll()
        loadLevel()
        
        for button in letterButtons {
            button.isHidden = false
        }
    }

}

