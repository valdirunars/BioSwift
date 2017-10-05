//
//  Parser.swift
//  BioSwiftPackageDescription
//
//  Created by Þorvaldur Rúnarsson on 05/10/2017.
//

import Foundation

protocol Parser {
    associatedtype Token: BioIOToken
    
    init(contentsOfURL url: URL) throws
    init(string: String)
    init?(data: Data)
    
    func parse() throws -> [Token.Base]
}
