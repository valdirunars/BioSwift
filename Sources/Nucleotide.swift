import Foundation

enum Nucleotide: String, Equatable {
    case a = "A"
    case c = "C"
    case g = "G"
    case t = "T"

    static prefix func !(nucleotide: Nucleotide) -> Nucleotide {
        switch nucleotide {
        case .a:
            return .t
        case .c:
            return .g
        case .g:
            return .c
        case .t:
            return .a
        }
    }

    static func ==(left: Nucleotide, right: Nucleotide) -> Bool {
        return left.rawValue == right.rawValue
    }
}
