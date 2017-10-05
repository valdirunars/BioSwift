//
//  Genome+Foundation.swift
//  BioSwift
//
//  Created by Þorvaldur Rúnarsson on 26/09/2017.
//

import Foundation

extension Collection where Element: BioSequence {
    func _motifs(length: Int, maxDistance: UInt) -> [Element] {
        var patterns: [Element] = []

        var allSubs = self.flatMap({ $0.allSubpatterns(length: length) })
        allSubs.uniquify()
        for seq in allSubs {
            let neighbors = seq.neighbors(maxDistance: maxDistance)
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

extension Collection where Element == DNAGenome {
    public func motifs(length: Int, maxDistance: UInt) -> [DNAGenome] {
        return _motifs(length: length, maxDistance: maxDistance)
    }
}

extension Collection where Element == RNAGenome {
    public func motifs(length: Int, maxDistance: UInt) -> [RNAGenome] {
        return _motifs(length: length, maxDistance: maxDistance)
    }
}

