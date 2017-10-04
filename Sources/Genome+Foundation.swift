//
//  Genome+Foundation.swift
//  BioSwift
//
//  Created by Þorvaldur Rúnarsson on 26/09/2017.
//

import Foundation

extension Genome: Hashable {
    public var hashValue: Int {
        return self.bigIntValue.hashValue
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

