//
//  MDSimpleNoteTests.swift
//  MDSimpleNoteTests
//
//  Created by MDLE on 2019-04-07.
//  Copyright © 2019 dcre8tive. All rights reserved.
//

import XCTest
@testable import MDSimpleNote

/*
 This is basic setup for mocking test with protocols
 There are 2 types of mocks which are Full or Partial
 */

class DataServiceMock {
    var testNotes = [MDNote]()
    var someExtraTestValueHereIfWeWant: String?
}

extension DataServiceMock: APIDataService {
    func fetchData(predicate: NSPredicate?, completion: @escaping (([MDNote]?, NSError?) -> Void)) {
        
    }
    
    func saveData(with: String, completion: @escaping (MDNote?, NSError?) -> Void) {
    
    }
    
    func cleanup() {
        testNotes.removeAll()
    }
    
    func setupAddDummyNote() {

    }
}


class MDSimpleNoteTests: XCTestCase {

    let dataService = DataServiceMock()
    
    override func setUp() {
        super.setUp()
        dataService.setupAddDummyNote()
    }

    override func tearDown() {
        super.tearDown()
        dataService.cleanup()
    }

    func testGetAllNotes() {
        let exp = self.expectation(description:"Test fetch all notes")
        dataService.fetchData(predicate: nil) { (notes, error) in
            //do some validation here using XCTAssert, XCTFail
            exp.fulfill()
        }
        self.waitForExpectations(timeout: 1, handler: nil)
    }

    func testAddNote() {
        let exp = self.expectation(description:"Test add one note")
        dataService.saveData(with: "test") { (note, error) in
            //do some validation here using XCTAssert, XCTFail
            exp.fulfill()
        }
        self.waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testSearchNote(){
        let keyword = "Hello"
        let predicate = NSPredicate(format: "text contains[c] %@", keyword)
        let exp = self.expectation(description:"Test search note from dummy note list")
        dataService.fetchData(predicate: predicate) { (notes, error) in
            //do some validation here using XCTAssert, XCTFail
            exp.fulfill()
        }
        self.waitForExpectations(timeout: 1, handler: nil)
    }
    
}
