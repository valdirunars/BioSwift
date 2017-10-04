//
//  Protein.swift
//  BioSwiftPackageDescription
//
//  Created by Þorvaldur Rúnarsson on 03/10/2017.
//

import Foundation
import BigInt

public struct Protein {    
    public internal(set) var tag: String? = nil
    public internal(set) var units: [AminoAcid]
    public internal(set) var bigIntValue: BigInt
}
