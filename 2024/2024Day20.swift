import Foundation
import Collections

extension AoC2024 {
    private static func getPuzzleInput(mode: AoCMode) -> String {
        getInput(day: .day20, mode: mode)
    }

    // --- Day 20: Race Condition ---
    // The Historians are quite pixelated again. This time, a massive, black building looms over you - you're right outside the CPU!

    // While The Historians get to work, a nearby program sees that you're idle and challenges you to a race. Apparently, you've arrived just in time for the frequently-held race condition festival!

    // The race takes place on a particularly long and twisting code path; programs compete to see who can finish in the fewest picoseconds. The winner even gets their very own mutex!

    // They hand you a map of the racetrack (your puzzle input). For example:

    // ###############
    // #...#...#.....#
    // #.#.#.#.#.###.#
    // #S#...#.#.#...#
    // #######.#.#.###
    // #######.#.#...#
    // #######.#.###.#
    // ###..E#...#...#
    // ###.#######.###
    // #...###...#...#
    // #.#####.#.###.#
    // #.#...#.#.#...#
    // #.#.#.#.#.#.###
    // #...#...#...###
    // ###############
    // The map consists of track (.) - including the start (S) and end (E) positions (both of which also count as track) - and walls (#).

    // When a program runs through the racetrack, it starts at the start position. Then, it is allowed to move up, down, left, or right; each such move takes 1 picosecond. The goal is to reach the end position as quickly as possible. In this example racetrack, the fastest time is 84 picoseconds.

    // Because there is only a single path from the start to the end and the programs all go the same speed, the races used to be pretty boring. To make things more interesting, they introduced a new rule to the races: programs are allowed to cheat.

    // The rules for cheating are very strict. Exactly once during a race, a program may disable collision for up to 2 picoseconds. This allows the program to pass through walls as if they were regular track. At the end of the cheat, the program must be back on normal track again; otherwise, it will receive a segmentation fault and get disqualified.

    // So, a program could complete the course in 72 picoseconds (saving 12 picoseconds) by cheating for the two moves marked 1 and 2:

    // ###############
    // #...#...12....#
    // #.#.#.#.#.###.#
    // #S#...#.#.#...#
    // #######.#.#.###
    // #######.#.#...#
    // #######.#.###.#
    // ###..E#...#...#
    // ###.#######.###
    // #...###...#...#
    // #.#####.#.###.#
    // #.#...#.#.#...#
    // #.#.#.#.#.#.###
    // #...#...#...###
    // ###############
    // Or, a program could complete the course in 64 picoseconds (saving 20 picoseconds) by cheating for the two moves marked 1 and 2:

    // ###############
    // #...#...#.....#
    // #.#.#.#.#.###.#
    // #S#...#.#.#...#
    // #######.#.#.###
    // #######.#.#...#
    // #######.#.###.#
    // ###..E#...12..#
    // ###.#######.###
    // #...###...#...#
    // #.#####.#.###.#
    // #.#...#.#.#...#
    // #.#.#.#.#.#.###
    // #...#...#...###
    // ###############
    // This cheat saves 38 picoseconds:

    // ###############
    // #...#...#.....#
    // #.#.#.#.#.###.#
    // #S#...#.#.#...#
    // #######.#.#.###
    // #######.#.#...#
    // #######.#.###.#
    // ###..E#...#...#
    // ###.####1##.###
    // #...###.2.#...#
    // #.#####.#.###.#
    // #.#...#.#.#...#
    // #.#.#.#.#.#.###
    // #...#...#...###
    // ###############
    // This cheat saves 64 picoseconds and takes the program directly to the end:

    // ###############
    // #...#...#.....#
    // #.#.#.#.#.###.#
    // #S#...#.#.#...#
    // #######.#.#.###
    // #######.#.#...#
    // #######.#.###.#
    // ###..21...#...#
    // ###.#######.###
    // #...###...#...#
    // #.#####.#.###.#
    // #.#...#.#.#...#
    // #.#.#.#.#.#.###
    // #...#...#...###
    // ###############
    // Each cheat has a distinct start position (the position where the cheat is activated, just before the first move that is allowed to go through walls) and end position; cheats are uniquely identified by their start position and end position.

    // In this example, the total number of cheats (grouped by the amount of time they save) are as follows:

    // There are 14 cheats that save 2 picoseconds.
    // There are 14 cheats that save 4 picoseconds.
    // There are 2 cheats that save 6 picoseconds.
    // There are 4 cheats that save 8 picoseconds.
    // There are 2 cheats that save 10 picoseconds.
    // There are 3 cheats that save 12 picoseconds.
    // There is one cheat that saves 20 picoseconds.
    // There is one cheat that saves 36 picoseconds.
    // There is one cheat that saves 38 picoseconds.
    // There is one cheat that saves 40 picoseconds.
    // There is one cheat that saves 64 picoseconds.
    // You aren't sure what the conditions of the racetrack will be like, so to give yourself as many options as possible, you'll need a list of the best cheats. How many cheats would save you at least 100 picoseconds?

    // Your puzzle answer was 1323.

    static func solveDay20Puzzle1(_ mode: AoCMode) -> Int {
        waysToCheat(mode, maxCheatDistance: 2)
    }

    // --- Part Two ---
    // The programs seem perplexed by your list of cheats. Apparently, the two-picosecond cheating rule was deprecated several milliseconds ago! The latest version of the cheating rule permits a single cheat that instead lasts at most 20 picoseconds.

    // Now, in addition to all the cheats that were possible in just two picoseconds, many more cheats are possible. This six-picosecond cheat saves 76 picoseconds:

    // ###############
    // #...#...#.....#
    // #.#.#.#.#.###.#
    // #S#...#.#.#...#
    // #1#####.#.#.###
    // #2#####.#.#...#
    // #3#####.#.###.#
    // #456.E#...#...#
    // ###.#######.###
    // #...###...#...#
    // #.#####.#.###.#
    // #.#...#.#.#...#
    // #.#.#.#.#.#.###
    // #...#...#...###
    // ###############
    // Because this cheat has the same start and end positions as the one above, it's the same cheat, even though the path taken during the cheat is different:

    // ###############
    // #...#...#.....#
    // #.#.#.#.#.###.#
    // #S12..#.#.#...#
    // ###3###.#.#.###
    // ###4###.#.#...#
    // ###5###.#.###.#
    // ###6.E#...#...#
    // ###.#######.###
    // #...###...#...#
    // #.#####.#.###.#
    // #.#...#.#.#...#
    // #.#.#.#.#.#.###
    // #...#...#...###
    // ###############
    // Cheats don't need to use all 20 picoseconds; cheats can last any amount of time up to and including 20 picoseconds (but can still only end when the program is on normal track). Any cheat time not used is lost; it can't be saved for another cheat later.

    // You'll still need a list of the best cheats, but now there are even more to choose between. Here are the quantities of cheats in this example that save 50 picoseconds or more:

    // There are 32 cheats that save 50 picoseconds.
    // There are 31 cheats that save 52 picoseconds.
    // There are 29 cheats that save 54 picoseconds.
    // There are 39 cheats that save 56 picoseconds.
    // There are 25 cheats that save 58 picoseconds.
    // There are 23 cheats that save 60 picoseconds.
    // There are 20 cheats that save 62 picoseconds.
    // There are 19 cheats that save 64 picoseconds.
    // There are 12 cheats that save 66 picoseconds.
    // There are 14 cheats that save 68 picoseconds.
    // There are 12 cheats that save 70 picoseconds.
    // There are 22 cheats that save 72 picoseconds.
    // There are 4 cheats that save 74 picoseconds.
    // There are 3 cheats that save 76 picoseconds.
    // Find the best cheats using the updated cheating rules. How many cheats would save you at least 100 picoseconds?

    // Your puzzle answer was 983905.

    static func solveDay20Puzzle2(_ mode: AoCMode) -> Int {
        waysToCheat(mode, maxCheatDistance: 20)
    }

    private static func waysToCheat(_ mode: AoCMode, maxCheatDistance: Int) -> Int {
        let map = getPuzzleInput(mode: mode).as2DArray
        
        let startPoint = map.getFirstPositionOfCharacter(.start)!
        let endPoint = map.getFirstPositionOfCharacter(.end)!
        
        let seenPoints = map.findShortestPaths(
            startPoint: startPoint,
            endPoint: endPoint
        )
        
        let minimumNumberOfSteps = seenPoints
            .filter { $0.key == endPoint }
            .values
            .min()!
        
        return seenPoints
            .map { Waypoint(point: $0.key, score: $0.value) }
            .filter { $0.score <= minimumNumberOfSteps }
            .pathsWaypoints(endPoint: endPoint, minScore: minimumNumberOfSteps)
            .cheats(maxDistance: maxCheatDistance)
            .count { $0.gain >= mode.threshold }
    }
}

private struct Cheat {
    let from: Point2D
    let to: Point2D
    let gain: Int
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
            
            if let cell = map[safe: testPoint], cell != .wall {
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

private extension [Waypoint] {
    func pathsWaypoints(endPoint: Point2D, minScore: Int) -> [Waypoint] {
        var backQueue: [Waypoint] = filter { $0.point == endPoint && $0.score == minScore }
        var backQueueIndex = 0
        
        while backQueueIndex < backQueue.count {
            backQueue.append(contentsOf: filter(backQueue[backQueueIndex].isPrevious))
            backQueueIndex += 1
        }
        
        return backQueue
    }
    
    func cheats(maxDistance: Int) -> [Cheat] {
        var result = [Cheat]()
        for i in 0 ..< count {
            let waypointI = self[i]
            for j in i+1 ..< count {
                let waypointJ = self[j]
                let distance = L1Distance(waypointI.point, waypointJ.point)
                let scoreDiff = abs(waypointI.score - waypointJ.score)
                guard scoreDiff > distance else { continue }
                guard distance <= maxDistance else { continue }
                result.append(
                    Cheat(
                        from: waypointI.point,
                        to: waypointJ.point,
                        gain: scoreDiff - distance
                    )
                )
            }
        }
        return result
    }
}

private extension[[Character]] {
    func findShortestPaths(
        startPoint: Point2D,
        endPoint: Point2D,
        minScore: Int = Int.max
    ) -> [Point2D: Int] {
        let startWaypoint = Waypoint(point: startPoint, score: 0)
        
        var queue = Heap([startWaypoint])
        var seenPoints: [Point2D: Int] = [startWaypoint.point: startWaypoint.score]
        var minScore = minScore
        
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
    static let wall: Character = "#"
    static let empty: Character = "."
    static let start: Character = "S"
    static let end: Character = "E"
}

private extension AoCMode {
    var threshold: Int {
        switch self {
        case .test1: return 60
        case .quest: return 100
        default: fatalError( "Unsupported mode: \(self)")
        }
    }
}
