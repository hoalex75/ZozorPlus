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
    
        operatorSign == "+" ? model.plus() : model.minus()
    
        XCTAssertEqual(countStringNumbers+1, model.stringNumbers.count)
        XCTAssertEqual(countOperators+1, model.operators.count)
        XCTAssertEqual(model.operators.last!, operatorSign == "+" ? "+" : "-")
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGivenNoNumbersInStringNumber_WhenAddTheNumberTwo_ThenStringNumberIsTWo() {
        model.addNewNumber(2)
        
        XCTAssertEqual(model.stringNumbers, ["2"])
    }
    
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
    
    func testGivenThreePlusTwo_WhenWhatIsTheCurrentTotal_ThenTotalIsFive() {
        model.addNewNumber(3)
        model.plus()
        model.addNewNumber(2)
        
        let total = model.whatIsTheCurrentTotal()
        
        XCTAssertEqual(total, 5)
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
}
