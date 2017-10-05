//
//  Nucleotide.swift
//  BioSwift
//
//  Created by Þorvaldur Rúnarsson on 24/09/2017.
//

import Foundation
import BigInt

public enum Nucleotide: Byte, ByteRepresentable, Equatable {
    
    case a = 0 // adenine
    case c = 1 // cytosine
    case g = 2 // guanine
    case t = 3 // thymine
    case u = 4 // uracil

    public static prefix func ! (nucleotide: Nucleotide) -> Nucleotide {
        switch nucleotide {
        case .a:
            return .t
        case .c:
            return .g
        case .g:
            return .c
        case .t:
            return .a
        case .u:
            return .a
        }
    }
}
