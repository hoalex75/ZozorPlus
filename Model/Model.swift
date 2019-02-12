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
    
    //Evaluate if the expression entered is valid for calculateTotal if not send a notification to Controller
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
    
    // Evaluate if the last add was an operator if it is then send a notification to Controller
    fileprivate var canAddOperator: Bool {
        if let stringNumber = stringNumbers.last {
            if stringNumber.isEmpty {
                postman.createAndPostNotifications("IncorrectExpression")
                
                return false
            }
        }
        return true
    }
    
    // Concatenate the new number with the last one in stringNumbers if exists
    func addNewNumber(_ newNumber: Int) {
        if let stringNumber = stringNumbers.last {
            var stringNumberMutable = stringNumber
            stringNumberMutable += "\(newNumber)"
            stringNumbers[stringNumbers.count-1] = stringNumberMutable
        }
        postman.createAndPostNotificationsWithText("UpdateDisplay", updateTextView())
    }
    
    // Get the current total and send it to the controller with a notification
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
    
    // Calculate the current Total and return it
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
    
    // Add the operator passed in parameters and add a new String to stringNumbers then notify the controller
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
    
    // Concatenate stringNumbers and operators into only one String and return it
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
    
    // Return the index of the first multiply operator in operators, if not return -1
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
    
    // Replace operators by the same array with no first multiply left
    func reduceOperators(_ firstMultiplyPosition : Int) {
        var newOperators = ["+"]
        if operators.count > 2 {
            if firstMultiplyPosition > 1{
                for i in 1...firstMultiplyPosition-1 {
                    newOperators.append(operators[i])
                }
            }
            if operators.count-1 > firstMultiplyPosition {
                for j in firstMultiplyPosition+1...operators.count-1 {
                    newOperators.append(operators[j])
                }
            }
        }
        operators = newOperators
    }
    
    // replace the two first numbers which should be multiply by the result of their multiplication
    func reduceStringNumbers(_ firstMultiplyPosition : Int){
        var newStringNumbers : [String]
        var resultOfMultiplication = 0
        if let numberOne = Int(stringNumbers[firstMultiplyPosition-1]), let numberTwo = Int(stringNumbers[firstMultiplyPosition]) {
            resultOfMultiplication = numberOne * numberTwo
        }
        if firstMultiplyPosition == 1 {
            newStringNumbers = ["\(resultOfMultiplication)"]
            if stringNumbers.count-2 >= 1{
                for i in 1...stringNumbers.count-2 {
                    newStringNumbers.append(stringNumbers[i+1])
                }
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
    
    // Call the two functions of reduction until there i no multiply left
    func conformingMultiplicationToPlusAndMinus() {
        while whereIsTheFirstMultiply() != -1 {
            let firstMultiply = whereIsTheFirstMultiply()
            reduceStringNumbers(firstMultiply)
            reduceOperators(firstMultiply)
        }
    }
}
