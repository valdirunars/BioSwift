//
//  DNAGenome.swift
//  BioSwift
//
//  Created by Þorvaldur Rúnarsson on 24/09/2017.
//

import Foundation
import BigInt

public struct DNAGenome: Genome, BigIntConvertible, CustomStringConvertible {
    typealias Alphabet = DNAAlphabet

    var codingStartMarker: DNAGenome { return DNAGenome(sequence: "ATG") }
    var codingEndMarker: DNAGenome { return DNAGenome(sequence: "AAT") }
    
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
    
    public static let codonTable: [DNAGenome : String] = [
        "ATA":"I", "ATC":"I", "ATT":"I", "ATG":"M",
        "ACA":"T", "ACC":"T", "ACG":"T", "ACT":"T",
        "AAC":"N", "AAT":"N", "AAA":"K", "AAG":"K",
        "AGC":"S", "AGT":"S", "AGA":"R", "AGG":"R",
        "CTA":"L", "CTC":"L", "CTG":"L", "CTT":"L",
        "CCA":"P", "CCC":"P", "CCG":"P", "CCT":"P",
        "CAC":"H", "CAT":"H", "CAA":"Q", "CAG":"Q",
        "CGA":"R", "CGC":"R", "CGG":"R", "CGT":"R",
        "GTA":"V", "GTC":"V", "GTG":"V", "GTT":"V",
        "GCA":"A", "GCC":"A", "GCG":"A", "GCT":"A",
        "GAC":"D", "GAT":"D", "GAA":"E", "GAG":"E",
        "GGA":"G", "GGC":"G", "GGG":"G", "GGT":"G",
        "TCA":"S", "TCC":"S", "TCG":"S", "TCT":"S",
        "TTC":"F", "TTT":"F", "TTA":"L", "TTG":"L",
        "TAC":"Y", "TAT":"Y", "TAA":"_", "TAG":"_",
        "TGC":"C", "TGT":"C", "TGA":"_", "TGG":"W",
    ]
    
    mutating internal func swap(a: Nucleotide, with b: Nucleotide) {
        self.units = self.units.map { nuc in
            guard nuc != a else { return b }
            return nuc
        }
    }
    
    public static prefix func ! (genome: DNAGenome) -> DNAGenome {
        var tmp = genome
        tmp.complementBit = !tmp.complementBit
        return tmp
    }
    
    public static func single(_ unit: Nucleotide) -> DNAGenome {
        return DNAGenome(sequence: "\(unit.charValue)")
    }
    
    init(units: [Nucleotide], bigIntValue: BigInt) {
        self.units = units
        self.bigIntValue = bigIntValue
    }
    
    public subscript(index: Index) -> Nucleotide {
        return self.complementBit ? !self.units[index] : self.units[index]
    }
    
    public func transcribed() -> RNAGenome {
        var tmp = self
        tmp.swap(a: .t, with: .u)
        return RNAGenome(sequence: tmp)
    }
}
