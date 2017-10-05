<img src="./BioSwift.svg" width="100%" />

## Description
An attempt to start a Bioinformatics library written purely in Swift

## Features

- DNA & RNA Sequencing
    - [X] Pattern matching algorithms
    - [X] Reverse Compliment
    - [X] Transcription
    - [X] Translation (into `Protein`)
    - [ ] Ambiguous alphabet support
    - [ ] Probability matching
- Protein
    - [X] Pattern matching algorithms
    - [ ] Ambiguous alphabet support
    - [ ] Probability matching
- IO Support (e.g. support for file formats FASTA, FASTQ, EMBL etc.)
    - [X] FASTA
    - [ ] FASTQ
    - [ ] EMBL

## How To Use
This library is brand new with a lot of features missing, but it's not entirely useless

### Swift Package Manager

```swift
.Package(url: "https://github.com/valdirunars/BioSwift.git", majorVersion: 0)
```

### Sequencing

```swift
var genome: DNAGenome = "AGCTGCTTTGGCGCAATGATCGAGCTGCTTTGGCGCAATGATCGAGCTGCTTTGGCGCAATGATCGAGCTGCTTTGGCGCAATGATCG"
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

let genomes: [DNAGenome] = [
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
// RNAGenome("AGCAUGGGCCCAAACUUUCAUAAGCCGGAGCAAUGCC")
genome.transcribe()
// DNAGenome("AGCATGGGCCCAAACTTTCATAAGCCGGAGCAATGCC")

let protein: Protein = genome.translate()
// "MGPNFHKPEQ"

```

### Init sequences from FASTA file

```swift
let fastaURL = URL(string: "../genome.fasta")!
var fastaFileData = Data(contentsOf: fastaURL)

let genomes: [Genome]? = Genome.decode(fastaFileData)

let proteinFastaURL = URL(string: "../protein.fasta")!
fastaFileData = Data(contentsOf: proteinFastaURL)

let proteins: [Protein]? = Protein.decode(fastaFileData)
```

### Encode sequences to FASTA

```swift
let genome: Genome = "ACGT"
let data: Data? = genome.encode(.fasta)
```
