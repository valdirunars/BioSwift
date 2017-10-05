import Foundation
import BigInt

struct Utils {

    static func integerToPattern<T: BioSequence>(integer: BigInt, length: Int) -> T {

        guard length != 1 else {
            if let byteChar = integer.description.first,
                let byte = Byte("\(byteChar)"),
                let nuc = T.Element(rawValue: byte) {
                return T.single(nuc)
            } else {
                fatalError("Something went wrong")
            }
        }

        let prefixInt = integer / Nucleotide.componentCount
        let remainder = integer % Nucleotide.componentCount
        
        guard let decimal = remainder.description.first,
            let byte = Byte("\(decimal)"),
            let symbol = T.Element(rawValue: byte) else {
                fatalError("Failed to symbol from integer")
        }
        let nextLength: Int = length - 1
        let prefix: T = integerToPattern(integer: prefixInt, length: nextLength)
        
        return prefix + symbol
    }

    internal static func neighbors<T: BioSequence>(pattern: Slice<T>, maxDistance: UInt) -> [T] {
        guard maxDistance > 0 else { return [ T(sequence: pattern) ] }
        guard pattern.count > 1 else {
            return T.Alphabet.alphabet.map(T.single)
        }
        
        var neighborhood: [T] = []
        
        let cdrPattern = pattern[pattern.index(after: pattern.startIndex)..<pattern.endIndex]
        let cdr = neighbors(pattern: cdrPattern, maxDistance: maxDistance)
        
        for gen in cdr {
            let hamming = gen.hammingDistance(cdrPattern)
            if hamming < maxDistance {
                for element in T.Alphabet.alphabet {
                    neighborhood.append(element + gen)
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
