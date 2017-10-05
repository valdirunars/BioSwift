//
//  RNAGenome.swift
//  BioSwift
//
//  Created by Þorvaldur Rúnarsson on 05/10/2017.
//

import Foundation
import BigInt

public struct RNAGenome: Genome, BigIntConvertible, CustomStringConvertible {
    typealias Alphabet = RNAAlphabet
    
    var codingStartMarker: RNAGenome {
        return RNAGenome(sequence: "AUG")
    }
    
    var codingEndMarker: RNAGenome {
        return RNAGenome(sequence: "AAU")
    }
    
    public internal(set) var tag: String? = nil
    internal var complementBit = false
    
    public internal(set) var units: [Nucleotide]
    public internal(set) var  bigIntValue: BigInt
    
    public var startIndex: Index {
        return self.units.startIndex
    }
    
    public var endIndex: Index {
        return self.units.endIndex
    }
    
    public var count: Int {
        return self.units.count
    }
    
    public static var codonTable: [RNAGenome : String] = [
        "AUA":"I", "AUC":"I", "AUU":"I", "AUG":"M",
        "ACA":"T", "ACC":"T", "ACG":"T", "ACU":"T",
        "AAC":"N", "AAU":"N", "AAA":"K", "AAG":"K",
        "AGC":"S", "AGU":"S", "AGA":"R", "AGG":"R",
        "CUA":"L", "CUC":"L", "CUG":"L", "CUU":"L",
        "CCA":"P", "CCC":"P", "CCG":"P", "CCU":"P",
        "CAC":"H", "CAU":"H", "CAA":"Q", "CAG":"Q",
        "CGA":"R", "CGC":"R", "CGG":"R", "CGU":"R",
        "GUA":"V", "GUC":"V", "GUG":"V", "GUU":"V",
        "GCA":"A", "GCC":"A", "GCG":"A", "GCU":"A",
        "GAC":"D", "GAU":"D", "GAA":"E", "GAG":"E",
        "GGA":"G", "GGC":"G", "GGG":"G", "GGU":"G",
        "UCA":"S", "UCC":"S", "UCG":"S", "UCU":"S",
        "UUC":"F", "UUU":"F", "UUA":"L", "UUG":"L",
        "UAC":"Y", "UAU":"Y", "UAA":"_", "UAG":"_",
        "UGC":"C", "UGU":"C", "UGA":"_", "UGG":"W",
    ]
    
    mutating internal func swap(a: Nucleotide, with b: Nucleotide) {
        self.units = self.units.map { nuc in
            guard nuc != a else { return b }
            return nuc
        }
    }
    
    public static prefix func ! (genome: RNAGenome) -> RNAGenome {
        var tmp = genome
        tmp.complementBit = !tmp.complementBit
        return tmp
    }
    
    public static func single(_ unit: Nucleotide) -> RNAGenome {
        return RNAGenome(sequence: "\(unit.charValue)")
    }
    
    init(units: [Nucleotide], bigIntValue: BigInt) {
        self.units = units
        self.bigIntValue = bigIntValue
    }
    
    public subscript(index: Index) -> Nucleotide {
        return self.complementBit ? !self.units[index] : self.units[index]
    }
    
    public func transcribed() -> DNAGenome {
        var tmp = self
        tmp.swap(a: .u, with: .t)
        return DNAGenome(sequence: tmp)
    }
}
