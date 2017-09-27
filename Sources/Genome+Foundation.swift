//
//  Genome+Foundation.swift
//  BioSwift
//
//  Created by Þorvaldur Rúnarsson on 26/09/2017.
//

import Foundation

extension Genome: Collection {
    public typealias Index = Int

    public func index(after i: Index) -> Index {
        return self.nucleotides.index(after: i)
    }
    
    public subscript(index: Index) -> Nucleotide {
        return self.complementBit ? !self.nucleotides[index] : self.nucleotides[index]
    }
    
    public func character(at index: Index) -> Character {
        return self[index].charValue
    }
}

extension Genome: CustomStringConvertible {
    public var description: String {
        return String(self.map {
            $0.charValue
        })
    }
}

extension Genome: Equatable {
    public static func == (left: Genome, right: Genome) -> Bool {
        guard left.count == right.count else { return false }
        
        for i in 0..<left.count {
            let nuc = left[i]
            if nuc != right[i] {
                return false
            }
        }
        return true
    }
}
