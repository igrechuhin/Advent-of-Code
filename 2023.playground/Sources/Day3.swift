import Foundation

private func getDay3Input() -> String {
    //"""
    //467..114..
    //...*......
    //..35..633.
    //......#...
    //617*......
    //.....+.58.
    //..592.....
    //......755.
    //...$.*....
    //.664.598..
    //"""
    
    //"""
    //....1.....225...73...................472.......................-....*......920..999.......646..771.433......407..405.....*.......426*.......
    //.....*....*........./227..-113........@...825/.....348...881......603...........%....793...=............235*..............472.........82.941
    //..360..432..997....................................*.....=............62...702......*..............................273..................*...
    //"""
    
    getInput(fileName: "Day3Input")
}

// --- Day 3: Gear Ratios ---
// You and the Elf eventually reach a gondola lift station; he says the gondola lift will take you up to the water source, but this is as far as he can bring you. You go inside.
//
// It doesn't take long to find the gondolas, but there seems to be a problem: they're not moving.
//
// "Aaah!"
//
// You turn around to see a slightly-greasy Elf with a wrench and a look of surprise. "Sorry, I wasn't expecting anyone! The gondola lift isn't working right now; it'll still be a while before I can fix it." You offer to help.
//
// The engineer explains that an engine part seems to be missing from the engine, but nobody can figure out which one. If you can add up all the part numbers in the engine schematic, it should be easy to work out which part is missing.
//
// The engine schematic (your puzzle input) consists of a visual representation of the engine. There are lots of numbers and symbols you don't really understand, but apparently any number adjacent to a symbol, even diagonally, is a "part number" and should be included in your sum. (Periods (.) do not count as a symbol.)
//
// Here is an example engine schematic:
//
// 467..114..
// ...*......
// ..35..633.
// ......#...
// 617*......
// .....+.58.
// ..592.....
// ......755.
// ...$.*....
// .664.598..
//
// In this schematic, two numbers are not part numbers because they are not adjacent to a symbol: 114 (top right) and 58 (middle right). Every other number is adjacent to a symbol and so is a part number; their sum is 4361.
//
// Of course, the actual engine schematic is much larger. What is the sum of all of the part numbers in the engine schematic?
//
// Your puzzle answer was 529618.

private extension Character {
    var isSymbol: Bool {
        !(isNumber || self == ".")
    }
    
    var isAsterix: Bool {
        self == "*"
    }
}

private extension Character? {
    var isSymbol: Bool {
        switch self {
        case .none:
            return false
        case let .some(wrapped):
            return wrapped.isSymbol
        }
    }
    
    var isAsterix: Bool {
        switch self {
        case .none:
            return false
        case let .some(wrapped):
            return wrapped.isAsterix
        }
    }
}

private struct Point: Hashable {
    let x: Int
    let y: Int
}

private struct Number {
    let value: Int
    let symbolPoints: Set<Point>
}

private extension [[Character]] {
    func getPartNumbers(isSymbol: (Character?) -> Bool) -> [Number] {
        var partNumbers: [Number] = []
        
        for lineIndex in self.indices {
            let pLine = self[safe: lineIndex - 1]
            let cLine = self[lineIndex]
            let nLine = self[safe: lineIndex + 1]
            
            var valueStr = ""
            var symbolPoints = Set<Point>()
            for (chIndex, ch) in cLine.enumerated() {
                if ch.isNumber {
                    valueStr.append(ch)
                    if isSymbol(cLine[safe: chIndex - 1]) {
                        symbolPoints.insert(Point(x: chIndex - 1, y: lineIndex))
                    }
                    if isSymbol(cLine[safe: chIndex + 1]) {
                        symbolPoints.insert(Point(x: chIndex + 1, y: lineIndex))
                    }
                    if let pLine {
                        if isSymbol(pLine[safe: chIndex - 1]) {
                            symbolPoints.insert(Point(x: chIndex - 1, y: lineIndex - 1))
                        }
                        if isSymbol(pLine[safe: chIndex]) {
                            symbolPoints.insert(Point(x: chIndex, y: lineIndex - 1))
                        }
                        if isSymbol(pLine[safe: chIndex + 1]) {
                            symbolPoints.insert(Point(x: chIndex + 1, y: lineIndex - 1))
                        }
                    }
                    if let nLine {
                        if isSymbol(nLine[safe: chIndex - 1]) {
                            symbolPoints.insert(Point(x: chIndex - 1, y: lineIndex + 1))
                        }
                        if isSymbol(nLine[safe: chIndex]) {
                            symbolPoints.insert(Point(x: chIndex, y: lineIndex + 1))
                        }
                        if isSymbol(nLine[safe: chIndex + 1]) {
                            symbolPoints.insert(Point(x: chIndex + 1, y: lineIndex + 1))
                        }
                    }
                } else {
                    if !symbolPoints.isEmpty {
                        partNumbers.append(
                            Number(
                                value: Int(valueStr)!,
                                symbolPoints: symbolPoints
                            )
                        )
                    }
                    
                    valueStr = ""
                    symbolPoints.removeAll()
                }
            }
            if !symbolPoints.isEmpty {
                partNumbers.append(
                    Number(
                        value: Int(valueStr)!,
                        symbolPoints: symbolPoints
                    )
                )
            }
        }
        
        return partNumbers
    }
}

public func solveDay3Puzzle1() -> Int {
    getDay3Input()
        .as2DArray
        .getPartNumbers { $0.isSymbol }
        .map { $0.value }
        .sum
}

// --- Part Two ---
// The engineer finds the missing part and installs it in the engine! As the engine springs to life, you jump in the closest gondola, finally ready to ascend to the water source.
//
// You don't seem to be going very fast, though. Maybe something is still wrong? Fortunately, the gondola has a phone labeled "help", so you pick it up and the engineer answers.
//
// Before you can explain the situation, she suggests that you look out the window. There stands the engineer, holding a phone in one hand and waving with the other. You're going so slowly that you haven't even left the station. You exit the gondola.
//
// The missing part wasn't the only issue - one of the gears in the engine is wrong. A gear is any * symbol that is adjacent to exactly two part numbers. Its gear ratio is the result of multiplying those two numbers together.
//
// This time, you need to find the gear ratio of every gear and add them all up so that the engineer can figure out which gear needs to be replaced.
//
// Consider the same engine schematic again:
//
// 467..114..
// ...*......
// ..35..633.
// ......#...
// 617*......
// .....+.58.
// ..592.....
// ......755.
// ...$.*....
// .664.598..
//
// In this schematic, there are two gears. The first is in the top left; it has part numbers 467 and 35, so its gear ratio is 16345. The second gear is in the lower right; its gear ratio is 451490. (The * adjacent to 617 is not a gear because it is only adjacent to one part number.) Adding up all of the gear ratios produces 467835.
//
// What is the sum of all of the gear ratios in your engine schematic?
//
// Your puzzle answer was 77509019.

public func solveDay3Puzzle2() -> Int {
    let partNumbers = getDay3Input()
        .components(separatedBy: .newlines)
        .map { Array($0) }
        .getPartNumbers { $0.isAsterix }

    var adjacentPartNumbers: [Point: [Int]] = [:]
    for number in partNumbers {
        for asterixPoint in number.symbolPoints {
            adjacentPartNumbers[asterixPoint, default: []].append(number.value)
        }
    }

    return adjacentPartNumbers
        .values
        .filter { $0.count == 2 }
        .map { $0[0] * $0[1] }
        .sum
}
