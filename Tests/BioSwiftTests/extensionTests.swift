//
//  extensionTests.swift
//  BioSwift
//
//  Created by Þorvaldur Rúnarsson on 25/09/2017.
//

import XCTest
@testable import BioSwift

class extensionTest: XCTestCase {
    let stringToTest = "'The' is the most common word in the english language."
    
    func testIteration() {
        let coll1 = [ 1, 2, 3]
        let coll2 = [ 4, 5, 6]
        let exp1 = expectation(description: "1")
        let exp2 = expectation(description: "1")
        let exp3 = expectation(description: "1")
        coll1.iterate(with: coll2) { (int1, int2) in
            if int1 == 1 {
                exp1.fulfill()
                XCTAssert(int2 == 4)
            } else if int1 == 2 {
                exp2.fulfill()
                XCTAssert(int2 == 5)
            } else {
                exp3.fulfill()
                XCTAssert(int2 == 6)
            }
        }
        waitForExpectations(timeout: 1)
    }
}
