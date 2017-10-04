//
//  BioSequence.swift
//  BioSwift
//
//  Created by Þorvaldur Rúnarsson on 03/10/2017.
//

import Foundation
import BigInt

protocol BioSequenceAlgebra: BigIntConvertible, BigIntInitializable, Equatable {
    associatedtype Unit: CharConvertible, ByteRepresentable

    static func + (left: Self, right: Unit) -> Self
    static func + (left: Unit, right: Self) -> Self
    static func + (left: Self, right: Self) -> Self
    static func += (left: inout Self, right: Self)
    static func += (left: inout Self, right: Unit)
    
}

protocol BioSequence: BioSequenceAlgebra, Collection {
    var tag: String? { get set }
    var units: [Unit] { get set }
    
    static func single(_ unit: Unit) -> Self
    
    init(units: [Unit], bigIntValue: BigInt)
    init<S: Sequence>(sequence: S) where S.Element: CharConvertible
}

// MARK: BigIntConvertible

extension BioSequence {

    public init<S: Sequence>(sequence: S) where S.Element: CharConvertible {
        self.init(units: [], bigIntValue: 0)

        for element in sequence {
            guard let nuc = Unit(unit: element) else { continue }
            self += nuc
        }
    }
    
    init(bigInt: BigInt, length: Int) {
        self = bigInt.pattern(length: length)
    }
}

// MARK: BioSequenceAlgebra

extension BioSequence {
    public static func + (left: Self, right: Unit) -> Self {
        var tmp = left
        tmp += right
        return tmp
    }

    public static func + (left: Unit, right: Self) -> Self {
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

    public static func += (left: inout Self, right: Unit) {
        left.units.append(right)
        left.bigIntValue = Unit.componentCount * left.bigIntValue + right.bigIntValue
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
    public typealias Element = Unit

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
    
    public subscript(index: Index) -> Unit {
        return self.units[index]
    }
    
    public func character(at index: Index) -> Character {
        return self[index].charValue
    }
}
