//
//  Nucleotide.swift
//  BioSwift
//
//  Created by Þorvaldur Rúnarsson on 24/09/2017.
//

import Foundation
import BigInt

public typealias Byte = UInt8

public protocol CharConvertible {
    init?(unit: CharConvertible)
    var charValue: Character { get }
}

extension Character: CharConvertible {

    public init?(unit: CharConvertible) {
        self = unit.charValue
    }

    public var charValue: Character { return self }
}

public enum Nucleotide: Byte, CharConvertible, Equatable {
    case a = 0 // adenine
    case c = 1 // cytosine
    case g = 2 // guanine
    case t = 3 // thymine
    
    public var charValue: Character {
        switch self {
        case .a:
            return "A"
        case .c:
            return "C"
        case .g:
            return "G"
        case .t:
            return "T"
        }
    }

    var bigIntValue: BigInt {
        return BigInt(integerLiteral: Int64(self.rawValue))
    }
    
    public static let componentCount: BigInt = 4
    
    internal static var all: [Nucleotide] {
        return [ .a, .c, .g, .t ]
    }
    
    public static var random: Nucleotide {
        return Nucleotide.all[Int(arc4random()) % Int(componentCount)]
    }

    public init?(unit: CharConvertible) {
        let val = unit.charValue
        if val == "A" {
            self = .a
            return
        } else if val == "C" {
            self = .c
            return
        } else if val == "G" {
            self = .g
            return
        } else if val == "T" {
            self = .t
            return
        }
        return nil
    }

    public static prefix func ! (nucleotide: Nucleotide) -> Nucleotide {
        switch nucleotide {
        case .a:
            return .t
        case .c:
            return .g
        case .g:
            return .c
        case .t:
            return .a
        }
    }

    public static func == (left: Nucleotide, right: Nucleotide) -> Bool {
        return left.rawValue == right.rawValue
    }
}
