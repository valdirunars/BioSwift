//
//  BioSequence.swift
//  BioSwift
//
//  Created by Þorvaldur Rúnarsson on 03/10/2017.
//

import Foundation
import BigInt

protocol BioSequenceAlgebra: BigIntConvertible, BigIntInitializable, Equatable {
    associatedtype Alphabet: BioAlphabet

    static func + (left: Self, right: Alphabet.Base) -> Self
    static func + (left: Alphabet.Base, right: Self) -> Self
    static func + (left: Self, right: Self) -> Self
    static func += (left: inout Self, right: Self)
    static func += (left: inout Self, right: Alphabet.Base)
    
}

protocol BioSequence: BioSequenceAlgebra, Collection, SimpleEncodable, ExpressibleByStringLiteral, Hashable {
    var tag: String? { get set }
    var units: [Alphabet.Base] { get set }
    
    static func single(_ unit: Alphabet.Base) -> Self
    
    init(units: [Alphabet.Base], bigIntValue: BigInt)
    init<S: Sequence>(sequence: S) where S.Element: CharConvertible
    
    // reference method from Collection to bypass the fact that protocols don't conform to themselves
    func index(_ i: Index, offsetBy: Int) -> Index
}

// MARK: Hashable + StringLiteral

extension BioSequence {
    public init(stringLiteral: String) {
        self.init(sequence: stringLiteral)
    }
    
    public var hashValue: Int {
        return self.bigIntValue.hashValue
    }
}

// MARK: Pattern

extension BioSequence {
    func hammingDistance<C: Collection>(_ collection: C) -> Int {
        return self[self.startIndex..<self.endIndex].hammingDistance(collection)
    }
}

// MARK: BigIntConvertible

extension BioSequence {
    typealias Element = Alphabet.Base
    typealias SubSequence = Slice<Self>

    public init<S: Sequence>(sequence: S) where S.Element: CharConvertible {
        self.init(units: [], bigIntValue: 0)

        for char in sequence {
            guard let element = Element(unit: char.charValue) else { continue }
            self += element
        }
    }
    
    init(bigInt: BigInt, length: Int) {
        self = bigInt.pattern(length: length)
    }
}

// MARK: BioSequenceAlgebra

extension BioSequence {
    public static func + (left: Self, right: Alphabet.Base) -> Self {
        var tmp = left
        tmp += right
        return tmp
    }

    public static func + (left: Alphabet.Base, right: Self) -> Self {
        return Self.single(left) + right
    }

    public static func + (left: Self, right: Self) -> Self {
        var tmp = left
        tmp += right
        return tmp
    }

    public static func += (left: inout Self, right: Self) {
        for unit in right.units {
            left += unit
        }
    }

    public static func += (left: inout Self, right: Alphabet.Base) {
        left.units.append(right)
        left.bigIntValue = Alphabet.Base.componentCount * left.bigIntValue + right.bigIntValue
    }
    
    public static func == (left: Self, right: Self) -> Bool {
        guard left.count == right.count else { return false }
        
        for i in 0..<left.count {
            let unit = left[i]

            if unit != right[i] {
                return false
            }
        }
        return true
    }
}

// Mark: Collection

extension BioSequence {
    public typealias Index = Int

    public var startIndex: Index {
        return self.units.startIndex
    }
    
    public var endIndex: Index {
        return self.units.endIndex
    }
    
    public var count: Int {
        return self.units.count
    }
    
    public func index(after i: Index) -> Index {
        return self.units.index(after: i)
    }
    
    public subscript(index: Index) -> Alphabet.Base {
        return self.units[index]
    }
    
    public func character(at index: Index) -> Character {
        return self[index].charValue
    }
}
