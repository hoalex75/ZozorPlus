//
//  Model.swift
//  CountOnMe
//
//  Created by Alex on 08/02/2019.
//  Copyright © 2019 Ambroise Collon. All rights reserved.
//

import Foundation

public class Model {
    var stringNumbers: [String] = [String()]
    var operators: [String] = ["+"]
    let postman = NotificationsPostman()
    
    var isExpressionCorrect: Bool {
        if let stringNumber = stringNumbers.last {
            if stringNumber.isEmpty {
                if stringNumbers.count == 1 {
                    postman.createAndPostNotifications("StartANewCalculation")
                } else {
                    postman.createAndPostNotifications("EnterACorrectExpression")
                }
                return false
            }
        }
        return true
    }
    
    var canAddOperator: Bool {
        if let stringNumber = stringNumbers.last {
            if stringNumber.isEmpty {
                postman.createAndPostNotifications("IncorrectExpression")
                
                return false
            }
        }
        return true
    }
    
    
    func addNewNumber(_ newNumber: Int) {
        if let stringNumber = stringNumbers.last {
            var stringNumberMutable = stringNumber
            stringNumberMutable += "\(newNumber)"
            stringNumbers[stringNumbers.count-1] = stringNumberMutable
        }
        postman.createAndPostNotificationsWithText("UpdateDisplay", updateTextView())
    }
    
    func calculateTotal() {
        if !isExpressionCorrect {
            return
        }
        var total = 0
        for (i, stringNumber) in stringNumbers.enumerated() {
            if let number = Int(stringNumber) {
                if operators[i] == "+" {
                    total += number
                } else if operators[i] == "-" {
                    total -= number
                }
            }
        }
        postman.createAndPostNotificationsWithInt("UpdateTotal", total)
        clear()
    }
    
    func plus() {
        addOperator("+")
    }
    
    func minus() {
        addOperator("-")
    }
    
    fileprivate func addOperator(_ operatorSign: String){
        if canAddOperator {
            operators.append(operatorSign)
            stringNumbers.append("")
            postman.createAndPostNotificationsWithText("UpdateDisplay", updateTextView())
        }
    }
    
    fileprivate func clear() {
        stringNumbers = [String()]
        operators = ["+"]
    }
    
    fileprivate func updateTextView() -> String {
        var text = ""
        for (i, stringNumber) in stringNumbers.enumerated() {
            // Add operator
            if i > 0 {
                text += operators[i]
            }
            // Add number
            text += stringNumber
        }
        return text
    }
}
