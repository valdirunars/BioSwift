import Foundation
import BigInt

struct Utils {
    
    internal static var codonTable: [Genome: String] = [
        "ATA":"I", "ATC":"I", "ATT":"I", "ATG":"M",
        "ACA":"T", "ACC":"T", "ACG":"T", "ACT":"T",
        "AAC":"N", "AAT":"N", "AAA":"K", "AAG":"K",
        "AGC":"S", "AGT":"S", "AGA":"R", "AGG":"R",
        "CTA":"L", "CTC":"L", "CTG":"L", "CTT":"L",
        "CCA":"P", "CCC":"P", "CCG":"P", "CCT":"P",
        "CAC":"H", "CAT":"H", "CAA":"Q", "CAG":"Q",
        "CGA":"R", "CGC":"R", "CGG":"R", "CGT":"R",
        "GTA":"V", "GTC":"V", "GTG":"V", "GTT":"V",
        "GCA":"A", "GCC":"A", "GCG":"A", "GCT":"A",
        "GAC":"D", "GAT":"D", "GAA":"E", "GAG":"E",
        "GGA":"G", "GGC":"G", "GGG":"G", "GGT":"G",
        "TCA":"S", "TCC":"S", "TCG":"S", "TCT":"S",
        "TTC":"F", "TTT":"F", "TTA":"L", "TTG":"L",
        "TAC":"Y", "TAT":"Y", "TAA":"_", "TAG":"_",
        "TGC":"C", "TGT":"C", "TGA":"_", "TGG":"W",
    ]
    
    static func integerToPattern(integer: BigInt, length: Int) -> Genome {

        guard length != 1 else {
            if let byteChar = integer.description.first,
                let byte = UInt8("\(byteChar)"),
                let nuc = Nucleotide(rawValue: byte) {
                return .single(nuc)
            } else {
                fatalError("Something went wrong")
            }
        }

        let prefixInt = integer / Nucleotide.componentCount
        let remainder = integer % Nucleotide.componentCount
        
        guard let decimal = remainder.description.first,
            let byte = UInt8("\(decimal)"),
            let symbol = Nucleotide(rawValue: byte) else {
                fatalError("Failed to symbol from integer")
        }
        
        let prefix = integerToPattern(integer: prefixInt, length: length - 1)
        
        return prefix + symbol
    }

    internal static func neighbors(pattern: Slice<Genome>, maxDistance: UInt) -> [Genome] {
        guard maxDistance > 0 else { return [ Genome(sequence: pattern) ] }
        guard pattern.count > 1 else {
            return [ .single(.a), .single(.g), .single(.c), .single(.t) ]
        }
        
        var neighborhood: [Genome] = []
        
        let cdrPattern = pattern[pattern.index(after: pattern.startIndex)..<pattern.endIndex]
        let cdr = neighbors(pattern: cdrPattern, maxDistance: maxDistance)
        
        for gen in cdr {
            let hamming = gen.hammingDistance(cdrPattern)
            if hamming < maxDistance {
                for nuc in Nucleotide.all {
                    neighborhood.append(nuc + gen)
                }
            } else {
                neighborhood.append(pattern.first! + gen)
            }
        }
        
        return neighborhood
    }
}
