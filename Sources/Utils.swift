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
    
    static func integerToPattern<T: BioSequence>(integer: BigInt, length: Int) -> T {

        guard length != 1 else {
            if let byteChar = integer.description.first,
                let byte = Byte("\(byteChar)"),
                let nuc = T.Unit(rawValue: byte) {
                return T.single(nuc)
            } else {
                fatalError("Something went wrong")
            }
        }

        let prefixInt = integer / Nucleotide.componentCount
        let remainder = integer % Nucleotide.componentCount
        
        guard let decimal = remainder.description.first,
            let byte = Byte("\(decimal)"),
            let symbol = T.Unit(rawValue: byte) else {
                fatalError("Failed to symbol from integer")
        }
        let nextLength: Int = length - 1
        let prefix: T = integerToPattern(integer: prefixInt, length: nextLength)
        
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
    
    internal static func decode<T: BioSequence>(fasta: Data) -> [T]? {
        guard let string = String(data: fasta, encoding: .ascii) else { return nil }
        let components = string.components(separatedBy: "\n")
        
        var tags: [String] = []
        var sequences: [String] = []
        
        var nextTag = true
        for component in components {
            if nextTag {
                let tag = component.stringByRemovingWhitespaceInFront()
                tags.append(tag)
            } else {
                sequences.append(component.trimmingCharacters(in: .whitespaces))
            }
            nextTag = !nextTag
        }
        guard tags.count == sequences.count else {
            assertionFailure("Invalid FASTA file")
            return nil
        }
        
        return zip(tags, sequences)
            .map { tuple -> T in
                var bioSeq = T(sequence: tuple.1)
                bioSeq.tag = tuple.0
                return bioSeq
            }
            .reduce([]) { result, bioSeq -> [T]? in
                var tmp = result
                tmp?.append(bioSeq)
                return tmp
        }
    }
}
