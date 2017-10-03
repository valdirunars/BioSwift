//
//  GenomeType.swift
//  BioSwiftPackageDescription
//
//  Created by Þorvaldur Rúnarsson on 03/10/2017.
//

import Foundation

public enum GenomeType {
    case dna
    case rna
}

extension GenomeType: Equatable {
    public static func == (left: GenomeType, right: GenomeType) -> Bool {
        switch (left, right) {
        case (.dna, .dna),
             (.rna, rna):
            return true
        default:
            return false
        }
    }
}

