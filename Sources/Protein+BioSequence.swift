//
//  Protein+BioSequence.swift
//  BioSwift
//
//  Created by Þorvaldur Rúnarsson on 03/10/2017.
//

import Foundation
import BigInt

extension Protein: BioSequence {
    public typealias Alphabet = ProteinAlphabet
    
    public static func single(_ unit: AminoAcid) -> Protein {
        return Protein(sequence: "\(unit.charValue)")
    }
    
    init(units: [AminoAcid], bigIntValue: BigInt) {
        self.units = units
        self.bigIntValue = bigIntValue
    }
}
