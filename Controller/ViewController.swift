//
//  ViewController.swift
//  CountOnMe
//
//  Created by Ambroise COLLON on 30/08/2016.
//  Copyright © 2016 Ambroise Collon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Properties
    
    
    var model: Model!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        model = Model()
        
        let nameStartANewCalculation = Notification.Name("StartANewCalculation")
        let nameEnterACorrectExpression = Notification.Name("EnterACorrectExpression")
        let nameIncorrectExpression = Notification.Name("IncorrectExpression")
        let nameUpdateDisplay = Notification.Name("UpdateDisplay")
        let nameUpdateTotal = Notification.Name("UpdateTotal")
        
        NotificationCenter.default.addObserver(self, selector: #selector(startANewCalculationAlert), name: nameStartANewCalculation, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enterACorrectExpressionAlert), name: nameEnterACorrectExpression, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(incorrectExpression), name: nameIncorrectExpression, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateDisplay), name: nameUpdateDisplay, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextViewForTotal(_:)), name: nameUpdateTotal, object: nil)
    }

    // MARK: - Outlets

    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!

    // MARK: - Action

    @IBAction func tappedNumberButton(_ sender: UIButton) {
        for (i, numberButton) in numberButtons.enumerated() {
            if sender == numberButton {
                model.addNewNumber(i)
            }
        }
    }

    @IBAction func plus() {
        model.plus()
    }

    @IBAction func minus() {
        model.minus()
    }

    @IBAction func equal() {
        model.calculateTotal()
    }


    // MARK: - Methods

    @objc func startANewCalculationAlert() {
        let alertVC = UIAlertController(title: "Zéro!", message: "Démarrez un nouveau calcul !", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @objc func enterACorrectExpressionAlert() {
        let alertVC = UIAlertController(title: "Zéro!", message: "Entrez une expression correcte !", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @objc func incorrectExpression() {
        let alertVC = UIAlertController(title: "Zéro!", message: "Expression incorrecte !", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @objc func updateTextViewForTotal(_ notification : NSNotification) {
        if let data = notification.userInfo as NSDictionary? {
            if let total = data["total"] as? Int{
                textView.text = textView.text + "=\(total)"
            }
        }
    }


    @objc func updateDisplay() {
        var text = ""
        for (i, stringNumber) in model.stringNumbers.enumerated() {
            // Add operator
            if i > 0 {
                text += model.operators[i]
            }
            // Add number
            text += stringNumber
        }
        textView.text = text
    }

    
}
