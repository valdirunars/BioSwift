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
    
    func testRemoveWhiteSpace() {
        var string = " \t   asdf   "
        XCTAssert(string.stringByRemovingWhitespaceInFront() == "asdf   ")
        string = "asdf   "
        XCTAssert(string.stringByRemovingWhitespaceInFront() == "asdf   ")
    }
}
