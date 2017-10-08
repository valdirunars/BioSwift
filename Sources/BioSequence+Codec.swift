//
//  BioSequence+Codec.swift
//  BioSwift
//
//  Created by Þorvaldur Rúnarsson on 27/09/2017.
//

import Foundation
import BigInt
import BigIntCompress

public enum Compressor {
    /// What's this? see on [github](https://github.com/valdirunars/bigintcompress)
    case bigIntCompress
}

public enum Codec {
    case fasta
}

public protocol SimpleEncodable {
    var parsingSeperator: String { get }
    func parse(_ type: Codec) -> String?
    func encode(_ type: Codec) -> Data?
}

public protocol SimpleDecodable {
    func decode(data: Data, type: Codec) throws -> [Self]?
}

extension SimpleEncodable {
    public func encode(_ type: Codec) -> Data? {
        return self.parse(type)?.data(using: .ascii)!
    }
}

extension BioSequence {
    public var parsingSeperator: String { return "\n" }
    
    public func parse(_ type: Codec) -> String? {
        guard self.isEmpty == false else { return nil }
        
        switch type {
        case .fasta:
            return ">\(self.tag ?? "")\n\(self.description)"
        }
    }

    public static func decode(data: Data, type: Codec) throws -> [Self]? {
        switch type {
        case .fasta:
            return try FASTAParser<Self>(data: data)?.parse()
        }
    }
}

extension Sequence where Element: SimpleEncodable {
    public func encode(_ type: Codec) -> Data? {
        switch type {
        case .fasta:
            var parsedString = ""
            for component in self {
                guard let parsedComponent = component.parse(type) else {
                    return nil
                }
                parsedString += "\(parsedComponent)\(component.parsingSeperator)"
            }
            return parsedString.data(using: .ascii)
        }
    }
}

// MARK: Compressable

extension BigInt: BigIntType {
    public var hexString: String {
        return String(self, radix: 16)
    }
    
    public init<T>(_ value: T) where T : Numeric {
        self.init(value)
    }
    
    public init?(hexString: String) {
        self.init(hexString, radix: 16)
    }
}

extension Genome {
    
    public typealias CompressionNumber = BigInt

    public static var possibleComponents: [Nucleotide] {
        return DNAGenome.Alphabet.alphabet
    }
}

extension Protein: Compressable {
    public typealias CompressionNumber = BigInt
    
    public static var possibleComponents: [AminoAcid] {
        return Protein.Alphabet.alphabet
    }
}

// MARK: Convenience methods

extension Protein {
    public func compress(_ type: Compressor) -> Data? {
        switch type {
        case .bigIntCompress:
            return self.bic.encode()
        }
    }
    
    public static func decompress(data: Data, type: Compressor) throws -> Protein? {
        switch type {
        case .bigIntCompress:
            return try Protein.bic.decode(data)
        }
    }
}

extension Genome {
    public func compress(_ type: Compressor) -> Data? {
        switch type {
        case .bigIntCompress:
            return self.bic.encode()
        }
    }
    
    public static func decompress(data: Data, type: Compressor) throws -> Self? {
        switch type {
        case .bigIntCompress:
            return try Self.bic.decode(data)
        }
    }
}

