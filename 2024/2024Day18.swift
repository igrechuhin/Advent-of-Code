import Foundation
import Collections

extension AoC2024 {
    private static func getPuzzleInput(mode: AoCMode) -> String {
        getInput(day: .day18, mode: mode)
    }

    // --- Day 18: RAM Run ---
    // You and The Historians look a lot more pixelated than you remember. You're inside a computer at the North Pole!

    // Just as you're about to check out your surroundings, a program runs up to you. "This region of memory isn't safe! The User misunderstood what a pushdown automaton is and their algorithm is pushing whole bytes down on top of us! Run!"

    // The algorithm is fast - it's going to cause a byte to fall into your memory space once every nanosecond! Fortunately, you're faster, and by quickly scanning the algorithm, you create a list of which bytes will fall (your puzzle input) in the order they'll land in your memory space.

    // Your memory space is a two-dimensional grid with coordinates that range from 0 to 70 both horizontally and vertically. However, for the sake of example, suppose you're on a smaller grid with coordinates that range from 0 to 6 and the following list of incoming byte positions:

    // 5,4
    // 4,2
    // 4,5
    // 3,0
    // 2,1
    // 6,3
    // 2,4
    // 1,5
    // 0,6
    // 3,3
    // 2,6
    // 5,1
    // 1,2
    // 5,5
    // 2,5
    // 6,5
    // 1,4
    // 0,4
    // 6,4
    // 1,1
    // 6,1
    // 1,0
    // 0,5
    // 1,6
    // 2,0
    // Each byte position is given as an X,Y coordinate, where X is the distance from the left edge of your memory space and Y is the distance from the top edge of your memory space.

    // You and The Historians are currently in the top left corner of the memory space (at 0,0) and need to reach the exit in the bottom right corner (at 70,70 in your memory space, but at 6,6 in this example). You'll need to simulate the falling bytes to plan out where it will be safe to run; for now, simulate just the first few bytes falling into your memory space.

    // As bytes fall into your memory space, they make that coordinate corrupted. Corrupted memory coordinates cannot be entered by you or The Historians, so you'll need to plan your route carefully. You also cannot leave the boundaries of the memory space; your only hope is to reach the exit.

    // In the above example, if you were to draw the memory space after the first 12 bytes have fallen (using . for safe and # for corrupted), it would look like this:

    // ...#...
    // ..#..#.
    // ....#..
    // ...#..#
    // ..#..#.
    // .#..#..
    // #.#....
    // You can take steps up, down, left, or right. After just 12 bytes have corrupted locations in your memory space, the shortest path from the top left corner to the exit would take 22 steps. Here (marked with O) is one such path:

    // OO.#OOO
    // .O#OO#O
    // .OOO#OO
    // ...#OO#
    // ..#OO#.
    // .#.O#..
    // #.#OOOO
    // Simulate the first kilobyte (1024 bytes) falling onto your memory space. Afterward, what is the minimum number of steps needed to reach the exit?

    // Your puzzle answer was 298.

    static func solveDay18Puzzle1(_ mode: AoCMode) -> Int {
        let bytes = getPuzzleInput(mode: mode)
            .components(separatedBy: .newlines)
            .filter(\.isNotEmpty)
            .prefix(mode.bytesCount)
            .map { Point2D(raw: $0) }
        
        var map = [[Character]].make(size: mode.memorySpaceSize, value: ".")
        
        for byte in bytes {
            map.mutate(point: byte, value: .byte)
        }
        
        let startPoint: Point2D = .zero
        let endPoint = map.size - Point2D(y: 1, x: 1)
        let seenPoints = map.findShortestPaths(
            startPoint: startPoint,
            endPoint: endPoint
        )
        
        let minimumNumberOfSteps = seenPoints
            .filter { $0.key == endPoint }
            .values
            .min()!
        
        return minimumNumberOfSteps
    }
    
    // --- Part Two ---
    // The Historians aren't as used to moving around in this pixelated universe as you are. You're afraid they're not going to be fast enough to make it to the exit before the path is completely blocked.

    // To determine how fast everyone needs to go, you need to determine the first byte that will cut off the path to the exit.

    // In the above example, after the byte at 1,1 falls, there is still a path to the exit:

    // O..#OOO
    // O##OO#O
    // O#OO#OO
    // OOO#OO#
    // ###OO##
    // .##O###
    // #.#OOOO
    // However, after adding the very next byte (at 6,1), there is no longer a path to the exit:

    // ...#...
    // .##..##
    // .#..#..
    // ...#..#
    // ###..##
    // .##.###
    // #.#....
    // So, in this example, the coordinates of the first byte that prevents the exit from being reachable are 6,1.

    // Simulate more of the bytes that are about to corrupt your memory space. What are the coordinates of the first byte that will prevent the exit from being reachable from your starting position? (Provide the answer as two integers separated by a comma with no other characters.)

    // Your puzzle answer was 52,32.

    static func solveDay18Puzzle2(_ mode: AoCMode) -> String {
        let bytes = getPuzzleInput(mode: mode)
            .components(separatedBy: .newlines)
            .filter(\.isNotEmpty)
            .map { Point2D(raw: $0) }
        
        var map = [[Character]].make(size: mode.memorySpaceSize, value: ".")
        let startPoint: Point2D = .zero
        let endPoint = map.size - Point2D(y: 1, x: 1)

        for (index, byte) in bytes.enumerated() {
            map.mutate(point: byte, value: .byte)
            
            if index < mode.bytesCount { continue }

            let seenPoints = map.findShortestPaths(
                startPoint: startPoint,
                endPoint: endPoint
            )
            let minimumNumberOfSteps = seenPoints
                .filter { $0.key == endPoint }
                .values
                .min()
            if minimumNumberOfSteps == nil {
                return "\(byte.x),\(byte.y)"
            }
        }
        return ""
    }
}

private extension AoCMode {
    var bytesCount: Int {
        switch self {
        case .test1: 12
        case .quest: 1024
        default: fatalError( "Unsupported mode: \(self)")
        }
    }
    
    var memorySpaceSize: Point2D {
        switch self {
        case .test1: Point2D(y: 7, x: 7)
        case .quest: Point2D(y: 71, x: 71)
        default: fatalError( "Unsupported mode: \(self)")
        }
    }
}

private struct Waypoint: Hashable, Comparable {
    let point: Point2D
    let score: Int
    
    static func == (lhs: Waypoint, rhs: Waypoint) -> Bool {
        lhs.point == rhs.point &&
        lhs.score == rhs.score
    }
    
    static func < (lhs: Waypoint, rhs: Waypoint) -> Bool {
        lhs.score < rhs.score
    }

    func waypoints(inMap map: [[Character]]) -> [Waypoint] {
        var waypoints = [Waypoint]()
        for direction in Direction2D.allCases {
            let testPoint = point.moved(direction)
            if map[safe: testPoint] == .empty {
                waypoints.append(Waypoint(point: testPoint, score: score + 1))
            }
        }
        return waypoints
    }
    
    func isPrevious(_ waypoint: Waypoint) -> Bool {
        score - waypoint.score == 1 &&
        Direction2D.allCases.map(\.point2D).contains(waypoint.point - point)
    }
}

private extension[[Character]] {
    func findShortestPaths(startPoint: Point2D, endPoint: Point2D) -> [Point2D: Int] {
        let startWaypoint = Waypoint(point: startPoint, score: 0)
        
        var queue = Heap([startWaypoint])
        var seenPoints: [Point2D: Int] = [startWaypoint.point: startWaypoint.score]
        var minScore = Int.max
        
        while let current = queue.popMin() {
            if current.score >= minScore { continue }
            if current.point == endPoint {
                minScore = Swift.min(minScore, current.score)
                continue
            }
            
            for waypoint in current.waypoints(inMap: self) {
                if let seen = seenPoints[waypoint.point], seen <= waypoint.score { continue }
                queue.insert(waypoint)
                seenPoints[waypoint.point] = waypoint.score
            }
        }
        
        return seenPoints
    }
}

private extension Character {
    static let byte: Character = "#"
    static let empty: Character = "."
}
