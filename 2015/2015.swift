enum AoC2015 {
    static func getInput(
        fileName: String,
        ext: String = "txt"
    ) -> String {
        Advent_of_Code.getInput(
            fileName: fileName,
            inDirectory: "Resources/2015",
            ext: ext
        )
    }
    
    static func run() {
        assert(solveDay1Puzzle1() == 280)
        assert(solveDay1Puzzle2() == 1_797)

        assert(solveDay2Puzzle1() == 1_606_483)
        assert(solveDay2Puzzle2() == 3_842_356)

        assert(solveDay3Puzzle1() == 2_081)
        assert(solveDay3Puzzle2() == 2_341)
    }
}
