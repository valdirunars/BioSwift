//
//  Genome+BigInt.swift
//  BioSwiftPackageDescription
//
//  Created by Þorvaldur Rúnarsson on 28/09/2017.
//

import Foundation
import BigInt

protocol BigIntConvertible {
    init(bigInt: BigInt, length: Int)
    func asInteger() -> BigInt
}

extension Genome: BigIntConvertible {
    init(bigInt: BigInt, length: Int) {
        self = Utils.integerToPattern(integer: bigInt, length: length)
    }
    
    internal func asInteger() -> BigInt {
        return Utils.patternToInteger(pattern: self[self.startIndex..<self.count])
    }
}
