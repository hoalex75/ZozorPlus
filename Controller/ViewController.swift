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
        
        createUpdateNotifications()
        createAlertsNotifications()
    }

    // MARK: - Outlets

    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!

    // MARK: - Actions

    @IBAction func tappedNumberButton(_ sender: UIButton) {
        for (i, numberButton) in numberButtons.enumerated() {
            if sender == numberButton {
                model.addNewNumber(i)
            }
        }
    }

    @IBAction func multiply(_ sender: Any) {
        model.multiply()
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


    // MARK: - Selectors

    @objc func startANewCalculationAlert() {
        createAndDisplayAlerts(message: "Démarrez un nouveau calcul !")
    }
    
    @objc func enterACorrectExpressionAlert(_ sender : UIViewController) {
        createAndDisplayAlerts(message: "Entrer une expression correcte !")
    }
    
    @objc func incorrectExpression(_ sender : UIViewController) {
        createAndDisplayAlerts(message: "Expression incorrecte !")
    }
    
    @objc func updateTextViewForTotal(_ notification : NSNotification) {
        if let data = notification.userInfo as NSDictionary? {
            if let total = data["total"] as? Int{
                textView.text = textView.text + "=\(total)"
            }
        }
    }

    @objc func updateDisplay(_ notification : NSNotification) {
        if let data = notification.userInfo as NSDictionary? {
            if let text = data["text"] as? String{
                textView.text = text
            }
        }
    }
    
    //Mark: -Methods
    
    // Create and addObservers on Notifications which concern the display
    fileprivate func createUpdateNotifications(){
        let nameUpdateDisplay = Notification.Name("UpdateDisplay")
        let nameUpdateTotal = Notification.Name("UpdateTotal")
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateDisplay(_ :)), name: nameUpdateDisplay, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextViewForTotal(_:)), name: nameUpdateTotal, object: nil)
    }
    
    // Create and addObservers on Notifications which concern the alerts
    fileprivate func createAlertsNotifications() {
        let nameStartANewCalculation = Notification.Name("StartANewCalculation")
        let nameEnterACorrectExpression = Notification.Name("EnterACorrectExpression")
        let nameIncorrectExpression = Notification.Name("IncorrectExpression")
        
        NotificationCenter.default.addObserver(self, selector: #selector(startANewCalculationAlert), name: nameStartANewCalculation, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enterACorrectExpressionAlert), name: nameEnterACorrectExpression, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(incorrectExpression), name: nameIncorrectExpression, object: nil)
    }
    
    // Create and display an alert to the user with the message given in parameters
    fileprivate func createAndDisplayAlerts(message : String) {
        let alertVC = UIAlertController(title: "Zéro!", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
