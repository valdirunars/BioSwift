//
//  Extensions.swift
//  BioSwift
//
//  Created by Þorvaldur Rúnarsson on 25/09/2017.
//

import Foundation
import BigInt

internal extension Collection {
    func iterate<C: Collection>(with collection: C, iterationBlock: (Element, C.Element) -> Void) where C.Element == Element, C.Index == Index  {

        assert(self.count <= collection.count, "The collection provided has a count that exceeds self.count.\n\nReverse this statement to say collection.iterate(obj) instead of obj.iterate(collection)")

        for tuple in zip(self, collection) {
            iterationBlock(tuple.0, tuple.1)
        }
    }
}

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
    func pattern(length: Int) -> Genome {
        return Utils.integerToPattern(integer: self, length: length)
    }
}

