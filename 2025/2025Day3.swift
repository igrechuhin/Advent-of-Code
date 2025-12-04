import Foundation

extension AoC2025 {
    private static func getPuzzleInput(mode: AoCMode) -> [[Int]] {
        getInput(day: .day3, mode: mode)
            .components(separatedBy: .newlines)
            .filter(\.isNotEmpty)
            .map { bank in
                bank.map { Int(String($0))! }
            }
    }

    static func solveDay3Puzzle1(_ mode: AoCMode) -> Int {
        let banks = getPuzzleInput(mode: mode)

        var sum = 0

        for bank in banks {
            let first = bank.dropLast().max()!
            let second = bank.dropFirst(bank.firstIndex(of: first)! + 1).max()!

            let value = (first * 10) + second

            sum += value
        }

        return sum
    }


    static func solveDay3Puzzle2(_ mode: AoCMode) -> Int {
        let banks = getPuzzleInput(mode: mode)

        var sum = 0

        let bulbsCount = 12
        for bank in banks {
            var bankSum = 0
            var leftIndex = 0
            for rightIndex in (0 ..< bulbsCount).reversed() {
                let scanRange = bank.dropFirst(leftIndex).dropLast(rightIndex)
                let bulb = scanRange.max()!

                leftIndex = scanRange.firstIndex(of: bulb)! + 1

                bankSum = (10 * bankSum) + bulb
            }
            sum += bankSum
        }

        return sum
    }
}

