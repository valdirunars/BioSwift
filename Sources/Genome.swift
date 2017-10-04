//
//  Genome.swift
//  BioSwift
//
//  Created by Þorvaldur Rúnarsson on 24/09/2017.
//

import Foundation
import BigInt

public struct Genome: BigIntConvertible, CustomStringConvertible {

    var codingStartMarker: Genome {
        return Genome(sequence: "A\(self.type == .dna ? "T" : "U")G")
    }

    var codingEndMarker: Genome {
        return Genome(sequence: "AA\(self.type == .dna ? "T" : "U")")
    }
    
    public internal(set) var tag: String? = nil
    internal var complementBit = false

    public internal(set) var units: [Nucleotide]
    public internal(set) var  bigIntValue: BigInt
    public var type: GenomeType {
        return self.contains(.t) ? .dna : .rna
    }

    public var startIndex: Index {
        return self.units.startIndex
    }

    public var endIndex: Index {
        return self.units.endIndex
    }

    public var count: Int {
        return self.units.count
    }

    public func hammingDistance<C: Collection>(_ collection: C) -> Int where C.Element == Nucleotide, C.Index == Index {
        return self[0..<self.count].hammingDistance(collection)
    }
    
    mutating internal func swap(a: Nucleotide, with b: Nucleotide) {
        self.units = self.units.map { nuc in
            guard nuc != a else { return b }
            return nuc
        }
    }
    
    public static prefix func ! (genome: Genome) -> Genome {
        var tmp = genome
        tmp.complementBit = !tmp.complementBit
        return tmp
    }
    
    public subscript(index: Index) -> Nucleotide {
        return self.complementBit ? !self.units[index] : self.units[index]
    }
}
