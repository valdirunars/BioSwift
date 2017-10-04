//
//  CharConvertible.swift
//  BioSwift
//
//  Created by Þorvaldur Rúnarsson on 03/10/2017.
//

import Foundation
import BigInt

public protocol CharConvertible {
    static var componentCount: BigInt { get }
    var charValue: Character { get }
    init?(unit: CharConvertible)
}

extension Character: CharConvertible {
    public static var componentCount: BigInt { return 128 /*ASCII*/ }

    public init?(unit: CharConvertible) {
        self = unit.charValue
    }
    
    public var charValue: Character { return self }
}

extension Nucleotide: CharConvertible {
    public static var componentCount: BigInt { return 5 }
    
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
        case .u:
            return "U"
        }
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
        } else if val == "U" {
            self = .u
        }
        return nil
    }
}

extension AminoAcid: CharConvertible {
    
    public static var componentCount: BigInt { return 20 }

    public var charValue: Character {
        switch self {
        case .a:
            return "A"
        case .c:
            return "C"
        case .d:
            return "D"
        case .e:
            return "E"
        case .f:
            return "F"
        case .g:
            return "G"
        case .h:
            return "H"
        case .i:
            return "I"
        case .k:
            return "K"
        case .l:
            return "L"
        case .m:
            return "M"
        case .n:
            return "N"
        case .p:
            return "P"
        case .q:
            return "Q"
        case .r:
            return "R"
        case .s:
            return "S"
        case .t:
            return "T"
        case .v:
            return "V"
        case .w:
            return "W"
        case .y:
            return "Y"
        }
    }
    
    public init?(unit: CharConvertible) {
        let val = unit.charValue
        if val == "A" {
            self = .a
            return
        } else if val == "C" {
            self = .c
            return
        } else if val == "D" {
            self = .d
            return
        } else if val == "E" {
            self = .e
            return
        } else if val == "F" {
            self = .f
            return
        } else if val == "G" {
            self = .g
            return
        } else if val == "H" {
            self = .h
            return
        } else if val == "I" {
            self = .i
            return
        } else if val == "K" {
            self = .k
            return
        } else if val == "L" {
            self = .l
            return
        } else if val == "M" {
            self = .m
            return
        } else if val == "N" {
            self = .n
            return
        } else if val == "P" {
            self = .p
            return
        } else if val == "Q" {
            self = .q
            return
        } else if val == "R" {
            self = .r
            return
        } else if val == "S" {
            self = .s
            return
        } else if val == "T" {
            self = .t
            return
        } else if val == "V" {
            self = .v
            return
        } else if val == "W" {
            self = .w
            return
        } else if val == "Y" {
            self = .y
            return
        }
        return nil
    }
}

