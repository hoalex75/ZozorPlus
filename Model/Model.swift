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
    fileprivate let postman = NotificationsPostman()
    
    fileprivate var isExpressionCorrect: Bool {
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
    
    fileprivate var canAddOperator: Bool {
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
        let total = whatIsTheCurrentTotal()
        postman.createAndPostNotificationsWithInt("UpdateTotal", total)
        clear()
    }
    
    func plus() {
        addOperator("+")
    }
    
    func minus() {
        addOperator("-")
    }
    
    func multiply() {
        addOperator("X")
    }
    
    func whatIsTheCurrentTotal() -> Int {
        conformingMultiplicationToPlusAndMinus()
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
        return total
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
    
    func whereIsTheFirstMultiply() -> Int {
        var position = -1
        for (i,operatorsSign) in operators.enumerated() {
            if operatorsSign == "X" {
                position = i
                break
            }
        }
        return position
    }
    
    func reduceOperators(_ firstMultiplyPosition : Int) {
        var newOperators = ["+"]
        for i in 1...firstMultiplyPosition-1 {
            newOperators.append(operators[i])
        }
        if operators.count-1 > firstMultiplyPosition {
            for j in firstMultiplyPosition+1...operators.count-1 {
                newOperators.append(operators[j])
            }
        }
        operators = newOperators
    }
    
    func reduceStringNumbers(_ firstMultiplyPosition : Int){
        var newStringNumbers : [String]
        var resultOfMultiplication = 0
        if let numberOne = Int(stringNumbers[firstMultiplyPosition-1]), let numberTwo = Int(stringNumbers[firstMultiplyPosition]) {
            resultOfMultiplication = numberOne * numberTwo
        }
        if firstMultiplyPosition == 1 {
            newStringNumbers = ["\(resultOfMultiplication)"]
            for i in 1...stringNumbers.count-2 {
                newStringNumbers.append(stringNumbers[i+1])
            }
        } else {
            newStringNumbers = [stringNumbers[0]]
            if firstMultiplyPosition-2 >= 1 {
                for i in 1...firstMultiplyPosition-2 {
                    newStringNumbers.append(stringNumbers[i])
                }
            }
            newStringNumbers.append("\(resultOfMultiplication)") //firstMultiplyPosition -1
            if stringNumbers.count-1>firstMultiplyPosition {
                for j in firstMultiplyPosition...stringNumbers.count-2 {
                    newStringNumbers.append(stringNumbers[j+1])
                }
            }
        }
        stringNumbers = newStringNumbers
    }
    
    func conformingMultiplicationToPlusAndMinus() {
        while whereIsTheFirstMultiply() != -1 {
            let firstMultiply = whereIsTheFirstMultiply()
            reduceStringNumbers(firstMultiply)
            reduceOperators(firstMultiply)
        }
    }
}
