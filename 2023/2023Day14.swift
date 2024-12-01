import Foundation

extension AoC2023 {
    private static func getDay14Input() -> String {
        //"""
        //O....#....
        //O.OO#....#
        //.....##...
        //OO.#O....O
        //.O.....O#.
        //O.#..O.#.#
        //..O..#O..O
        //.......O..
        //#....###..
        //#OO..#....
        //"""
        
        getInput(fileName: "Day14Input")
    }
    
    // --- Day 14: Parabolic Reflector Dish ---
    // You reach the place where all of the mirrors were pointing: a massive parabolic reflector dish attached to the side of another large mountain.
    
    // The dish is made up of many small mirrors, but while the mirrors themselves are roughly in the shape of a parabolic reflector dish, each individual mirror seems to be pointing in slightly the wrong direction. If the dish is meant to focus light, all it's doing right now is sending it in a vague direction.
    
    // This system must be what provides the energy for the lava! If you focus the reflector dish, maybe you can go where it's pointing and use the light to fix the lava production.
    
    // Upon closer inspection, the individual mirrors each appear to be connected via an elaborate system of ropes and pulleys to a large metal platform below the dish. The platform is covered in large rocks of various shapes. Depending on their position, the weight of the rocks deforms the platform, and the shape of the platform controls which ropes move and ultimately the focus of the dish.
    
    // In short: if you move the rocks, you can focus the dish. The platform even has a control panel on the side that lets you tilt it in one of four directions! The rounded rocks (O) will roll when the platform is tilted, while the cube-shaped rocks (#) will stay in place. You note the positions of all of the empty spaces (.) and rocks (your puzzle input). For example:
    
    // O....#....
    // O.OO#....#
    // .....##...
    // OO.#O....O
    // .O.....O#.
    // O.#..O.#.#
    // ..O..#O..O
    // .......O..
    // #....###..
    // #OO..#....
    // Start by tilting the lever so all of the rocks will slide north as far as they will go:
    
    // OOOO.#.O..
    // OO..#....#
    // OO..O##..O
    // O..#.OO...
    // ........#.
    // ..#....#.#
    // ..O..#.O.O
    // ..O.......
    // #....###..
    // #....#....
    // You notice that the support beams along the north side of the platform are damaged; to ensure the platform doesn't collapse, you should calculate the total load on the north support beams.
    
    // The amount of load caused by a single rounded rock (O) is equal to the number of rows from the rock to the south edge of the platform, including the row the rock is on. (Cube-shaped rocks (#) don't contribute to load.) So, the amount of load caused by each rock in each row is as follows:
    
    // OOOO.#.O.. 10
    // OO..#....#  9
    // OO..O##..O  8
    // O..#.OO...  7
    // ........#.  6
    // ..#....#.#  5
    // ..O..#.O.O  4
    // ..O.......  3
    // #....###..  2
    // #....#....  1
    // The total load is the sum of the load caused by all of the rounded rocks. In this example, the total load is 136.
    
    // Tilt the platform so that the rounded rocks all roll north. Afterward, what is the total load on the north support beams?
    
    // Your puzzle answer was 107430.

    static func solveDay14Puzzle1() -> Int {
        getDay14Input()
            .as2DArray
            .tilted(direction: .north)
            .totalLoadOnTheNorthSupportBeams
    }
    
    // --- Part Two ---
    // The parabolic reflector dish deforms, but not in a way that focuses the beam. To do that, you'll need to move the rocks to the edges of the platform. Fortunately, a button on the side of the control panel labeled "spin cycle" attempts to do just that!
    
    // Each cycle tilts the platform four times so that the rounded rocks roll north, then west, then south, then east. After each tilt, the rounded rocks roll as far as they can before the platform tilts in the next direction. After one cycle, the platform will have finished rolling the rounded rocks in those four directions in that order.
    
    // Here's what happens in the example above after each of the first few cycles:
    
    // After 1 cycle:
    // .....#....
    // ....#...O#
    // ...OO##...
    // .OO#......
    // .....OOO#.
    // .O#...O#.#
    // ....O#....
    // ......OOOO
    // #...O###..
    // #..OO#....
    
    // After 2 cycles:
    // .....#....
    // ....#...O#
    // .....##...
    // ..O#......
    // .....OOO#.
    // .O#...O#.#
    // ....O#...O
    // .......OOO
    // #..OO###..
    // #.OOO#...O
    
    // After 3 cycles:
    // .....#....
    // ....#...O#
    // .....##...
    // ..O#......
    // .....OOO#.
    // .O#...O#.#
    // ....O#...O
    // .......OOO
    // #...O###.O
    // #.OOO#...O
    // This process should work if you leave it running long enough, but you're still worried about the north support beams. To make sure they'll survive for a while, you need to calculate the total load on the north support beams after 1000000000 cycles.
    
    // In the above example, after 1000000000 cycles, the total load on the north support beams is 64.
    
    // Run the spin cycle for 1000000000 cycles. Afterward, what is the total load on the north support beams?
    
    // Your puzzle answer was 96317.
    
    static func solveDay14Puzzle2() -> Int {
        var surface = getDay14Input()
            .as2DArray
        
        var seenArray = [surface]
        var seenSet = Set(seenArray)
        let maxCycles = 1_000_000_000
        var loopStart: Int?
        var loopEnd: Int?
        for cycle in 1 ... maxCycles {
            surface = surface.cycle()
            if seenSet.contains(surface) {
                loopStart = seenArray.firstIndex(of: surface)
                loopEnd = cycle
                break
            }
            seenSet.insert(surface)
            seenArray.append(surface)
        }
        
        if let loopStart, let loopEnd {
            let targetSurfaceIndex = (maxCycles - loopStart) % (loopEnd - loopStart) + loopStart
            let targetSurface = seenArray[targetSurfaceIndex]
            return targetSurface.totalLoadOnTheNorthSupportBeams
        }
        
        return surface.totalLoadOnTheNorthSupportBeams
    }
}

private extension Character {
    static var empty: Character { Character(".") }
    static var squared: Character { Character("#") }
    static var rounded: Character { Character("O") }
}

private extension [[Character]] {
    func makeEmpty(_ size: Point2D) -> [[Character]] {
        var result: [[Character]] = []
        for _ in 0 ..< size.y {
            var row: [Character] = []
            for _ in 0 ..< size.x {
                row.append(.empty)
            }
            result.append(row)
        }
        return result
    }
    
    func loop(direction: Direction2D, closure: (Point2D) -> Void) {
        let size = Point2D(y: count, x: first?.count ?? 0)
        switch direction {
        case .north:
            for y in 0 ..< size.y {
                for x in 0 ..< size.x {
                    let position = Point2D(y: y, x: x)
                    closure(position)
                }
            }
        case .west:
            for x in 0 ..< size.x {
                for y in 0 ..< size.y {
                    let position = Point2D(y: y, x: x)
                    closure(position)
                }
            }
        case .south:
            for y in (0 ..< size.y).reversed() {
                for x in 0 ..< size.x {
                    let position = Point2D(y: y, x: x)
                    closure(position)
                }
            }
        case .east:
            for x in (0 ..< size.x).reversed() {
                for y in 0 ..< size.y {
                    let position = Point2D(y: y, x: x)
                    closure(position)
                }
            }
        }
    }
    
    func slideRock(
        surface: inout [[Character]],
        position: Point2D,
        direction: Direction2D
    ) {
        let shift = direction.point2D
        var position = position
        while surface[position.y][position.x] == .empty {
            position += shift
            
            guard surface.indices.contains(position.y),
                  surface[0].indices.contains(position.x)
            else {
                break
            }
        }
        position -= shift
        surface[position.y][position.x] = .rounded
    }
    
    func tilted(direction: Direction2D) -> [[Character]] {
        let copyAsIs: Set<Character> = [.empty, .squared]
        let size = Point2D(y: count, x: first?.count ?? 0)
        var result = makeEmpty(size)
        loop(direction: direction) { position in
            guard let ch = self[safe: position] else { return }
            if copyAsIs.contains(ch) {
                result[position.y][position.x] = ch
            } else {
                slideRock(surface: &result, position: position, direction: direction)
            }
        }
        return result
    }
    
    func cycle() -> [[Character]] {
        self
            .tilted(direction: .north)
            .tilted(direction: .west)
            .tilted(direction: .south)
            .tilted(direction: .east)
    }
    
    var totalLoadOnTheNorthSupportBeams: Int {
        reversed()
            .enumerated()
            .map { (index, row) in
                row.reduce(0) { $0 + ($1 == .rounded ? (index + 1) : 0) }
            }
            .sum
    }
}
