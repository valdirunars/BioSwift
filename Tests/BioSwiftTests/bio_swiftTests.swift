//
//  bio_swiftTests.swift
//  BioSwift
//
//  Created by Þorvaldur Rúnarsson on 25/09/2017.
//

import XCTest
import BigInt
@testable import BioSwift

class bio_swiftTests: XCTestCase {

    let genomeToTest: DNAGenome = "AGCTGCTTTGGCGCAATGATCGAGCTGCTTTGGCGCAATGATCGAGCTGCTTTGGCGCAATGATCGAGCTGCTTTGGCGCAATGATCG"

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

    func testReverseComplement() {
        let reverseComplement = "CGATCATTGCGCCAAAGCAGCTCGATCATTGCGCCAAAGCAGCTCGATCATTGCGCCAAAGCAGCTCGATCATTGCGCCAAAGCAGCT"

        measure {
            var rev = self.genomeToTest
            rev.reverseComplement()
            XCTAssert(reverseComplement == rev.description)
            rev.reverseComplement()
            XCTAssert(rev == self.genomeToTest)
        }
    }
    
    func testMostFrequentPattern() {
        measure {
            let mostFreq = self.genomeToTest.mostFrequentPattern(length: 2)
            XCTAssert(mostFreq == DNAGenome(sequence: "GC"))
        }
    }
    
    func testIndicesForPattern() {
        let genome: DNAGenome = "CGCCCGAATCCAGAACGCATTCCCATATTTCGGGACCACTGGCCTCCACGGTACGGACGTCAATCAAATGCCTAGCGGCTTGTGGTTTCTCCTACGCTCC"
        measure {
            let subgenome: DNAGenome = "ATTCTGGA"
            let indices = genome.indices(for: subgenome, maxDistance: 3)
            
            let exp = [ 6, 7, 26, 27, 78 ]
            
            let expected = exp.map {
                genome.index(genome.startIndex, offsetBy: $0)
            }
            
            XCTAssert(indices == expected)
        }
        
        let genome2: DNAGenome = "TGCCTTA"
        
        let indices = genome2.indices(for: "ATA", maxDistance: 1)
        XCTAssert(indices.count == 1 && indices.first! == genome2.count - 3)
    }
    
    func testMinimalSkew() {
        let minimal = self.genomeToTest.indicesOfMinimalSkew(increment: .a, decrement: .t)
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
    
    func testFrequentPatternsWithDistance() {
        let genome: DNAGenome = "ACGTTGCATGTCGCATGATGCATGAGAGCT"
        let frequent = genome.mostFrequentPatterns(length: 4, maxDistance: 1)
            .sorted { (left, right) -> Bool in
                left.bigIntValue < right.bigIntValue
            }
        
        let expected: [DNAGenome] = [ "GATG", "ATGC", "ATGT" ]
            .sorted { (left, right) -> Bool in
                left.bigIntValue < right.bigIntValue
            }
        XCTAssert(frequent == expected)
    }
    
    func testNeighbors() {
        let genome: DNAGenome = "AGT"
        let neighbors = genome.neighbors(maxDistance: 1)
            .sorted { (left, right) -> Bool in
                left.bigIntValue < right.bigIntValue
            }
        
        let expected: [DNAGenome] = [
            "AGT",
            "CGT",
            "TGT",
            "GGT",
            "ACT",
            "AAT",
            "ATT",
            "AGA",
            "AGC",
            "AGG"
        ]
        .sorted { (left, right) -> Bool in
            left.bigIntValue < right.bigIntValue
        }
        
        XCTAssert(neighbors == expected)
    }
    
    func testIntConversion() {
        let genome: DNAGenome = "AGT"
        let expInt: BigInt = 13
        let expected = DNAGenome(bigInt: expInt, length: 3)
        
        XCTAssert(genome == expected)
        XCTAssert(genome.bigIntValue == expInt)

        let genomes: [DNAGenome] = [
            "CTTTTAGTGGTATTAAGGGTGCCCA",
            "ATTCTAGCCCTATAAGCAATCACTC",
            "GAATGAATATACTCTGACAATATCA",
            "GCTTGCCGGGATTCACACACTATGA",
        ]

        var set: Dictionary<String, String> = [:]
        for genome in genomes {
            set[genome.bigIntValue.description] = genome.description
        }
        
        XCTAssert(set.count == genomes.count)
        for (key, value) in set {
            let integer = BigInt(key, radix: 10)
            let genome = DNAGenome(bigInt: integer!, length: 25)
            XCTAssert(genome == DNAGenome(sequence: value))
        }
    }
    
    func testMotifs() {
        let genomes: [DNAGenome] = [
            "CTTTTAGTGGTATTAAGGGTGCCCA",
            "ATTCTAGCCCTATAAGCAATCACTC",
            "GAATGAATATACTCTGACAATATCA",
            "GCTTGCCGGGATTCACACACTATGA",
            "CTGTGTATTAGACGAACTTAAGTCC",
            "CAATATGAGCGTTAGGGAGCTATAA",
            "CGTAGTATGAAAGCGCTCCCTTCCT",
            "ACATTTATAAGGAGTATGGCAGTAG",
            "ATGAGACTCGCACTCTATGATGGCC",
            "ATGGATGCAATATTAGCGGCTAAAT"
        ]
        
        let motifs = genomes.motifs(length: 5, maxDistance: 1)
            .sorted { (left, right) -> Bool in
                return left.bigIntValue < right.bigIntValue
            }
        
        let expected: [DNAGenome] = [ "ATTAT", "TATAA", "TATCA", "TATGA", "TATTA" ]
            .sorted { (left, right) -> Bool in
                return left.bigIntValue < right.bigIntValue
            }
        
        XCTAssert(motifs == expected)
    }
    
    func testTranslation() {
        let genome: DNAGenome = "AGCATGGGCCCAAACTTTCATAAGCCGGAGCAATGCC"
        
        let protein: Protein = "MGPNFHKPEQ"
        XCTAssert(genome.translate() == protein)
    }

    static var allTests = [
        ("testNucleotide", testNucleotide),
        ("testReverseComplement", testReverseComplement),
        ("testMostFrequentPattern", testMostFrequentPattern),
        ("testIndicesForPattern", testIndicesForPattern),
        ("testMinimalSkew", testMinimalSkew),
        ("testFrequentPatternsWithDistance", testFrequentPatternsWithDistance),
        ("testNeighbors", testNeighbors),
        ("testIntConversion", testIntConversion),
        ("testMotifs", testMotifs),
        ("testTranslation", testTranslation)
    ]
}
