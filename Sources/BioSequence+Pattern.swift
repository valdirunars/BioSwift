//
//  BioSequence+Pattern.swift
//  BioSwiftPackageDescription
//
//  Created by Þorvaldur Rúnarsson on 03/10/2017.
//

import Foundation
import BigInt

extension BioSequence {

    
    /// A way of finding the first occurence of a specific pattern in Self
    ///
    ///    **Worst case: O(n)**
    ///
    /// - Parameters:
    ///   - pattern: The pattern to search for
    ///   - maxDistance: The max hamming distance allowed for the search to return a result
    /// - Returns: An index representing the start location of `pattern`. Nil if none found
    public func index(of pattern: Self, maxDistance: UInt = 0) -> Index? {
        guard self.count > pattern.count else { return nil }
        
        var index: Index?
        
        let len = pattern.count
        for i in 0...self.count {
            let workingIndex = self.index(self.startIndex, offsetBy: i)
            
            let slice = self[workingIndex..<self.index(workingIndex, offsetBy: len)]
            
            if slice.hammingDistance(pattern) <= maxDistance {
                index = workingIndex
                break
            }
        }
        
        return index
    }
    
    /// A way of finding occurences of a specific pattern in Self
    ///
    ///    **Worst case: O(n)**
    ///
    /// - Parameters:
    ///   - pattern: The pattern to search for
    ///   - maxDistance: The max hamming distance allowed for the search to return a result
    /// - Returns: An array of all locations where a match was found
    public func indices(for pattern: Self, maxDistance: UInt = 0) -> [Index] {
        guard self.count > pattern.count else { return [] }
        
        var indices: [Index] = []
        let len: Int = pattern.count
        let count: Int = self.count
        for i in 0...(count - len) {
            let workingIndex = self.index(self.startIndex, offsetBy: i)
            
            let slice = self[workingIndex..<self.index(workingIndex, offsetBy: len)]
            
            if slice.hammingDistance(pattern) <= maxDistance {
                indices.append(workingIndex)
            }
        }
        
        return indices
    }
    
    
    /// A way of finding the most frequent subpattern in Self of a specific length
    ///
    ///     **Worst case: O(n)**
    ///
    /// - Parameter length: The length the patterns in focus
    /// - Returns: The first occurence of the pattern with `x` occurences. `x` being the occurence count of the most frequent pattern
    public func mostFrequentPattern(length: Int) -> Self {
        assert(self.count >= length, "No pattern found for the given length")
        
        var workingIndex = self.startIndex
        let endIndex = self.index(self.startIndex, offsetBy: self.count-length+1)
        
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
        
        return Self(sequence: self[startIndexOfMostFrequent..<self.index(startIndexOfMostFrequent, offsetBy: length)])
    }
    
    
    /// A way of finding most frequent subpatterns of a specific length, allowing for a certain amount of hamming distance when counting occurences
    ///
    ///     **Worst case: O(n^2)** or more specifically T(Array.sort) + T(c * n + k)
    /// - Parameters:
    ///   - length: The length the patterns in focus
    ///   - maxDistance: The max amount of hamming distance allowed for when counting occurences of a pattern
    /// - Returns: An array of most frequent patterns (all have the same occurence count)
    public func mostFrequentPatterns(length: Int, maxDistance: UInt = 0) -> [Self] {
        var frequentPatterns: [Self] = []
        var neighborhoods: [Self] = []
        
        for i in 0...self.count-length {
            neighborhoods += Self(sequence: self[i..<i+length]).neighbors(maxDistance: maxDistance)
        }
        
        var index: [BigInt] = []
        var counts: [Int] = []
        for i in 0..<neighborhoods.count {
            let pattern = neighborhoods[i]
            index.append(pattern.bigIntValue)
            counts.append(1)
        }
        
        index.sort()
        
        for i in 0..<neighborhoods.count-1 where index[i] == index[i+1] {
            counts[i + 1] = counts[i] + 1
        }
        let maxCount = counts.max() ?? 0
        
        for i in 0..<neighborhoods.count-1 where counts[i] == maxCount {
            let pattern = Self(bigInt: index[i], length: length)
            frequentPatterns.append(pattern)
        }
        
        return frequentPatterns
    }
    
    
    /// Finds all indices where the difference between decrement and increment is at its peak
    ///
    ///     **Worst case: O(n)**
    ///
    /// - Parameters:
    ///   - increment: The element value for when to increment the current skew
    ///   - decrement: The element value for when to decrement the current skew
    /// - Returns: All indexes where the difference between decrement and increment is at its peak
    public func indicesOfMinimalSkew(increment: Self.Element, decrement: Self.Element) -> [Index] {
        
        var skew = 0
        var currentMinimumSkew: Int = self.count
        var skewIndices: [Index] = []

        for i in 0..<self.count {
            let unit = self[i]

            var addition = 0
            if unit == increment {
                addition = 1
            } else if unit == decrement {
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
    
    
    /// Returns all genomes with hamming distance of at most `maxDistance` from self
    ///
    /// **NOTE:** This algorithm is slow! Do not use unless self.count is low or distance is low
    ///
    /// Σ(0, n) = 1 + 2 + ... + n
    /// **Worst case: O( d * (Σ(0, n) * n))**
    /// - Returns: All genomes of at most `maxDistance` hamming distance from self
    public func neighbors(maxDistance: UInt) -> [Self] {
        return Utils.neighbors(pattern: self[self.startIndex..<self.endIndex], maxDistance: maxDistance)
    }
    
    /// All subpatterns of length `length` in the genome
    public func allSubpatterns(length: Int) -> [Self] {
        var subs: [Self] = []
        for i in 0...count-length {
            subs.append(Self(sequence: self[i..<i+length]))
        }

        return subs
    }
}
