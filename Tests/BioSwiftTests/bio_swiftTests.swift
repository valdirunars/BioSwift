//
//  bio_swiftTests.swift
//  BioSwift
//
//  Created by Þorvaldur Rúnarsson on 25/09/2017.
//

import XCTest
@testable import BioSwift

class bio_swiftTests: XCTestCase {
    let stringToTest = "AGCTGCTTTGGCGCAATGATCGAGCTGCTTTGGCGCAATGATCGAGCTGCTTTGGCGCAATGATCGAGCTGCTTTGGCGCAATGATCG"
    func testNucleotide() {
        
        let nucs: [(Nucleotide, Character, Character)] = [
            (.a, "A", "T"),
            (.c, "C", "G"),
            (.g, "G", "C"),
            (.t, "T", "A")
        ]
        
        for nuc in nucs {
            let nucleotide = nuc.0
            let raw = nuc.1
            let complementRaw = nuc.2

            XCTAssert(raw == nucleotide.charValue)
            let complement = !nucleotide
            XCTAssert(complementRaw == complement.charValue)
        }
    }

    func testReverseCompliment() {
        let reverseComplement = "CGATCATTGCGCCAAAGCAGCTCGATCATTGCGCCAAAGCAGCTCGATCATTGCGCCAAAGCAGCTCGATCATTGCGCCAAAGCAGCT"
        let genome = Genome(sequence: self.stringToTest)

        measure {
            var rev = genome
            rev.reverseComplement()
            XCTAssert(reverseComplement == rev.description)
            rev.reverseComplement()
            XCTAssert(rev == genome)
        }
    }
    
    func testMostFrequentPattern() {
        measure {
            let mostFreq = Genome(sequence: self.stringToTest).mostFrequentPattern(length: 2)
            XCTAssert(mostFreq == Genome(sequence: "GC"))
        }
    }
    
    func testIndicesForPattern() {
        let genome = Genome(sequence: "CGCCCGAATCCAGAACGCATTCCCATATTTCGGGACCACTGGCCTCCACGGTACGGACGTCAATCAAATGCCTAGCGGCTTGTGGTTTCTCCTACGCTCC")
        measure {
            let subgenome = Genome(sequence: "ATTCTGGA")
            let indices = genome.indices(for: subgenome, maxDistance: 3)
            
            let exp = [ 6, 7, 26, 27, 78 ]
            
            let expected = exp.map {
                genome.index(genome.startIndex, offsetBy: $0)
            }
            
            XCTAssert(indices == expected)
        }
    }
    
    func testMinimalSkew() {
        let minimal = Genome(sequence: self.stringToTest).indicesOfMinimalSkew(increment: .a, decrement: .t)
        let exp = [
            74,
            75,
            76,
            77,
            78,
            79
        ]
        XCTAssert(minimal == exp)
    }

    static var allTests = [
        ("testNucleotide", testNucleotide),
        ("testGenome", testReverseCompliment),
        ("testMinimalSkew", testMinimalSkew)
    ]
}
