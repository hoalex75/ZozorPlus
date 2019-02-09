//
//  ModelTest.swift
//  CountOnMeTests
//
//  Created by Alex on 08/02/2019.
//  Copyright © 2019 Ambroise Collon. All rights reserved.
//

import XCTest
@testable import CountOnMe

class ModelTest: XCTestCase {
    var model: Model!
    let nameUpdateDisplay = Notification.Name("UpdateDisplay")
    
    override func setUp() {
        super.setUp()
        model = Model()
    }
    
    fileprivate func newOperatorTest(_ operatorSign : String) {
        model.addNewNumber(2)
        let countStringNumbers = model.stringNumbers.count
        let countOperators = model.operators.count
        expectation(forNotification: nameUpdateDisplay, object: nil, handler: nil)
    
        switch operatorSign {
        case "+":
            model.plus()
        case "X":
            model.multiply()
        default:
            model.minus()
        }
    
        XCTAssertEqual(countStringNumbers+1, model.stringNumbers.count)
        XCTAssertEqual(countOperators+1, model.operators.count)
        XCTAssertEqual(model.operators.last!, operatorSign)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // MARK: -Add a new number tests
    func testGivenNoNumbersInStringNumber_WhenAddTheNumberTwo_ThenStringNumberIsTWo() {
        model.addNewNumber(2)
        
        XCTAssertEqual(model.stringNumbers, ["2"])
    }
    
    // MARK: -Operators tests
    func testGivenCantAddANewOperator_WhenAddingANewOperator_ThenIncorrectExpressionIsSent() {
        model.addNewNumber(2)
        model.plus()
        expectation(forNotification: Notification.Name("IncorrectExpression"), object: nil, handler: nil)
        
        model.plus()
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGivenCanAddANewPlus_WhenAddingANewOperator_ThenOperatorsCountsOneMoreAndStringNumbersToo() {
        newOperatorTest("+")
    }
    
    func testGivenCanAddANewMinus_WhenAddingANewOperator_ThenOperatorsCountsOneMoreAndStringNumbersToo() {
        newOperatorTest("-")
    }
    
    func testGivenCanAddANewMultiply_WhenAddingANewOperator_ThenOperatorsCountsOneMoreAndStringNumbersToo() {
        newOperatorTest("X")
    }

    // MARK: -Total tests
    func testGivenThreePlusTwo_WhenWhatIsTheCurrentTotal_ThenTotalIsFive() {
        model.addNewNumber(3)
        model.plus()
        model.addNewNumber(2)
        
        let total = model.whatIsTheCurrentTotal()
        
        XCTAssertEqual(total, 5)
    }
    
    func testGivenTwoPlusThreeMuliplyByTwo_WhenWhatIsTheCurrentTotal_ThenTotalIsSix() {
        model.addNewNumber(2)
        model.plus()
        model.addNewNumber(3)
        model.multiply()
        model.addNewNumber(2)
        
        let total = model.whatIsTheCurrentTotal()
        
        XCTAssertEqual(total, 8)
    }
    
    func testGivenThreeMinusTwo_WhenCalculateTotal_ThenUpdateTotalIsSent() {
        model.addNewNumber(3)
        model.minus()
        model.addNewNumber(2)
        expectation(forNotification: Notification.Name("UpdateTotal"), object: nil, handler: nil)
        
        model.calculateTotal()
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGivenStringNumbersHasOnlyOneVoidString_WhenCalculateTotal_ThenStartANewCalculationIsSent() {
        expectation(forNotification: Notification.Name("StartANewCalculation"),object: nil,handler: nil)
        
        model.calculateTotal()
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGivenStringNumbersHasTwoAndOneVoidString_WhenCalculateTotal_ThenEnterACorrectExpressionIsSent() {
        model.addNewNumber(2)
        model.plus()
        expectation(forNotification: Notification.Name("EnterACorrectExpression"),object: nil,handler: nil)
        
        model.calculateTotal()
        
    
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGivenTwoPlusThreeMultiplyByFourMultiplyByFive_WhenWhereIsTheFirstMultiply_ThenIsInIndexThree() {
        model.addNewNumber(2)
        model.plus()
        model.addNewNumber(3)
        model.multiply()
        model.addNewNumber(4)
        model.multiply()
        model.addNewNumber(5)
        
        XCTAssertEqual(model.whereIsTheFirstMultiply(),2)
    }
    
    func testGivenOperatorsIsPlusPlusMultiplyMultiply_WhenReduceOperators_ThenOperatorsIsPlusPlusMultiply() {
        model.addNewNumber(2)
        model.plus()
        model.addNewNumber(3)
        model.multiply()
        model.addNewNumber(4)
        model.multiply()
        model.addNewNumber(5)
        let operatorsBeforeReduction = model.operators
        
        model.reduceOperators(model.whereIsTheFirstMultiply())
        let operatorsAfterOneReduction = model.operators
        model.reduceOperators(model.whereIsTheFirstMultiply())
        
        XCTAssertEqual(operatorsBeforeReduction, ["+","+","X","X"])
        XCTAssertEqual(operatorsAfterOneReduction, ["+","+","X"])
        XCTAssertEqual(model.operators, ["+","+"])
    }
    
    func testGivenTwoMultiplyByThreePlusFour_WhenReduceStringNumbers_ThenStringNumbersIsSixAndFour() {
        model.addNewNumber(2)
        model.multiply()
        model.addNewNumber(3)
        model.plus()
        model.addNewNumber(4)
        let stringNumbersBeforeReduce = model.stringNumbers
        
        model.reduceStringNumbers(model.whereIsTheFirstMultiply())
        
        XCTAssertEqual(stringNumbersBeforeReduce, ["2","3","4"])
        XCTAssertEqual(model.stringNumbers, ["6","4"])
    }
    
    func testGivenTwoPlusThreeMultiplyByFourPlusFive_WhenReduceStringNumbers_ThenStringNumbersIsSixAndFour() {
        model.addNewNumber(2)
        model.plus()
        model.addNewNumber(3)
        model.plus()
        model.addNewNumber(4)
        model.plus()
        model.addNewNumber(5)
        model.multiply()
        model.addNewNumber(6)
        let stringNumbersBeforeReduce = model.stringNumbers
        
        model.reduceStringNumbers(model.whereIsTheFirstMultiply())
        
        XCTAssertEqual(stringNumbersBeforeReduce, ["2","3","4","5","6"])
        XCTAssertEqual(model.stringNumbers, ["2","3","4","30"])
    }
    
    func testGivenTwoPlusThreeMultiplyByFourPlusFive_WhenConformingMultiplyToPlusAndMinus_ThenStringNumbersAndOperatorsAreStandards() {
        model.addNewNumber(2)
        model.plus()
        model.addNewNumber(3)
        model.multiply()
        model.addNewNumber(4)
        model.multiply()
        model.addNewNumber(5)
        let stringNumbersBeforeReduce = model.stringNumbers
        let operatorsBeforeReduce = model.operators
        
        model.conformingMultiplicationToPlusAndMinus()
        
        XCTAssertEqual(stringNumbersBeforeReduce, ["2","3","4","5"])
        XCTAssertEqual(model.stringNumbers, ["2","60"])
        XCTAssertEqual(operatorsBeforeReduce, ["+","+","X","X"])
        XCTAssertEqual(model.operators, ["+","+"])
    }
}
