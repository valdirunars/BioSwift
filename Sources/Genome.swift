//
//  Genome.swift
//  BioSwift
//
//  Created by Þorvaldur Rúnarsson on 24/09/2017.
//

import Foundation
import BigInt

public extension Slice where Base == Genome {
    var description: String {
        return String(self.map {
            $0.charValue
        })
    }
    
    func hammingDistance<C: Collection>(_ collection: C) -> Int where C.Element == Nucleotide, C.Index == Index {
        assert(self.count == collection.count, "Attempting to compute hamming distance of two strings that differ in length")
        var distance = 0
        self.iterate(with: collection) { (nuc1, nuc2) in
            if nuc1 != nuc2 {
                distance += 1
            }
        }
        return distance
    }
}

public struct Genome: BigIntConvertible {

    var codingStartMarker: Genome {
        return Genome(sequence: "A\(self.type == .dna ? "T" : "U")G")
    }

    var codingEndMarker: Genome {
        return Genome(sequence: "AA\(self.type == .dna ? "T" : "U")")
    }
    
    public internal(set) var nucleotides: [Nucleotide]
    public internal(set) var  bigIntValue: BigInt
    public var type: GenomeType {
        return self.contains(.t) ? .dna : .rna
    }

    internal var complementBit = false

    public var startIndex: Index {
        return self.nucleotides.startIndex
    }

    public var endIndex: Index {
        return self.nucleotides.endIndex
    }

    public var count: Int {
        return self.nucleotides.count
    }
    
    public static func single(_ nuc: Nucleotide) -> Genome {
        return Genome(sequence: "\(nuc.charValue)")
    }
    
    public init<S: Sequence>(sequence: S) where S.Element: CharConvertible {
        self.nucleotides = []
        var finalIntValue: BigInt = 0
        for element in sequence {
            guard let nuc = Nucleotide(unit: element) else { continue }
            self.nucleotides.append(nuc)
            
            let nucIntValue = BigInt(integerLiteral: Int64(nuc.rawValue))
            finalIntValue = Nucleotide.componentCount * finalIntValue + nucIntValue
        }
        self.bigIntValue = finalIntValue
    }
    
    init(bigInt: BigInt, length: Int) {
        self = bigInt.pattern(length: length)
    }
    
    public func hammingDistance<C: Collection>(_ collection: C) -> Int where C.Element == Nucleotide, C.Index == Index {
        return self[0..<self.count].hammingDistance(collection)
    }
    
    mutating internal func swap(a: Nucleotide, with b: Nucleotide) {
        self.nucleotides = self.nucleotides.map { nuc in
            guard nuc != a else { return b }
            return nuc
        }
    }
}
