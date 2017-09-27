//
//  Genome+SimpleEncodable.swift
//  BioSwift
//
//  Created by Þorvaldur Rúnarsson on 27/09/2017.
//

import Foundation

protocol SimpleEncodable {
    associatedtype S: Sequence where S.Element == Byte
    var bytes: S { get }
    func encode() -> Data
}

extension SimpleEncodable {
    func encode() -> Data {
        if let encoded = self.bytes as? Data {
            return encoded
        } else {
            return Data(self.bytes)
        }
    }
}

extension Genome: SimpleEncodable {
    var bytes: [Byte] {
        return self.map { $0.rawValue }
    }
}
