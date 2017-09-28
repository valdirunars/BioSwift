//
//  Extensions.swift
//  BioSwift
//
//  Created by Þorvaldur Rúnarsson on 25/09/2017.
//

import Foundation

internal extension Collection {
    func iterate<C: Collection>(with collection: C, iterationBlock: (Element, C.Element) -> Void) where C.Element == Element, C.Index == Index  {

        assert(self.count <= collection.count, "The collection provided has a count that exceeds self.count.\n\nReverse this statement to say collection.iterate(obj) instead of obj.iterate(collection)")

        for tuple in zip(self, collection) {
            iterationBlock(tuple.0, tuple.1)
        }
    }
}

