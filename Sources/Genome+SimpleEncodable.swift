//
//  Genome+SimpleEncodable.swift
//  BioSwift
//
//  Created by Þorvaldur Rúnarsson on 27/09/2017.
//

import Foundation

protocol SimpleEncodable {
    func encode() -> Data
}

extension Genome: SimpleEncodable {
    func encode() -> Data {
        return self.asInteger().description.data(using: .utf8)!
    }
}
