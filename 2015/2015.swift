enum AoC2015: AoC {
    static var year: AoCYear { .year2015 }

    static func run() {
        assert(solveDay1Puzzle1() == 280)
        assert(solveDay1Puzzle2() == 1_797)

        assert(solveDay2Puzzle1() == 1_606_483)
        assert(solveDay2Puzzle2() == 3_842_356)

        assert(solveDay3Puzzle1() == 2_081)
        assert(solveDay3Puzzle2() == 2_341)
        
        assert(solveDay4Puzzle1(.test1) == 609043)
        assert(solveDay4Puzzle1(.test2) == 1048970)
        assert(solveDay4Puzzle1(.quest) == 117946)
        assert(solveDay4Puzzle2(.quest) == 3938038)
        
        assert(solveDay5Puzzle1(.test1) == 2)
        assert(solveDay5Puzzle1(.quest) == 238)
        assert(solveDay5Puzzle2(.test2) == 2)
        assert(solveDay5Puzzle2(.quest) == 69)
        
        assert(solveDay6Puzzle1(.quest) == 569999)
        assert(solveDay6Puzzle2(.quest) == 17836115)
    }
}
