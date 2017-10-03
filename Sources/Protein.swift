//
//  Protein.swift
//  BioSwiftPackageDescription
//
//  Created by Þorvaldur Rúnarsson on 03/10/2017.
//

import Foundation

public struct Protein: CustomStringConvertible {
    let genome: Genome
    public let description: String
    
    public init?(genome: Genome) {

        guard let start = genome.index(of: genome.codingStartMarker) else { return nil }
        guard let indexOfCodingEndMarker = genome.index(of: genome.codingEndMarker) else { return nil }
        
        let end = genome.index(indexOfCodingEndMarker, offsetBy: 3)
        let codingSequence = genome[start..<end]
        
        var protein = ""
        
        for i in 0...codingSequence.count-3 where i % 3 == 0 {
            let start = codingSequence.index(codingSequence.startIndex, offsetBy: i)
            let end = codingSequence.index(start, offsetBy: 3)
            
            let key = Genome(sequence: codingSequence[start..<end])
            if let proteinUnit = Utils.codonTable[key] {
                protein += proteinUnit
            }
        }
        
        self.genome = genome
        self.description = protein
    }
    
    public func translate() -> Genome {
        return self.genome
    }
}
