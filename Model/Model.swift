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
    
    var isExpressionCorrect: Bool {
        if let stringNumber = stringNumbers.last {
            if stringNumber.isEmpty {
                if stringNumbers.count == 1 {
                    createAndPostNotifications("StartANewCalculation")
                } else {
                    createAndPostNotifications("EnterACorrectExpression")
                }
                return false
            }
        }
        return true
    }
    
    var canAddOperator: Bool {
        if let stringNumber = stringNumbers.last {
            if stringNumber.isEmpty {
                createAndPostNotifications("IncorrectExpression")
                
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
        createAndPostNotifications("UpdateDisplay")
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
        
        
        let totalToSend: [String : Int] = ["total" : total]
        let name = Notification.Name("UpdateTotal")
        NotificationCenter.default.post(name: name, object: nil, userInfo: totalToSend)
        
        
        
        clear()
    }
    
    func plus() {
        if canAddOperator {
            operators.append("+")
            stringNumbers.append("")
            createAndPostNotifications("UpdateDisplay")
        }
    }
    
    func minus() {
        if canAddOperator {
            operators.append("-")
            stringNumbers.append("")
            createAndPostNotifications("UpdateDisplay")
        }
    }
    
    
    
    fileprivate func createAndPostNotifications(_ NotificationName: String) {
        let name = Notification.Name(NotificationName)
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)
    }
    
    fileprivate func clear() {
        stringNumbers = [String()]
        operators = ["+"]
    }
}
