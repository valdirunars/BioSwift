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
        self.units = self.units.reversed()
        self.complementBit = !self.complementBit
    }
    
    public func translate() -> Protein? {
        guard let start = self.index(of: self.codingStartMarker) else { return nil }
        guard let indexOfCodingEndMarker = self.index(of: self.codingEndMarker) else { return nil }
        
        let end = self.index(indexOfCodingEndMarker, offsetBy: 3)
        let codingSequence = self[start..<end]
        
        var protein = ""
        
        for i in 0...codingSequence.count-3 where i % 3 == 0 {
            let start = codingSequence.index(codingSequence.startIndex, offsetBy: i)
            let end = codingSequence.index(start, offsetBy: 3)
            
            let key = Genome(sequence: codingSequence[start..<end])
            if let proteinUnit = Utils.codonTable[key] {
                protein += proteinUnit
            }
        }
        
        return Protein(sequence: protein)
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
