import Foundation

extension AoC2023 {
    private static func getDay21Input() -> String {
        //"""
        //...........
        //.....###.#.
        //.###.##..#.
        //..#.#...#..
        //....#.#....
        //.##..S####.
        //.##..#...#.
        //.......##..
        //.##.#.####.
        //.##..##.##.
        //...........
        //"""
        getInput(fileName: "Day21Input")
    }
    
    //: # --- Day 21: Step Counter ---
    //: You manage to catch the airship right as it's dropping someone else off on their all-expenses-paid trip to Desert Island! It even helpfully drops you off near the gardener and his massive farm.
    //:
    //: "You got the sand flowing again! Great work! Now we just need to wait until we have enough sand to filter the water for Snow Island and we'll have snow again in no time."
    //:
    //: While you wait, one of the Elves that works with the gardener heard how good you are at solving problems and would like your help. He needs to get his steps in for the day, and so he'd like to know **which garden plots he can reach with exactly his remaining `64` steps.**
    //:
    //: He gives you an up-to-date map (your puzzle input) of his starting position (S), garden plots (.), and rocks (#). For example:
    //:
    //: ```
    //: ...........
    //: .....###.#.
    //: .###.##..#.
    //: ..#.#...#..
    //: ....#.#....
    //: .##..S####.
    //: .##..#...#.
    //: .......##..
    //: .##.#.####.
    //: .##..##.##.
    //: ...........
    //: ```
    //:
    //: The Elf starts at the starting position (S) which also counts as a garden plot. Then, he can take one step north, south, east, or west, but only onto tiles that are garden plots. This would allow him to reach any of the tiles marked O:
    //:
    //: ```
    //: ...........
    //: .....###.#.
    //: .###.##..#.
    //: ..#.#...#..
    //: ....#O#....
    //: .##.OS####.
    //: .##..#...#.
    //: .......##..
    //: .##.#.####.
    //: .##..##.##.
    //: ...........
    //: ```
    //:
    //: Then, he takes a second step. Since at this point he could be at **either** tile marked O, his second step would allow him to reach any garden plot that is one step north, south, east, or west of **any** tile that he could have reached after the first step:
    //:
    //: ```
    //: ...........
    //: .....###.#.
    //: .###.##..#.
    //: ..#.#O..#..
    //: ....#.#....
    //: .##O.O####.
    //: .##.O#...#.
    //: .......##..
    //: .##.#.####.
    //: .##..##.##.
    //: ...........
    //: ```
    //:
    //: After two steps, he could be at any of the tiles marked O above, including the starting position (either by going north-then-south or by going west-then-east).
    //:
    //: A single third step leads to even more possibilities:
    //:
    //: ```
    //: ...........
    //: .....###.#.
    //: .###.##..#.
    //: ..#.#.O.#..
    //: ...O#O#....
    //: .##.OS####.
    //: .##O.#...#.
    //: ....O..##..
    //: .##.#.####.
    //: .##..##.##.
    //: ...........
    //: ```
    //:
    //: He will continue like this until his steps for the day have been exhausted. After a total of 6 steps, he could reach any of the garden plots marked O:
    //:
    //: ```
    //: ...........
    //: .....###.#.
    //: .###.##.O#.
    //: .O#O#O.O#..
    //: O.O.#.#.O..
    //: .##O.O####.
    //: .##.O#O..#.
    //: .O.O.O.##..
    //: .##.#.####.
    //: .##O.##.##.
    //: ...........
    //: ```
    //:
    //: In this example, if the Elf's goal was to get exactly `6` more steps today, he could use them to reach any of `16` garden plots.
    //:
    //: However, the Elf **actually needs to get `64` steps today**, and the map he's handed you is much larger than the example map.
    //:
    //: Starting from the garden plot marked S on your map, **how many garden plots could the Elf reach in exactly `64` steps?**
    
    private static func fillGrid(_ grid: [[Character]], start: Point2D, steps: Int) -> [Int] {
        var counts = [1]
        var count1 = 0
        var count2 = 1
        var points1 = Set<Point2D>()
        var points2 = Set([start])
        let size = grid.size
        let rock = Character("#")
        let directions = Direction2D.allCases.map(\.point2D)
        for _ in 0 ..< steps {
            var newPoints = Set<Point2D>()
            for point in points2 {
                for shift in directions {
                    let newPoint = point + shift
                    let loopedPoint = newPoint.looped(size: size)
                    let pointType = grid[loopedPoint.y][loopedPoint.x]
                    if pointType != rock, !points1.contains(newPoint) {
                        newPoints.insert(newPoint)
                    }
                }
            }
            let newCount = count1 + newPoints.count
            //        print(step, newPoints.count)
            count1 = count2
            count2 = newCount
            
            points1 = points2
            points2 = newPoints
            //        print(points)
            counts.append(count2)
        }
        return counts
    }
    
    static func solveDay21Puzzle1() -> Int {
        let input = getDay21Input().as2DArray
        let start = input.getFirstPositionOfCharacter("S")!
        
        let N = 64
        let counts = fillGrid(input, start: start, steps: N)
        return counts[N]
    }
    
    //: # --- Part Two ---
    //: The Elf seems confused by your answer until he realizes his mistake: he was reading from a list of his favorite numbers that are both perfect squares and perfect cubes, not his step counter.
    //:
    //: The **actual** number of steps he needs to get today is exactly **`26501365`**.
    //:
    //: He also points out that the garden plots and rocks are set up so that the map **repeats infinitely** in every direction.
    //:
    //: So, if you were to look one additional map-width or map-height out from the edge of the example map above, you would find that it keeps repeating:
    //:
    //: ```
    //: .................................
    //: .....###.#......###.#......###.#.
    //: .###.##..#..###.##..#..###.##..#.
    //: ..#.#...#....#.#...#....#.#...#..
    //: ....#.#........#.#........#.#....
    //: .##...####..##...####..##...####.
    //: .##..#...#..##..#...#..##..#...#.
    //: .......##.........##.........##..
    //: .##.#.####..##.#.####..##.#.####.
    //: .##..##.##..##..##.##..##..##.##.
    //: .................................
    //: .................................
    //: .....###.#......###.#......###.#.
    //: .###.##..#..###.##..#..###.##..#.
    //: ..#.#...#....#.#...#....#.#...#..
    //: ....#.#........#.#........#.#....
    //: .##...####..##..S####..##...####.
    //: .##..#...#..##..#...#..##..#...#.
    //: .......##.........##.........##..
    //: .##.#.####..##.#.####..##.#.####.
    //: .##..##.##..##..##.##..##..##.##.
    //: .................................
    //: .................................
    //: .....###.#......###.#......###.#.
    //: .###.##..#..###.##..#..###.##..#.
    //: ..#.#...#....#.#...#....#.#...#..
    //: ....#.#........#.#........#.#....
    //: .##...####..##...####..##...####.
    //: .##..#...#..##..#...#..##..#...#.
    //: .......##.........##.........##..
    //: .##.#.####..##.#.####..##.#.####.
    //: .##..##.##..##..##.##..##..##.##.
    //: .................................
    //: ```
    //:
    //: This is just a tiny three-map-by-three-map slice of the inexplicably-infinite farm layout; garden plots and rocks repeat as far as you can see. The Elf still starts on the one middle tile marked S, though - every other repeated S is replaced with a normal garden plot (.).
    //:
    //: Here are the number of reachable garden plots in this new infinite version of the example map for different numbers of steps:
    //:
    //: - In exactly `6` steps, he can still reach **`16`** garden plots.
    //: - In exactly `10` steps, he can reach any of **`50`** garden plots.
    //: - In exactly `50` steps, he can reach **`1594`** garden plots.
    //: - In exactly `100` steps, he can reach **`6536`** garden plots.
    //: - In exactly `500` steps, he can reach **`167004`** garden plots.
    //: - In exactly `1000` steps, he can reach **`668697`** garden plots.
    //: - In exactly `5000` steps, he can reach **`16733044`** garden plots.
    //:
    //: However, the step count the Elf needs is much larger! Starting from the garden plot marked S on your infinite map, **how many garden plots could the Elf reach in exactly 26501365 steps?**
    
    static func solveDay21Puzzle2() -> Int {
        let input = getDay21Input().as2DArray
        let start = input.getFirstPositionOfCharacter("S")!
        
        let N = 26_501_365
        let w = input.count
        
        let r = N % w
        let x = N / w
        
        let counts = fillGrid(input, start: start, steps: r + w)
        
        let y1 = counts[w - r - 2]
        let y2 = counts[r]
        let y3 = counts[r + w]
        
        let a = y3 + y1 - 2 * y2
        let b = y3 - y1
        let c = 2 * y2
        
        return ((a * x * x) + (b * x) + c) / 2
    }
    
    //: Geometric solution:
    //: https://github.com/villuna/aoc23/wiki/A-Geometric-solution-to-advent-of-code-2023,-day-21
}
