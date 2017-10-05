//
//  CharConvertible.swift
//  BioSwift
//
//  Created by Þorvaldur Rúnarsson on 03/10/2017.
//

import Foundation
import BigInt

public protocol BioAlphabet {
    associatedtype Base: CharConvertible, ByteRepresentable

    static var alphabet: [Base] { get }
}

public struct DNAAlphabet: BioAlphabet {
    public typealias Base = Nucleotide
    public static var alphabet: [Nucleotide] {
        return [ .a, .c, .g, .t ]
    }
}

public struct RNAAlphabet: BioAlphabet {
    public typealias Base = Nucleotide
    public static var alphabet: [Nucleotide] {
        return [ .a, .c, .g, .u ]
    }
}

public struct ProteinAlphabet: BioAlphabet {
    public typealias Base = AminoAcid
    public static var alphabet: [AminoAcid] {
        return [ .a, .c, .d, .e, .f, .g, .h, .i, .k, .l, .m, .n, .p, .q, .r, .s, .t, .v, .w, .y ]
    }
}

public protocol CharConvertible {
    static var componentCount: BigInt { get }

    var charValue: Character { get }
    init?(unit: Character)
}

extension Character: CharConvertible {
    private static var supportedASCIICharCount: Int { return 94 }

    public static var componentCount: BigInt { return BigInt(integerLiteral: Int64(supportedASCIICharCount)) /*ASCII*/ }

    public static var alphabetString: String {
        return String((33...126).map {
            return Character(UnicodeScalar($0)!)
        })
    }
    public init?(unit: Character) {
        self = unit
    }
    
    public var charValue: Character { return self }
}

extension Nucleotide: CharConvertible {
    public static var componentCount: BigInt { return 5 }

    public static var alphabetString: String { return "ACGTU" }

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
    
    public init?(unit: Character) {
        let val = unit
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

    public static var alphabetString: String {
        return "ACDEFGHIKLMNPQRSTVWY"
    }

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
    
    public init?(unit: Character) {
        if unit == "A" {
            self = .a
            return
        } else if unit == "C" {
            self = .c
            return
        } else if unit == "D" {
            self = .d
            return
        } else if unit == "E" {
            self = .e
            return
        } else if unit == "F" {
            self = .f
            return
        } else if unit == "G" {
            self = .g
            return
        } else if unit == "H" {
            self = .h
            return
        } else if unit == "I" {
            self = .i
            return
        } else if unit == "K" {
            self = .k
            return
        } else if unit == "L" {
            self = .l
            return
        } else if unit == "M" {
            self = .m
            return
        } else if unit == "N" {
            self = .n
            return
        } else if unit == "P" {
            self = .p
            return
        } else if unit == "Q" {
            self = .q
            return
        } else if unit == "R" {
            self = .r
            return
        } else if unit == "S" {
            self = .s
            return
        } else if unit == "T" {
            self = .t
            return
        } else if unit == "V" {
            self = .v
            return
        } else if unit == "W" {
            self = .w
            return
        } else if unit == "Y" {
            self = .y
            return
        }
        return nil
    }
}

