import Foundation
import BigInt

struct Utils {
    static func patternToInteger(pattern: Slice<Genome>) -> BigInt {
        guard pattern.isEmpty == false else { return 0 }

        let prefix = pattern[pattern.startIndex..<(pattern.endIndex-1)]
        let lastIndex = pattern.index(pattern.startIndex, offsetBy: pattern.count - 1)
        
        return (BigInt(integerLiteral: 4) * patternToInteger(pattern: prefix)) + BigInt(integerLiteral: Int64(pattern[lastIndex].rawValue))
    }
    
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
        let four = BigInt(integerLiteral: 4)

        let prefixInt = integer / four
        let remainder = integer % four
        
        guard let decimal = remainder.description.first,
            let byte = UInt8("\(decimal)"),
            let symbol = Nucleotide(rawValue: byte) else {
                fatalError("Failed to symbol from integer")
        }
        
        let prefix = integerToPattern(integer: prefixInt, length: length - 1)
        
        return prefix + symbol
    }

    static func neighbors(pattern: Slice<Genome>, maxDistance: UInt) -> [Genome] {
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
