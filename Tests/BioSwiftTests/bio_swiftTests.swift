import XCTest
@testable import bio_swift

class bio_swiftTests: XCTestCase {
    func testNucleotide() {
        
        let nucs: [(Nucleotide, String, String)] = [
            (.a, "A", "T"),
            (.c, "C", "G"),
            (.g, "G", "C"),
            (.t, "T", "A")
        ]
        
        for nuc in nucs {
            let nucleotide = nuc.0
            let raw = nuc.1
            let complimentRaw = nuc.2
            
            XCTAssert(raw == nucleotide.rawValue)
            let compliment = !nucleotide
            XCTAssert(complimentRaw == compliment.rawValue)
        }
    }


    static var allTests = [
        ("testNucleotide", testNucleotide),
    ]
}
