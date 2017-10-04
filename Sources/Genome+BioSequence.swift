//
//  Genome+BioSequence.swift
//  BioSwift
//
//  Created by Þorvaldur Rúnarsson on 03/10/2017.
//

import Foundation
import BigInt

extension Genome: BioSequence {
    typealias Unit = Nucleotide

    public static func single(_ unit: Nucleotide) -> Genome {
        return Genome(sequence: "\(unit.charValue)")
    }
    
    init(units: [Nucleotide], bigIntValue: BigInt) {
        self.units = units
        self.bigIntValue = bigIntValue
    }
}
