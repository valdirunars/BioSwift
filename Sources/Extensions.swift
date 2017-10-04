//
//  Extensions.swift
//  BioSwift
//
//  Created by Þorvaldur Rúnarsson on 25/09/2017.
//

import Foundation
import BigInt

internal extension Array where Element: Equatable {
    mutating func uniquify() {
        var lastIndex: Index?
        for element in self {
            while self.contains(element) {
                guard let idx = self.index(of: element) else { break }
                lastIndex = idx
                self.remove(at: idx)
            }

            if let lastIndex = lastIndex {
                self.insert(element, at: lastIndex)
            }
        }
    }
}

internal extension BigInt {
    func pattern<T: BioSequence>(length: Int) -> T {
        return Utils.integerToPattern(integer: self, length: length)
    }
}

extension String {
    func stringByRemovingWhitespaceInFront() -> String {
        let spaces = NSCharacterSet.whitespaces

        var index = self.startIndex
        while index != self.endIndex {

            guard index != self.endIndex, spaces.contains(self[index].unicodeScalars.first!) else {
                break
            }
            index = self.index(index, offsetBy: 1)
            
        }
        return String(self[index..<self.endIndex])
    }
}

extension Collection where Element: CharConvertible {
    public var description: String {
        return String(self.map {
            return $0.charValue
        })
    }
}

extension Slice where Base.Element: CharConvertible {
    var description: String {
        return String(self.map {
            $0.charValue
        })
    }
}

extension ArraySlice where Element: Equatable {
    
    func hammingDistance<C: Collection>(_ collection: C) -> Int {
        assert(self.count == collection.count, "Attempting to compute hamming distance of two strings that differ in length")
        
        return zip(self, collection).reduce(0) { (result, tuple) -> Int in
            let unit1 = tuple.0
            guard let unit2 = tuple.1 as? Element else {
                return result + 1
            }
            
            return unit1 == unit2 ? result : result + 1
        }
    }
}
