//
//  Genome+Foundation.swift
//  BioSwift
//
//  Created by Þorvaldur Rúnarsson on 26/09/2017.
//

import Foundation

extension Genome: Hashable {
    public var hashValue: Int {
        return self.bigIntValue.description.hashValue
    }
}

extension Collection where Element == Genome {
    public func motifs(length: Int, maxDistance: UInt) -> [Genome] {
        var patterns: [Genome] = []

        var allSubs = self.flatMap({ $0.allSubgenomes(length: length) })
        allSubs.uniquify()
        for genome in allSubs {
            let neighbors = genome.neighbors(maxDistance: maxDistance)
            for neighbor in neighbors {
                let allElementsContainNeighbor = self.map { element in
                    return element.indices(for: neighbor, maxDistance: maxDistance).isEmpty == false ? 1 : 0
                }
                .reduce(0, +) == self.count

                if allElementsContainNeighbor {
                    patterns.append(neighbor)
                }
            }
            patterns.uniquify()
        }

        return patterns
    }
}

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

