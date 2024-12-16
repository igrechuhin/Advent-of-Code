import Foundation

extension AoC2024 {
    private static func getPuzzleInput(mode: AoCMode) -> String {
        getInput(day: .day16, mode: mode)
    }
    
    // --- Day 16: Reindeer Maze ---
    // It's time again for the Reindeer Olympics! This year, the big event is the Reindeer Maze, where the Reindeer compete for the lowest score.

    // You and The Historians arrive to search for the Chief right as the event is about to start. It wouldn't hurt to watch a little, right?

    // The Reindeer start on the Start Tile (marked S) facing East and need to reach the End Tile (marked E). They can move forward one tile at a time (increasing their score by 1 point), but never into a wall (#). They can also rotate clockwise or counterclockwise 90 degrees at a time (increasing their score by 1000 points).

    // To figure out the best place to sit, you start by grabbing a map (your puzzle input) from a nearby kiosk. For example:

    // ###############
    // #.......#....E#
    // #.#.###.#.###.#
    // #.....#.#...#.#
    // #.###.#####.#.#
    // #.#.#.......#.#
    // #.#.#####.###.#
    // #...........#.#
    // ###.#.#####.#.#
    // #...#.....#.#.#
    // #.#.#.###.#.#.#
    // #.....#...#.#.#
    // #.###.#.#.#.#.#
    // #S..#.....#...#
    // ###############
    // There are many paths through this maze, but taking any of the best paths would incur a score of only 7036. This can be achieved by taking a total of 36 steps forward and turning 90 degrees a total of 7 times:


    // ###############
    // #.......#....E#
    // #.#.###.#.###^#
    // #.....#.#...#^#
    // #.###.#####.#^#
    // #.#.#.......#^#
    // #.#.#####.###^#
    // #..>>>>>>>>v#^#
    // ###^#.#####v#^#
    // #>>^#.....#v#^#
    // #^#.#.###.#v#^#
    // #^....#...#v#^#
    // #^###.#.#.#v#^#
    // #S..#.....#>>^#
    // ###############
    // Here's a second example:

    // #################
    // #...#...#...#..E#
    // #.#.#.#.#.#.#.#.#
    // #.#.#.#...#...#.#
    // #.#.#.#.###.#.#.#
    // #...#.#.#.....#.#
    // #.#.#.#.#.#####.#
    // #.#...#.#.#.....#
    // #.#.#####.#.###.#
    // #.#.#.......#...#
    // #.#.###.#####.###
    // #.#.#...#.....#.#
    // #.#.#.#####.###.#
    // #.#.#.........#.#
    // #.#.#.#########.#
    // #S#.............#
    // #################
    // In this maze, the best paths cost 11048 points; following one such path would look like this:

    // #################
    // #...#...#...#..E#
    // #.#.#.#.#.#.#.#^#
    // #.#.#.#...#...#^#
    // #.#.#.#.###.#.#^#
    // #>>v#.#.#.....#^#
    // #^#v#.#.#.#####^#
    // #^#v..#.#.#>>>>^#
    // #^#v#####.#^###.#
    // #^#v#..>>>>^#...#
    // #^#v###^#####.###
    // #^#v#>>^#.....#.#
    // #^#v#^#####.###.#
    // #^#v#^........#.#
    // #^#v#^#########.#
    // #S#>>^..........#
    // #################
    // Note that the path shown above includes one 90 degree turn as the very first move, rotating the Reindeer from facing East to facing North.

    // Analyze your map carefully. What is the lowest score a Reindeer could possibly get?

    // Your puzzle answer was 82460.

    static func solveDay16Puzzle1(_ mode: AoCMode) -> Int {
        let map = getPuzzleInput(mode: mode).as2DArray
        let startPoint = map.getFirstPositionOfCharacter(.start)!
        let endPoint = map.getFirstPositionOfCharacter(.end)!

        return map
            .findShortestPaths(startPoint: startPoint, endPoint: endPoint)
            .filter { $0.key.point == endPoint }
            .values
            .min()!
    }

    // --- Part Two ---
    // Now that you know what the best paths look like, you can figure out the best spot to sit.

    // Every non-wall tile (S, ., or E) is equipped with places to sit along the edges of the tile. While determining which of these tiles would be the best spot to sit depends on a whole bunch of factors (how comfortable the seats are, how far away the bathrooms are, whether there's a pillar blocking your view, etc.), the most important factor is whether the tile is on one of the best paths through the maze. If you sit somewhere else, you'd miss all the action!

    // So, you'll need to determine which tiles are part of any best path through the maze, including the S and E tiles.

    // In the first example, there are 45 tiles (marked O) that are part of at least one of the various best paths through the maze:

    // ###############
    // #.......#....O#
    // #.#.###.#.###O#
    // #.....#.#...#O#
    // #.###.#####.#O#
    // #.#.#.......#O#
    // #.#.#####.###O#
    // #..OOOOOOOOO#O#
    // ###O#O#####O#O#
    // #OOO#O....#O#O#
    // #O#O#O###.#O#O#
    // #OOOOO#...#O#O#
    // #O###.#.#.#O#O#
    // #O..#.....#OOO#
    // ###############
    // In the second example, there are 64 tiles that are part of at least one of the best paths:

    // #################
    // #...#...#...#..O#
    // #.#.#.#.#.#.#.#O#
    // #.#.#.#...#...#O#
    // #.#.#.#.###.#.#O#
    // #OOO#.#.#.....#O#
    // #O#O#.#.#.#####O#
    // #O#O..#.#.#OOOOO#
    // #O#O#####.#O###O#
    // #O#O#..OOOOO#OOO#
    // #O#O###O#####O###
    // #O#O#OOO#..OOO#.#
    // #O#O#O#####O###.#
    // #O#O#OOOOOOO..#.#
    // #O#O#O#########.#
    // #O#OOO..........#
    // #################
    // Analyze your map further. How many tiles are part of at least one of the best paths through the maze?

    // Your puzzle answer was 590.

    static func solveDay16Puzzle2(_ mode: AoCMode) -> Int {
        let map = getPuzzleInput(mode: mode).as2DArray
        let startPoint = map.getFirstPositionOfCharacter(.start)!
        let endPoint = map.getFirstPositionOfCharacter(.end)!
        
        let seenBeams = map.findShortestPaths(startPoint: startPoint, endPoint: endPoint)
        let minScore = seenBeams
            .filter { $0.key.point == endPoint }
            .values
            .min()!
        
        let seenWaypoints = seenBeams
            .map { Waypoint(beam: $0.key, score: $0.value) }
            .filter { $0.score <= minScore }
        
        var backQueue: [Waypoint] = seenWaypoints.filter { $0.beam.point == endPoint && $0.score == minScore }
        var backQueueIndex = 0

        while backQueueIndex < backQueue.count {
            backQueue.append(contentsOf: seenWaypoints.filter(backQueue[backQueueIndex].isPrevious))
            backQueueIndex += 1
        }
        
        return Set(backQueue.map(\.beam.point)).count
    }
}

private extension Beam2D {
    var turnDirections: [Direction2D] {
        switch direction {
        case .north, .south: [.west, .east]
        case .west, .east: [.north, .south]
        }
    }
}

private struct Waypoint: Hashable, Comparable {
    let beam: Beam2D
    let score: Int
    
    static func == (lhs: Waypoint, rhs: Waypoint) -> Bool {
        lhs.beam == rhs.beam &&
        lhs.score == rhs.score
    }

    static func < (lhs: Waypoint, rhs: Waypoint) -> Bool {
        lhs.score < rhs.score
    }
    
    func isPrevious(_ waypoint: Waypoint) -> Bool {
        [.forward, .turn].contains(score - waypoint.score) && waypoint.beam.point == beam.point.moved(beam.direction, distance: -1)
    }
    
    func waypoints(inMap map: [[Character]]) -> [Waypoint] {
        var waypoints = [Waypoint]()
        let testPoint = beam.point.moved(beam.direction)
        if map[safe: testPoint] != .wall {
            waypoints.append(Waypoint(beam: Beam2D(point: testPoint, direction: beam.direction), score: score + .forward))
        }
        
        for direction in beam.turnDirections {
            let testPoint = beam.point.moved(direction)
            if map[safe: testPoint] != .wall {
                waypoints.append(Waypoint(beam: Beam2D(point: testPoint, direction: direction), score: score + .turn))
            }
        }
        return waypoints
    }
}

private extension Int {
    static let forward = 1
    static let turn = 1001
}

private extension Character {
    static let wall: Character = "#"
    static let start: Character = "S"
    static let end: Character = "E"
}

private extension [[Character]] {
    func findShortestPaths(startPoint: Point2D, endPoint: Point2D) -> [Beam2D: Int] {
        let startWaypoint = Waypoint(beam: Beam2D(point: startPoint, direction: .east), score: 0)
        
        var queue = Heap(array: [startWaypoint], sort: <)
        var seenBeams: [Beam2D: Int] = [startWaypoint.beam: startWaypoint.score]
        var minScore = Int.max
        
        while let current = queue.remove() {
            if current.score >= minScore { continue }
            if current.beam.point == endPoint {
                minScore = Swift.min(minScore, current.score)
                continue
            }
            
            for waypoint in current.waypoints(inMap: self) {
                if let seen = seenBeams[waypoint.beam], seen < waypoint.score { continue }
                queue.insert(waypoint)
                seenBeams[waypoint.beam] = waypoint.score
            }
        }
        
        return seenBeams
    }
}
