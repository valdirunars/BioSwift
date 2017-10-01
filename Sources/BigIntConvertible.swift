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
    var bigIntValue: BigInt { get }
}
