//
//  Genome+StringLiteral.swift
//  BioSwiftPackageDescription
//
//  Created by Þorvaldur Rúnarsson on 01/10/2017.
//

import Foundation

extension Genome: ExpressibleByStringLiteral {
    public init(stringLiteral: String) {
        self.init(sequence: stringLiteral)
    }
}
