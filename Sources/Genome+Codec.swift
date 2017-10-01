//
//  Genome+SimpleEncodable.swift
//  BioSwift
//
//  Created by Þorvaldur Rúnarsson on 27/09/2017.
//

import Foundation
import BigInt

protocol SimpleEncodable {
    func encode() -> Data?
}

protocol SimpleDecodable {
    static func decode(data: Data) -> Self?
}

extension Genome: SimpleEncodable, SimpleDecodable {
    func encode() -> Data? {
        guard self.isEmpty == false else { return nil }
        return "\(self.count)-\(self.bigIntValue.description)".data(using: .ascii)!
    }
    
    static func decode(data: Data) -> Genome? {
        guard let string = String(data: data, encoding: .ascii) else { return nil }
        let array = string.split(separator: "-")

        guard array.count == 2,
            let count = Int(array[0]) else { return nil }

        let integer = BigInt(stringLiteral: String(array[1]))
        return Genome.init(bigInt: integer, length: count)
    }
}
