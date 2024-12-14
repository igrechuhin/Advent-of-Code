import Foundation

extension AoC2024 {
    private static func getPuzzleInput(mode: AoCMode) -> String {
        getInput(day: .day14, mode: mode)
    }

    // --- Day 14: Restroom Redoubt ---
    // One of The Historians needs to use the bathroom; fortunately, you know there's a bathroom near an unvisited location on their list, and so you're all quickly teleported directly to the lobby of Easter Bunny Headquarters.

    // Unfortunately, EBHQ seems to have "improved" bathroom security again after your last visit. The area outside the bathroom is swarming with robots!

    // To get The Historian safely to the bathroom, you'll need a way to predict where the robots will be in the future. Fortunately, they all seem to be moving on the tile floor in predictable straight lines.

    // You make a list (your puzzle input) of all of the robots' current positions (p) and velocities (v), one robot per line. For example:

    // p=0,4 v=3,-3
    // p=6,3 v=-1,-3
    // p=10,3 v=-1,2
    // p=2,0 v=2,-1
    // p=0,0 v=1,3
    // p=3,0 v=-2,-2
    // p=7,6 v=-1,-3
    // p=3,0 v=-1,-2
    // p=9,3 v=2,3
    // p=7,3 v=-1,2
    // p=2,4 v=2,-3
    // p=9,5 v=-3,-3
    // Each robot's position is given as p=x,y where x represents the number of tiles the robot is from the left wall and y represents the number of tiles from the top wall (when viewed from above). So, a position of p=0,0 means the robot is all the way in the top-left corner.

    // Each robot's velocity is given as v=x,y where x and y are given in tiles per second. Positive x means the robot is moving to the right, and positive y means the robot is moving down. So, a velocity of v=1,-2 means that each second, the robot moves 1 tile to the right and 2 tiles up.

    // The robots outside the actual bathroom are in a space which is 101 tiles wide and 103 tiles tall (when viewed from above). However, in this example, the robots are in a space which is only 11 tiles wide and 7 tiles tall.

    // The robots are good at navigating over/under each other (due to a combination of springs, extendable legs, and quadcopters), so they can share the same tile and don't interact with each other. Visually, the number of robots on each tile in this example looks like this:

    // 1.12.......
    // ...........
    // ...........
    // ......11.11
    // 1.1........
    // .........1.
    // .......1...
    // These robots have a unique feature for maximum bathroom security: they can teleport. When a robot would run into an edge of the space they're in, they instead teleport to the other side, effectively wrapping around the edges. Here is what robot p=2,4 v=2,-3 does for the first few seconds:

    // Initial state:
    // ...........
    // ...........
    // ...........
    // ...........
    // ..1........
    // ...........
    // ...........

    // After 1 second:
    // ...........
    // ....1......
    // ...........
    // ...........
    // ...........
    // ...........
    // ...........

    // After 2 seconds:
    // ...........
    // ...........
    // ...........
    // ...........
    // ...........
    // ......1....
    // ...........

    // After 3 seconds:
    // ...........
    // ...........
    // ........1..
    // ...........
    // ...........
    // ...........
    // ...........

    // After 4 seconds:
    // ...........
    // ...........
    // ...........
    // ...........
    // ...........
    // ...........
    // ..........1

    // After 5 seconds:
    // ...........
    // ...........
    // ...........
    // .1.........
    // ...........
    // ...........
    // ...........
    // The Historian can't wait much longer, so you don't have to simulate the robots for very long. Where will the robots be after 100 seconds?

    // In the above example, the number of robots on each tile after 100 seconds has elapsed looks like this:

    // ......2..1.
    // ...........
    // 1..........
    // .11........
    // .....1.....
    // ...12......
    // .1....1....
    // To determine the safest area, count the number of robots in each quadrant after 100 seconds. Robots that are exactly in the middle (horizontally or vertically) don't count as being in any quadrant, so the only relevant robots are:

    // ..... 2..1.
    // ..... .....
    // 1.... .....
            
    // ..... .....
    // ...12 .....
    // .1... 1....
    // In this example, the quadrants contain 1, 3, 4, and 1 robot. Multiplying these together gives a total safety factor of 12.

    // Predict the motion of the robots in your list within a space which is 101 tiles wide and 103 tiles tall. What will the safety factor be after exactly 100 seconds have elapsed?

    // Your puzzle answer was 228457125.

    static func solveDay14Puzzle1(_ mode: AoCMode) -> Int {
        var robots = getPuzzleInput(mode: mode)
            .components(separatedBy: "\n")
            .filter(\.isNotEmpty)
            .map { Robot(raw: $0)}
        
        for _ in 0 ..< 100 {
            robots = robots.map { $0.moved(inSpace: mode.space) }
        }
        
        let robotsCount = mode
            .space
            .quadrants
            .map { quadrant in
                robots.filter { robot in
                    quadrant.contains(robot.position)
                }.count
            }
        
        return robotsCount.mul
    }

    // --- Part Two ---
    // During the bathroom break, someone notices that these robots seem awfully similar to ones built and used at the North Pole. If they're the same type of robots, they should have a hard-coded Easter egg: very rarely, most of the robots should arrange themselves into a picture of a Christmas tree.

    // What is the fewest number of seconds that must elapse for the robots to display the Easter egg?

    // Your puzzle answer was 6493.
    
    static func solveDay14Puzzle2(_ mode: AoCMode) -> Int {
        let pattern: [[Character]] = [
            "###############################",
            "#.............................#",
            "#.............................#",
            "#.............................#",
            "#.............................#",
            "#..............#..............#",
            "#.............###.............#",
            "#............#####............#",
            "#...........#######...........#",
            "#..........#########..........#",
            "#............#####............#",
            "#...........#######...........#",
            "#..........#########..........#",
            "#.........###########.........#",
            "#........#############........#",
            "#..........#########..........#",
            "#.........###########.........#",
            "#........#############........#",
            "#.......###############.......#",
            "#......#################......#",
            "#........#############........#",
            "#.......###############.......#",
            "#......#################......#",
            "#.....###################.....#",
            "#....#####################....#",
            "#.............###.............#",
            "#.............###.............#",
            "#.............###.............#",
            "#.............................#",
            "#.............................#",
            "#.............................#",
            "#.............................#",
            "###############################"
        ].map { Array($0) }

        var robots = getPuzzleInput(mode: mode)
            .components(separatedBy: "\n")
            .filter(\.isNotEmpty)
            .map { Robot(raw: $0)}

        var time = 0
        while true {
            robots = robots.map { $0.moved(inSpace: mode.space) }
            time += 1

            let picture = mode.space.picture(robots: robots)
            
            let isFastCompare = picture.contains { row in
                row.contains(pattern[0])
            }
            guard isFastCompare else { continue }
            
            if picture.contains(subArray: pattern) {
                return time
            }
        }
    }
}

private struct Robot {
    var position: Point2D
    let velocity: Point2D
    
    init(raw: String) {
        let matches = raw.matches(of: /-?\d+/)
        let position = Point2D(y: Int(matches[1].0)!, x: Int(matches[0].0)!)
        let velocity = Point2D(y: Int(matches[3].0)!, x: Int(matches[2].0)!)
        self.position = position
        self.velocity = velocity
    }
    
    func moved(inSpace space: Space) -> Robot {
        var newPosition = position + velocity
        while newPosition.x < space.rangeX.lowerBound {
            newPosition.x += space.rangeX.count
        }
        while newPosition.x >= space.rangeX.upperBound {
            newPosition.x -= space.rangeX.count
        }
        while newPosition.y < space.rangeY.lowerBound {
            newPosition.y += space.rangeY.count
        }
        while newPosition.y >= space.rangeY.upperBound {
            newPosition.y -= space.rangeY.count
        }
        var copy = self
        copy.position = newPosition
        return copy
    }
}

private struct Space {
    let rangeY: Range<Int>
    let rangeX: Range<Int>
    
    func contains(_ point: Point2D) -> Bool {
        rangeY.contains(point.y) && rangeX.contains(point.x)
    }

    var quadrants: [Space] {
        [
            Space(rangeY: 0 ..< rangeY.count / 2, rangeX: 0 ..< rangeX.count / 2),
            Space(rangeY: 0 ..< rangeY.count / 2, rangeX: (rangeX.count / 2) + 1 ..< rangeX.count),
            Space(rangeY: (rangeY.count / 2) + 1 ..< rangeY.upperBound, rangeX: 0 ..< rangeX.count / 2),
            Space(rangeY: (rangeY.count / 2) + 1 ..< rangeY.upperBound, rangeX: (rangeX.count / 2) + 1 ..< rangeX.count)
        ]
    }
    
    func picture(robots: [Robot]) -> [[Character]] {
        var map = Array(
            repeating: Array(repeating: Character("."), count: rangeX.count),
            count: rangeY.count
        )
        for robot in robots {
            map[robot.position.y][robot.position.x] = "#"
        }
        return map
    }
}

private extension AoCMode {
    var space: Space {
        switch self {
        case .test1, .test2:
            Space(rangeY: 0 ..< 7, rangeX: 0 ..< 11)
        case .quest:
            Space(rangeY: 0 ..< 103, rangeX: 0 ..< 101)
        }
    }
}
