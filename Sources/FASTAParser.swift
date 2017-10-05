//
//  FASTAParser.swift
//  BioSwiftPackageDescription
//
//  Created by Þorvaldur Rúnarsson on 05/10/2017.
//

import Foundation

struct FASTAParser<T: BioSequence>: Parser {
    
    typealias Token = FASTAToken<T>

    static var componentSeperator: Character {
        return "\n"
    }
    
    let components: [String]
    
    init(contentsOfURL url: URL) throws {
        let string = try String(contentsOf: url)
        self.init(string: string)
    }
    
    init(string: String) {
        self.components = string.split(separator: FASTAParser<T>.componentSeperator)
            .map(String.init)
    }
    
    init?(data: Data) {
        guard let string = String(data: data, encoding: .ascii) else {
            return nil
        }
        self.init(string: string)
    }
    
    func parse() throws -> [T] {
        let initial: [[Any]] = [ [], [] ]
        let final = components.map(Token.parse)
            .reduce(initial) { (result, token) -> [[Any]] in
                var tmp = result
                if let token = token {
                    switch token {
                    case .comment(let comment):
                        print("Reading comment from FASTA: \(comment)")
                    case .tag(let description):
                        tmp[0].append(description)
                    case .sequence(let sequence):
                        tmp[1].append(sequence)
                    }
                }
                return tmp
            }
        let tags = final[0]
        let sequences = final[1]

        guard tags.count == sequences.count else {
            throw FASTAError.missingTagForSequences
        }
        return zip(tags, sequences).reduce([]) { (result, tuple) -> [T] in
            var tmp = result

            guard let tag = tuple.0 as? String else {
                fatalError("Tags are supposed to be Strings")
            }
            
            guard var sequence = tuple.0 as? T else {
                fatalError("Sequences are supposed to be \(T.self)s")
            }
            
            sequence.tag = tag
            tmp.append(sequence)
            return tmp
        }
    }
}
