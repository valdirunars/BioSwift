<img src="./BioSwift.svg" width="100%" />

## Description
An attempt to start a Bioinformatics library written purely in Swift

## Features

- DNA & RNA Sequencing
    - [X] Pattern matching algorithms
    - [ ] Transcription
    - [ ] Translation (into `Protein`)
- IO Support (e.g. support for file formats FASTA, FASTQ, EMBL etc.)
    - [ ] FASTA
    - [ ] FASTQ
    - [ ] EMBL

## How To Use
This library is brand new with a lot of features missing, but it's not entirely useless


```swift
var genome: Genome = "AGCTGCTTTGGCGCAATGATCGAGCTGCTTTGGCGCAATGATCGAGCTGCTTTGGCGCAATGATCGAGCTGCTTTGGCGCAATGATCG"
!genome
// "TCGACGAAACCGCGTTACTAGCTCGACGAAACCGCGTTACTAGCTCGACGAAACCGCGTTACTAGCTCGACGAAACCGCGTTACTAGC"

genome.reverseComplement()
// "CGATCATTGCGCCAAAGCAGCTCGATCATTGCGCCAAAGCAGCTCGATCATTGCGCCAAAGCAGCTCGATCATTGCGCCAAAGCAGCT"

genome.indicesOfMinimalSkew(increment: .a, decrement: .t)
// [ 74, 75, 76, 77, 78, 79 ]

genome.mostFrequentPattern(length: 2)
// "GC"

genome = "ACGTTGCATGTCGCATGATGCATGAGAGCT"
genome.mostFrequentPatterns(length: 4, maxDistance: 1)
// [ "GATG", "ATGC", "ATGT" ]

genome = "AGT"
genome.neighbors(maxDistance: 1)
// [ "AGT", "CGT", "TGT", "GGT", "ACT", "AAT", "ATT", "AGA", "AGC", "AGG" ]

let genomes: [Genome] = [
    "CTTTTAGTGGTATTAAGGGTGCCCA",
    "ATTCTAGCCCTATAAGCAATCACTC",
    "GAATGAATATACTCTGACAATATCA",
    "GCTTGCCGGGATTCACACACTATGA",
    "CTGTGTATTAGACGAACTTAAGTCC",
    "CAATATGAGCGTTAGGGAGCTATAA",
    "CGTAGTATGAAAGCGCTCCCTTCCT",
    "ACATTTATAAGGAGTATGGCAGTAG",
    "ATGAGACTCGCACTCTATGATGGCC",
    "ATGGATGCAATATTAGCGGCTAAAT"
]
genomes.motifs(length: 5, maxDistance: 1)
// [ "ATTAT", "TATAA", "TATCA", "TATGA", "TATTA" ]

genome = "AGCATGGGCCCAAACTTTCATAAGCCGGAGCAATGCC"

genome.transcribe()
// "AGCAUGGGCCCAAACUUUCAUAAGCCGGAGCAAUGCC"
genome.transcribe()
// "AGCATGGGCCCAAACTTTCATAAGCCGGAGCAATGCC"

let protein = genome.translate()
// "MGPNFHKPEQ"
protein.translate()
// "AGCATGGGCCCAAACTTTCATAAGCCGGAGCAATGCC"
```
