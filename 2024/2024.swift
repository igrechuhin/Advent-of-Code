enum AoC2024: AoC {    
    static var year: AoCYear { .year2024 }

    static func run() {
        assert(solveDay1Puzzle1() == 1189304)
        assert(solveDay1Puzzle2() == 24349736)
        
        assert(solveDay2Puzzle1() == 359)
        assert(solveDay2Puzzle2() == 418)
    }
}
