import Foundation

struct Utils {
    static func patternToInteger(pattern: Slice<Genome>) -> Int {
        guard pattern.count > 0 else { return -1 }
        guard pattern.count != 1 else { return Int(pattern.first?.rawValue ?? 0 * 4) }
        let prefix = pattern[pattern.startIndex..<(pattern.endIndex-1)]
        let lastIndex = pattern.index(pattern.startIndex, offsetBy: pattern.count - 1)
        
        return 4 * patternToInteger(pattern: prefix) + Int(pattern[lastIndex].rawValue)
    }
}
