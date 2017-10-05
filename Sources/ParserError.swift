//
//  ParserError.swift
//  BioSwiftPackageDescription
//
//  Created by Þorvaldur Rúnarsson on 05/10/2017.
//

import Foundation

protocol ParserError: Error {}

enum FASTAError: ParserError {
    case missingTagForSequences
}
