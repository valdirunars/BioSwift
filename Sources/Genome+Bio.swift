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
    
    public func indices(for pattern: Genome, maxDistance: Int = 0) -> [Index] {
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
    
    internal func neighbors(maxDistance: UInt) -> [Genome] {
        guard maxDistance != 0 else { return [ self ] }
        guard maxDistance != 1 else {
            return [ .single(.a), .single(.g), .single(.c), .single(.t) ]
        }
        fatalError("Not implemented")
    }
    
    internal func asInteger() -> Int {
        return Utils.patternToInteger(pattern: self[self.startIndex..<self.count])
    }
}
