import Foundation

enum AoC2025: AoC {
    static var year: AoCYear { .year2025 }

    static func run() {
        assert(solveDay1Puzzle1(.test1) == 3)
        assert(solveDay1Puzzle1(.quest) == 1158)
        assert(solveDay1Puzzle2(.test1) == 6)
        assert(solveDay1Puzzle2(.quest) == 6860)
    }
}
