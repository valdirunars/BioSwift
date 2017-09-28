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
    
    public func indices(for pattern: Genome, maxDistance: UInt = 0) -> [Index] {
        guard self.count > pattern.count else { return [] }
        
        var indices: [Index] = []
        let len = pattern.count
        for i in 0..<(self.count-len) {
            let workingIndex = self.index(self.startIndex, offsetBy: i)
            
            let slice = self[workingIndex..<self.index(workingIndex, offsetBy: len)]

            if slice.hammingDistance(pattern) <= maxDistance {
                indices.append(workingIndex)
            }
        }
        
        return indices
    }
    
    public func mostFrequentPattern(length: Int) -> Genome {
        assert(self.count >= length, "No pattern found for the given length")
        
        var workingIndex = self.startIndex
        let endIndex = self.index(self.startIndex, offsetBy: self.count-length)
        
        var mostFrequent = 1
        var startIndexOfMostFrequent = self.startIndex
        var counts: [String: Int] = [:]
        
        while workingIndex != endIndex {
            
            let end = self.index(workingIndex, offsetBy: length)
            
            let slice = self[workingIndex..<end]
            
            if let count = counts[slice.description]{
                let next = count + 1
                counts[slice.description] = next
                if next > mostFrequent {
                    mostFrequent = next
                    startIndexOfMostFrequent = workingIndex
                }
            } else {
                counts[slice.description] = 1
            }
            
            workingIndex = self.index(after: workingIndex)
            
        }
        
        return Genome(sequence: self[startIndexOfMostFrequent..<self.index(startIndexOfMostFrequent, offsetBy: length)])
    }
    
    public func mostFrequentPatterns(length: Int, maxDistance: UInt = 0) -> [Genome] {
        var frequentPatterns: [Genome] = []
        var neighborhoods: [Genome] = []
        
        for i in 0..<self.count-length {
            neighborhoods += Genome(sequence: self[i..<i+length]).neighbors(maxDistance: maxDistance)
        }
        
        var index: [BigInt] = []
        var counts: [Int] = []
        for i in 0..<neighborhoods.count {
            let pattern = neighborhoods[i]
            index.append(pattern.asInteger())
            counts.append(1)
        }
        
        index.sort()
        
        for i in 0..<neighborhoods.count-1 where index[i] == index[i+1] {
            counts[i + 1] = counts[i] + 1
        }
        let maxCount = counts.max() ?? 0
        
        for i in 0..<neighborhoods.count where counts[i] == maxCount {
            let pattern = Genome(bigInt: index[i], length: length)
            frequentPatterns.append(pattern)
        }
        
        return frequentPatterns
    }
    
    public func indicesOfMinimalSkew(increment: Nucleotide, decrement: Nucleotide) -> [Index] {
        
        var skew = 0
        var currentMinimumSkew = self.count
        var skewIndices: [Index] = []
        
        for i in 0..<self.count {
            let nuc = self[i]
            
            var addition = 0
            if nuc == increment {
                addition = 1
            } else if nuc == decrement {
                addition = -1
            }
            
            skew = skew + addition
            if skew < currentMinimumSkew {
                skewIndices = [ i ]
                currentMinimumSkew = skew
            } else if skew == currentMinimumSkew {
                skewIndices.append(i)
            }
        }
        
        return skewIndices
    }
    
    public func neighbors(maxDistance: UInt) -> [Genome] {
        return Utils.neighbors(pattern: self[self.startIndex..<self.endIndex], maxDistance: maxDistance)
    }
    
    
}
