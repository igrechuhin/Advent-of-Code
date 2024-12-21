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
        
        assert(solveDay10Puzzle1(.test1) == 36)
        assert(solveDay10Puzzle1(.quest) == 822)
        assert(solveDay10Puzzle2(.test1) == 81)
        assert(solveDay10Puzzle2(.quest) == 1801)
        
        assert(solveDay11Puzzle1(.test2) == 55312)
        assert(solveDay11Puzzle1(.quest) == 203609)
        assert(solveDay11Puzzle2(.quest) == 240954878211138)
        
        assert(solveDay12Puzzle1(.test1) == 140)
        assert(solveDay12Puzzle1(.test2) == 772)
        assert(solveDay12Puzzle1(.quest) == 1352976)
        assert(solveDay12Puzzle2(.test1) == 80)
        assert(solveDay12Puzzle2(.test2) == 436)
        assert(solveDay12Puzzle2(.quest) == 808796)
        
        assert(solveDay13Puzzle1(.test1) == 480)
        assert(solveDay13Puzzle1(.quest) == 36758)
        assert(solveDay13Puzzle2(.test1) == 875318608908)
        assert(solveDay13Puzzle2(.quest) == 76358113886726)
        
        assert(solveDay14Puzzle1(.test1) == 12)
        assert(solveDay14Puzzle1(.quest) == 228457125)
        assert(solveDay14Puzzle2(.quest) == 6493)
        
        assert(solveDay15Puzzle1(.test1) == 2028)
        assert(solveDay15Puzzle1(.test2) == 10092)
        assert(solveDay15Puzzle1(.quest) == 1318523)
        assert(solveDay15Puzzle2(.test1) == 1751)
        assert(solveDay15Puzzle2(.test2) == 9021)
        assert(solveDay15Puzzle2(.quest) == 1337648)
        
        assert(solveDay16Puzzle1(.test1) == 7036)
        assert(solveDay16Puzzle1(.test2) == 11048)
        assert(solveDay16Puzzle1(.quest) == 82460)
        assert(solveDay16Puzzle2(.test1) == 45)
        assert(solveDay16Puzzle2(.test2) == 64)
        assert(solveDay16Puzzle2(.quest) == 590)
        
        assert(solveDay17Puzzle1(.test1) == "4,6,3,5,6,3,5,2,1,0")
        assert(solveDay17Puzzle1(.quest) == "4,3,2,6,4,5,3,2,4")
        assert(solveDay17Puzzle2(.test2) == 117440)
        assert(solveDay17Puzzle2(.quest) == 164540892147389)
        
        assert(solveDay18Puzzle1(.test1) == 22)
        assert(solveDay18Puzzle1(.quest) == 298)
        assert(solveDay18Puzzle2(.test1) == "6,1")
        assert(solveDay18Puzzle2(.quest) == "52,32")
        
        assert(solveDay19Puzzle1(.test1) == 6)
        assert(solveDay19Puzzle1(.quest) == 333)
        assert(solveDay19Puzzle2(.test1) == 16)
        assert(solveDay19Puzzle2(.quest) == 678536865274732)
        
        assert(solveDay20Puzzle1(.test1) == 1)
        assert(solveDay20Puzzle1(.quest) == 1323)
        assert(solveDay20Puzzle2(.test1) == 129)
        assert(solveDay20Puzzle2(.quest) == 983905)
        
        assert(solveDay21Puzzle1(.test1) == 126384)
        assert(solveDay21Puzzle1(.quest) == 212488)
        assert(solveDay21Puzzle2(.test1) == 154115708116294)
        assert(solveDay21Puzzle2(.quest) == 258263972600402)
    }
}
