//
//  BioSequence+Codec.swift
//  BioSwift
//
//  Created by Þorvaldur Rúnarsson on 27/09/2017.
//

import Foundation
import BigInt

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
