//
//  BioIOToken.swift
//  BioSwiftPackageDescription
//
//  Created by Þorvaldur Rúnarsson on 05/10/2017.
//

import Foundation

protocol BioIOToken {
    associatedtype Base
    
    static func parse(_ component: String) -> Self?
}
