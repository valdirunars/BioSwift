//
//  ByteRepresentable.swift
//  BioSwift
//
//  Created by Þorvaldur Rúnarsson on 04/10/2017.
//

import Foundation
import BigInt

public typealias Byte = UInt8
protocol ByteRepresentable: BigIntReadable, Equatable {
    var rawValue: Byte { get }
    init?(rawValue: Byte)
}

extension ByteRepresentable {
    var bigIntValue: BigInt {
        return BigInt(integerLiteral: Int64(self.rawValue))
    }
    
    public static func == (left: Self, right: Self) -> Bool {
        return left.rawValue == right.rawValue
    }
}
