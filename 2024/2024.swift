enum AoC2024: AoC {    
    static var year: AoCYear { .year2024 }

    static func run() {
        assert(solveDay1Puzzle1(.test1) == 11)
        assert(solveDay1Puzzle2(.test1) == 31)
        assert(solveDay1Puzzle1(.quest) == 1189304)
        assert(solveDay1Puzzle2(.quest) == 24349736)

        assert(solveDay2Puzzle1(.test1) == 2)
        assert(solveDay2Puzzle2(.test1) == 4)
        assert(solveDay2Puzzle1(.quest) == 359)
        assert(solveDay2Puzzle2(.quest) == 418)
        
        assert(solveDay3Puzzle1(.test1) == 161)
        assert(solveDay3Puzzle2(.test2) == 48)
        assert(solveDay3Puzzle1(.quest) == 174336360)
        assert(solveDay3Puzzle2(.quest) == 88802350)
    }
}
