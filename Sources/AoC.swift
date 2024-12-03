import Foundation

protocol AoC {
    static var year: AoCYear { get }
}

enum AoCMode {
    case test1
    case test2
    case quest
}

enum AoCYear: String {
    case year2015 = "2015"
    case year2023 = "2023"
    case year2024 = "2024"
}

enum AoCDay: String {
    case day1
    case day2
    case day3
    case day4
    case day5
    case day6
    case day7
    case day8
    case day9
    case day10
    case day11
    case day12
    case day13
    case day14
    case day15
    case day16
    case day17
    case day18
    case day19
    case day20
    case day21
    case day22
    case day23
    case day24
    case day25
    
    func inputFileName(mode: AoCMode) -> String {
        let inputString = "\(self.rawValue.capitalized)Input"
        return switch mode {
        case .test1: "\(inputString).Test1"
        case .test2: "\(inputString).Test2"
        case .quest: inputString
        }
    }
}

extension AoC {
    static func getInput(day: AoCDay, mode: AoCMode) -> String {
        getInput(
            fileName: day.inputFileName(mode: mode)
        )
    }
    
    static func getInput(
        fileName: String,
        ext: String = "txt"
    ) -> String {
        let inputPath = Bundle.main
            .paths(
                forResourcesOfType: ext,
                inDirectory: "Resources/\(year.rawValue)"
            )
            .first { $0.contains("\(fileName).\(ext)") }!
        return try! String(contentsOfFile: inputPath)
    }
}
