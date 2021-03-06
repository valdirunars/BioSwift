//
//  Genome.swift
//  BioSwiftPackageDescription
//
//  Created by Þorvaldur Rúnarsson on 05/10/2017.
//

import Foundation
import BigInt
import BigIntCompress

protocol Genome: BioSequence, Compressable {
    associatedtype TranscriptionType: BioSequence
    
    static var codonTable: [Self: String] { get }
    var codingStartMarker: Self { get }
    var codingEndMarker: Self { get }
    var complementBit: Bool { get set }
    
    func transcribed() -> TranscriptionType
}

extension Genome {
    public typealias IndexDistance = Int
    
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
        
        for i in 0..<codingSequence.count-3 where i % 3 == 0 {
            let start = codingSequence.index(codingSequence.startIndex, offsetBy: i)
            let end = codingSequence.index(start, offsetBy: 3)
            
            let key = Self(sequence: codingSequence[start..<end])
            if let proteinUnit = Self.codonTable[key] {
                protein += proteinUnit
            }
        }
        
        return Protein(sequence: protein)
    }
}
