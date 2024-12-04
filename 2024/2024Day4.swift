import Foundation

extension AoC2024 {
    private static func getPuzzleInput(mode: AoCMode) -> String {
        getInput(day: .day4, mode: mode)
    }

    // --- Day 4: Ceres Search ---
    // "Looks like the Chief's not here. Next!" One of The Historians pulls out a device and pushes the only button on it. After a brief flash, you recognize the interior of the Ceres monitoring station!

    // As the search for the Chief continues, a small Elf who lives on the station tugs on your shirt; she'd like to know if you could help her with her word search (your puzzle input). She only has to find one word: XMAS.

    // This word search allows words to be horizontal, vertical, diagonal, written backwards, or even overlapping other words. It's a little unusual, though, as you don't merely need to find one instance of XMAS - you need to find all of them. Here are a few ways XMAS might appear, where irrelevant characters have been replaced with .:


    // ..X...
    // .SAMX.
    // .A..A.
    // XMAS.S
    // .X....
    // The actual word search will be full of letters instead. For example:

    // MMMSXXMASM
    // MSAMXMSMSA
    // AMXSXMAAMM
    // MSAMASMSMX
    // XMASAMXAMM
    // XXAMMXXAMA
    // SMSMSASXSS
    // SAXAMASAAA
    // MAMMMXMMMM
    // MXMXAXMASX
    // In this word search, XMAS occurs a total of 18 times; here's the same word search again, but where letters not involved in any XMAS have been replaced with .:

    // ....XXMAS.
    // .SAMXMS...
    // ...S..A...
    // ..A.A.MS.X
    // XMASAMX.MM
    // X.....XA.A
    // S.S.S.S.SS
    // .A.A.A.A.A
    // ..M.M.M.MM
    // .X.X.XMASX
    // Take a look at the little Elf's word search. How many times does XMAS appear?

    // Your puzzle answer was 2578.

    static func solveDay4Puzzle1(_ mode: AoCMode) -> Int {
        getPuzzleInput(mode: mode)
            .as2DArray
            .xmasMatchesCount1
    }

    // --- Part Two ---
    // The Elf looks quizzically at you. Did you misunderstand the assignment?

    // Looking for the instructions, you flip over the word search to find that this isn't actually an XMAS puzzle; it's an X-MAS puzzle in which you're supposed to find two MAS in the shape of an X. One way to achieve that is like this:

    // M.S
    // .A.
    // M.S
    // Irrelevant characters have again been replaced with . in the above diagram. Within the X, each MAS can be written forwards or backwards.

    // Here's the same example from before, but this time all of the X-MASes have been kept instead:

    // .M.S......
    // ..A..MSMS.
    // .M.S.MAA..
    // ..A.ASMSM.
    // .M.S.M....
    // ..........
    // S.S.S.S.S.
    // .A.A.A.A..
    // M.M.M.M.M.
    // ..........
    // In this example, an X-MAS appears 9 times.

    // Flip the word search from the instructions back over to the word search side and try again. How many times does an X-MAS appear?

    // Your puzzle answer was 1972.

    static func solveDay4Puzzle2(_ mode: AoCMode) -> Int {
        getPuzzleInput(mode: mode)
            .as2DArray
            .xmasMatchesCount2
    }
}

private extension [[Character]] {
    var xmasMatchesCount1: Int {
        var result = 0
        
        for y in indices {
            for x in self[y].indices {
                for direction in lookupDirections {
                    if isXMASMatch(
                        point: Point2D(y: y, x: x),
                        direction: direction
                    ) {
                        result += 1
                    }
                }
            }
        }
        
        return result
    }
    
    private func isXMASMatch(point: Point2D, direction: Point2D) -> Bool {
        let pattern = "XMAS"
        var checkPoint = point
        for i in pattern.indices {
            if self[safe: checkPoint] != pattern[i] {
                return false
            }
            checkPoint += direction
        }
        return true
    }

    var xmasMatchesCount2: Int {
        var result = 0

        for y in indices {
            for x in self[y].indices {
                if subArray(
                    from: Point2D(y: y, x: x),
                    to: Point2D(y: y + 2, x: x + 2)
                )?.isXMASMatch ?? false {
                    result += 1
                }
            }
        }
        
        return result
    }
    
    private var isXMASMatch: Bool {
        guard count == 3, self[0].count == 3 else { return false }
        
        let diagonal1 = String([self[0][0], self[1][1], self[2][2]])
        let diagonal2 = String([self[0][2], self[1][1], self[2][0]])
                                                      
        return masMatches.contains(diagonal1) && masMatches.contains(diagonal2)
    }
}

private let lookupDirections: [Point2D] = [
    Point2D(y: -1, x: 0),
    Point2D(y: 0, x: -1),
    Point2D(y: 1, x: 0),
    Point2D(y: 0, x: 1),
    
    Point2D(y: -1, x: -1),
    Point2D(y: -1, x: 1),
    Point2D(y: 1, x: -1),
    Point2D(y: 1, x: 1)
]

private let masMatches = Set(["MAS", "SAM"])
