//
//  ByteRepresentable.swift
//  BioSwift
//
//  Created by Þorvaldur Rúnarsson on 04/10/2017.
//

import Foundation
import BigInt

public typealias Byte = UInt8
public protocol ByteRepresentable: BigIntReadable, Equatable {
    var rawValue: Byte { get }
    init?(rawValue: Byte)
}

extension ByteRepresentable {
    public var bigIntValue: BigInt {
        return BigInt(integerLiteral: Int64(self.rawValue))
    }
    
    public static func == (left: Self, right: Self) -> Bool {
        return left.rawValue == right.rawValue
    }
}

extension Character: ByteRepresentable {
    public var rawValue: Byte {
        return Byte(self.unicodeScalarCodePoint())
    }
    
    public init?(rawValue: Byte) {
        self.init(UnicodeScalar(rawValue))
    }
}
