import Foundation

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
        
        assert(solveDay4Puzzle1(.test1) == 18)
        assert(solveDay4Puzzle1(.quest) == 2578)
        assert(solveDay4Puzzle2(.test1) == 9)
        assert(solveDay4Puzzle2(.quest) == 1972)
        
        assert(solveDay5Puzzle1(.test1) == 143)
        assert(solveDay5Puzzle1(.quest) == 6034)
        assert(solveDay5Puzzle2(.test1) == 123)
        assert(solveDay5Puzzle2(.quest) == 6305)
        
        assert(solveDay6Puzzle1(.test1) == 41)
        assert(solveDay6Puzzle1(.quest) == 4883)
        assert(solveDay6Puzzle2(.test1) == 6)
        assert(solveDay6Puzzle2(.quest) == 1655) // ~ 18 sec in debug build
        
        assert(solveDay7Puzzle1(.test1) == 3749)
        assert(solveDay7Puzzle1(.quest) == 932137732557)
        
        assert(solveDay7Puzzle2(.test1) == 11387)
        assert(solveDay7Puzzle2(.quest) == 661823605105500) // ~ 13 sec in debug build
        
        assert(solveDay8Puzzle1(.test1) == 14)
        assert(solveDay8Puzzle1(.quest) == 261)
        assert(solveDay8Puzzle2(.test2) == 9)
        assert(solveDay8Puzzle2(.test1) == 34)
        assert(solveDay8Puzzle2(.quest) == 898)
        
        assert(solveDay9Puzzle1(.test1) == 1928)
        assert(solveDay9Puzzle1(.quest) == 6337921897505)
        assert(solveDay9Puzzle2(.test1) == 2858)
        assert(solveDay9Puzzle2(.quest) == 6362722604045)
    }
}
