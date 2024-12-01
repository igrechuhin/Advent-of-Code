enum AoC2024 {
    static func getInput(
        fileName: String,
        ext: String = "txt"
    ) -> String {
        Advent_of_Code.getInput(
            fileName: fileName,
            inDirectory: "Resources/2024",
            ext: ext
        )
    }
    
    static func run() {
        assert(solveDay1Puzzle1() == 1189304)
        assert(solveDay1Puzzle2() == 24349736)
    }
}
