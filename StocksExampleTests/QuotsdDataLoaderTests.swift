//
//  QuotsdDataLoaderTests.swift
//  StocksExampleTests
//
//  Created by Boaz Frenkel on 19/01/2020.
//  Copyright © 2020 boaz. All rights reserved.
//

import XCTest
@testable import StocksExample

class QuotsdDataLoaderTests: XCTestCase {
    
    var sut: QuotesDataLoader!
    var quotesAPIServiceMock = QuotesAPIServiceMock()
    
    override func setUp() {
        sut = QuotesDataLoader()
        sut.quotesAPIService = quotesAPIServiceMock
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testReturnsErrorWhenError() {
        quotesAPIServiceMock.shouldSucceed = false
        XCTAssertEqual(quotesAPIServiceMock.getQuotesCalls, 0)
        
        // Create an expectation
        let expectation = self.expectation(description: "Call Api")
        
        sut.getQuotesSortedByDate(for: "BAC", interval: "1min", onSuccess: { (quotes) in
            XCTFail("should return error but returned success")
        }) { (error) in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 0.3, handler: nil)
        XCTAssertEqual(self.quotesAPIServiceMock.getQuotesCalls, 1)
    }
    
    func testReturnsStocks() {
        quotesAPIServiceMock.shouldSucceed = true
        XCTAssertEqual(quotesAPIServiceMock.getQuotesCalls, 0)
        
        let expectation = self.expectation(description: "Call Api")
        
        sut.getQuotesSortedByDate(for: "BAC", interval: "1min", onSuccess: { (quotes) in
            XCTAssertNotNil(quotes)
            expectation.fulfill()
        }) { (error) in
            XCTFail("should return error but returned success")
            
        }
        waitForExpectations(timeout: 0.3, handler: nil)
        XCTAssertEqual(self.quotesAPIServiceMock.getQuotesCalls, 1)
    }
    
}

class QuotesAPIServiceMock : QuotesAPI {
    var getQuotesCalls = 0
    var shouldSucceed = true
    
    //We should build a json file and create Quotes from it
    let mocQuotesArray = [
        Quote(date: "2020-01-17 15:58:00", open: "50.1500", high: "49.2000", low: "49.1500", close: "49.1700", volume: "748348"),
        Quote(date: "2020-01-17 16:00:00", open: "49.1500", high: "49.2000", low: "49.1500", close: "49.1700", volume: "748348"),
        Quote(date: "2020-01-17 15:59:00", open: "48.1500", high: "49.2000", low: "49.1500", close: "49.1700", volume: "748348")
    ]
    
    func getQuotes(for symbol: String, interval: String, onSuccess: @escaping ([Quote]) -> (), onError: @escaping (Error) -> Void) {
        getQuotesCalls += 1
        if shouldSucceed == true {
            onSuccess(mocQuotesArray)
            return
        } else {
            onError(AlphaVantageQuotesAPIService.AlphaVantageQuoteError.errorOnApiCall(message: "rturned mock erro"))
            return
        }
    }
    
    //test returns sorted array
    
}
