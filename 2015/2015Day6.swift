import Foundation
import Collections

extension AoC2015 {
    private static func getPuzzleInput(mode: AoCMode) -> String {
        getInput(day: .day6, mode: mode)
    }

    // --- Day 6: Probably a Fire Hazard ---
    // Because your neighbors keep defeating you in the holiday house decorating contest year after year, you've decided to deploy one million lights in a 1000x1000 grid.

    // Furthermore, because you've been especially nice this year, Santa has mailed you instructions on how to display the ideal lighting configuration.

    // Lights in your grid are numbered from 0 to 999 in each direction; the lights at each corner are at 0,0, 0,999, 999,999, and 999,0. The instructions include whether to turn on, turn off, or toggle various inclusive ranges given as coordinate pairs. Each coordinate pair represents opposite corners of a rectangle, inclusive; a coordinate pair like 0,0 through 2,2 therefore refers to 9 lights in a 3x3 square. The lights all start turned off.

    // To defeat your neighbors this year, all you have to do is set up your lights by doing the instructions Santa sent you in order.

    // For example:

    // turn on 0,0 through 999,999 would turn on (or leave on) every light.
    // toggle 0,0 through 999,0 would toggle the first line of 1000 lights, turning off the ones that were on, and turning on the ones that were off.
    // turn off 499,499 through 500,500 would turn off (or leave off) the middle four lights.
    // After following the instructions, how many lights are lit?

    // Your puzzle answer was 569999.
    
    static func solveDay6Puzzle1(_ mode: AoCMode) -> Int {
        var lights = Array(
            repeating: BitArray(repeating: false, count: 1000),
            count: 1000
        )
        
        getPuzzleInput(mode: mode)
            .operations
            .forEach { $0.perform(lights: &lights) }
        return lights
            .map { $0.count { $0 } }
            .sum
    }
    
    // --- Part Two ---
    // You just finish implementing your winning light pattern when you realize you mistranslated Santa's message from Ancient Nordic Elvish.

    // The light grid you bought actually has individual brightness controls; each light can have a brightness of zero or more. The lights all start at zero.

    // The phrase turn on actually means that you should increase the brightness of those lights by 1.

    // The phrase turn off actually means that you should decrease the brightness of those lights by 1, to a minimum of zero.

    // The phrase toggle actually means that you should increase the brightness of those lights by 2.

    // What is the total brightness of all lights combined after following Santa's instructions?

    // For example:

    // turn on 0,0 through 0,0 would increase the total brightness by 1.
    // toggle 0,0 through 999,999 would increase the total brightness by 2000000.
    // Your puzzle answer was 17836115.

    static func solveDay6Puzzle2(_ mode: AoCMode) -> Int {
        var lights = Array(
            repeating: Array(repeating: 0, count: 1000),
            count: 1000
        )
        
        getPuzzleInput(mode: mode)
            .operations
            .forEach { $0.perform(lights: &lights) }
        return lights
            .map(\.sum)
            .sum
    }
}

private extension String {
    var operations: [Operation] {
        components(separatedBy: .newlines)
            .filter(\.isNotEmpty)
            .map { Operation($0) }
    }
}

private enum Operation {
    case turnOn(y: ClosedRange<Int>, x: ClosedRange<Int>)
    case turnOff(y: ClosedRange<Int>, x: ClosedRange<Int>)
    case toggle(y: ClosedRange<Int>, x: ClosedRange<Int>)
    
    init(_ line: String) {
        let prefixes = [
            "turn on ",
            "turn off ",
            "toggle "
        ]
        let prefix = prefixes.first(where: line.hasPrefix)!
        let values = line.dropFirst(prefix.count)
            .components(separatedBy: " through ")
        let part1 = values[0]
            .split(separator: ",")
            .compactMap { Int($0) }
        let part2 = values[1]
            .split(separator: ",")
            .compactMap { Int($0) }
        let yRange = min(part1[0], part2[0]) ... max(part1[0], part2[0])
        let xRange = min(part1[1], part2[1]) ... max(part1[1], part2[1])
        
        switch prefix {
        case "turn on ": self = .turnOn(y: yRange, x: xRange)
        case "turn off ": self = .turnOff(y: yRange, x: xRange)
        case "toggle ": self = .toggle(y: yRange, x: xRange)
        default: fatalError("Unknown operation")
        }
    }
    
    func perform(lights: inout [BitArray]) {
        switch self {
        case let .turnOn(yRange, xRange):
            lights.perform(range: yRange) { $0.fill(in: xRange, with: true) }
        case let .turnOff(yRange, xRange):
            lights.perform(range: yRange) { $0.fill(in: xRange, with: false) }
        case let .toggle(yRange, xRange):
            lights.perform(range: yRange) { $0.toggleAll(in: xRange) }
        }
    }
    
    func perform(lights: inout [[Int]]) {
        switch self {
        case let .turnOn(yRange, xRange):
            lights.perform(range: yRange) {
                for x in xRange { $0[x] += 1 }
            }
        case let .turnOff(yRange, xRange):
            lights.perform(range: yRange) {
                for x in xRange { $0[x] = max(0, $0[x] - 1) }
            }
        case let .toggle(yRange, xRange):
            lights.perform(range: yRange) {
                for x in xRange { $0[x] += 2 }
            }
        }
    }
}

private extension Array {
    mutating func perform(range: ClosedRange<Int>, _ body: (inout Element) -> Void) {
        DispatchQueue.concurrentPerform(iterations: range.count) { index in
            body(&self[range.lowerBound + index])
        }
    }
}
