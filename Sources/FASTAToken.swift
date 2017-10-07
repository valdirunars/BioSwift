//
//  FASTAToken.swift
//  BioSwiftPackageDescription
//
//  Created by Þorvaldur Rúnarsson on 05/10/2017.
//

import Foundation

enum FASTAToken<T: BioSequence>: BioIOToken {
    typealias Base = T

    case comment(String)
    case tag(String)
    case sequence(T)
    
    static var commentMarker: String {
        return ";"
    }
    
    static var tagMarker: String {
        return ">"
    }

    static func parse(_ component: String) -> FASTAToken<T>? {
        if component.hasPrefix(commentMarker) {
            let start = component.index(component.startIndex, offsetBy: commentMarker.count)
            let value = String(component[start..<component.endIndex])

            return .comment(value)
        } else if component.hasPrefix(tagMarker) {
            let start = component.index(component.startIndex, offsetBy: tagMarker.count)
            let value = String(component[start..<component.endIndex])

            return .tag(value)
        } else {
            let sequence = T(sequence: component)
            guard !sequence.isEmpty else { return nil }
            return .sequence(sequence)
        }
    }
}
