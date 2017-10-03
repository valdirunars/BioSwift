//
//  Genome+Bio.swift
//  BioSwift
//
//  Created by Þorvaldur Rúnarsson on 26/09/2017.
//

import Foundation
import BigInt

extension Genome {
    
    public mutating func reverseComplement() {
        self.nucleotides = self.nucleotides.reversed()
        self.complementBit = !self.complementBit
    }
    
    public func translate() -> Protein? {
        return Protein(genome: self)
    }
    
    public mutating func transcribe() {
        if self.contains(.u) {
            self.swap(a: .u, with: .t)
        } else {
            self.swap(a: .t, with: .u)
        }
    }
    
    public func transcribed() -> Genome {
        var tmp = self
        tmp.transcribe()
        return tmp
    }
}
