//
//  Genome+BigInt.swift
//  BioSwiftPackageDescription
//
//  Created by Þorvaldur Rúnarsson on 28/09/2017.
//

import Foundation
import BigInt

protocol BigIntReadable {
    var bigIntValue: BigInt { get }
}

protocol BigIntConvertible: BigIntReadable {
    var bigIntValue: BigInt { get set }
}

protocol BigIntInitializable {
    init(bigInt: BigInt, length: Int)
}
