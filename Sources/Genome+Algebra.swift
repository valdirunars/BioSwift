//
//  Genome+Algebra.swift
//  BioSwift
//
//  Created by Þorvaldur Rúnarsson on 27/09/2017.
//

import Foundation
import BigInt

extension Genome {
    public static func + (left: Genome, right: Nucleotide) -> Genome {
        var tmp = left
        tmp += right
        return tmp
    }
    
    public static func + (left: Nucleotide, right: Genome) -> Genome {
        return Genome.single(left) + right
    }
    
    public static func + (left: Genome, right: Genome) -> Genome {
        var tmp = left
        tmp += right
        return tmp
    }
    
    public static func += (left: inout Genome, right: Genome) {
        for nuc in right {
            left += nuc
        }
    }
    
    public static func += (left: inout Genome, right: Nucleotide) {
        left.nucleotides.append(right)
        left.bigIntValue = Nucleotide.componentCount * left.bigIntValue + right.bigIntValue
    }
}
