import Foundation

extension AoC2023 {
    private static func getDay18Input() -> String {
        //    """
        //    R 6 (#70c710)
        //    D 5 (#0dc571)
        //    L 2 (#5713f0)
        //    D 2 (#d2c081)
        //    R 2 (#59c680)
        //    D 2 (#411b91)
        //    L 5 (#8ceee2)
        //    U 2 (#caa173)
        //    L 1 (#1b58a2)
        //    U 2 (#caa171)
        //    R 2 (#7807d2)
        //    U 3 (#a77fa3)
        //    L 2 (#015232)
        //    U 2 (#7a21e3)
        //    """
        
        getInput(fileName: "Day18Input")
    }
    
    //: # --- Day 18: Lavaduct Lagoon ---
    //: Thanks to your efforts, the machine parts factory is one of the first factories up and running since the lavafall came back. However, to catch up with the large backlog of parts requests, the factory will also need a large supply of lava for a while; the Elves have already started creating a large lagoon nearby for this purpose.
    //:
    //: However, they aren't sure the lagoon will be big enough; they've asked you to take a look at the dig plan (your puzzle input). For example:
    //:
    //: ```
    //: R 6 (#70c710)
    //: D 5 (#0dc571)
    //: L 2 (#5713f0)
    //: D 2 (#d2c081)
    //: R 2 (#59c680)
    //: D 2 (#411b91)
    //: L 5 (#8ceee2)
    //: U 2 (#caa173)
    //: L 1 (#1b58a2)
    //: U 2 (#caa171)
    //: R 2 (#7807d2)
    //: U 3 (#a77fa3)
    //: L 2 (#015232)
    //: U 2 (#7a21e3)
    //: ```
    //:
    //: The digger starts in a 1 meter cube hole in the ground. They then dig the specified number of meters up (U), down (D), left (L), or right (R), clearing full 1 meter cubes as they go. The directions are given as seen from above, so if "up" were north, then "right" would be east, and so on. Each trench is also listed with the color that the edge of the trench should be painted as an RGB hexadecimal color code.
    //:
    //: When viewed from above, the above example dig plan would result in the following loop of trench (#) having been dug out from otherwise ground-level terrain (.):
    //:
    //: ```
    //: #######
    //: #.....#
    //: ###...#
    //: ..#...#
    //: ..#...#
    //: ###.###
    //: #...#..
    //: ##..###
    //: .#....#
    //: .######
    //: ```
    //:
    //: At this point, the trench could contain 38 cubic meters of lava. However, this is just the edge of the lagoon; the next step is to dig out the interior so that it is one meter deep as well:
    //:
    //: ```
    //: #######
    //: #######
    //: #######
    //: ..#####
    //: ..#####
    //: #######
    //: #####..
    //: #######
    //: .######
    //: .######
    //: ```
    //:
    //: Now, the lagoon can contain a much more respectable 62 cubic meters of lava. While the interior is dug out, the edges are also painted according to the color codes in the dig plan.
    //:
    //: The Elves are concerned the lagoon won't be large enough; if they follow their dig plan, how many cubic meters of lava could it hold?

    private struct DigStep {
        let direction: Direction2D
        let length: Int
        
        init(puzzle1: String) {
            let parts = puzzle1.components(separatedBy: " ")
            direction = parts[0].first!.direction
            length = Int(parts[1])!
        }
        
        init(puzzle2: String) {
            var value = puzzle2.components(separatedBy: "#")[1]
            value.removeLast()
            
            direction = value.removeLast().direction
            length = Int(value, radix: 16)!
        }
    }
    
    private struct DigPlan {
        private let vertices: [Point2D]
        
        init(digSteps: [DigStep]) {
            var point = Point2D.zero
            var vertices = [point]
            for step in digSteps {
                point += step.direction.point2D * step.length
                vertices.append(point)
            }
            vertices.removeLast()
            self.vertices = vertices
        }
        
        var area: Int {
            vertices.area
        }
    }
    
    static func solveDay18Puzzle1() -> Int {
        DigPlan(
            digSteps: getDay18Input()
                .components(separatedBy: .newlines)
                .filter { !$0.isEmpty }
                .map { DigStep(puzzle1: $0) }
        ).area
    }
    
    //: # --- Part Two ---
    //: The Elves were right to be concerned; the planned lagoon would be much too small.
    //:
    //: After a few minutes, someone realizes what happened; someone swapped the color and instruction parameters when producing the dig plan. They don't have time to fix the bug; one of them asks if you can extract the correct instructions from the hexadecimal codes.
    //:
    //: Each hexadecimal code is six hexadecimal digits long. The first five hexadecimal digits encode the distance in meters as a five-digit hexadecimal number. The last hexadecimal digit encodes the direction to dig: 0 means R, 1 means D, 2 means L, and 3 means U.
    //:
    //: So, in the above example, the hexadecimal codes can be converted into the true instructions:
    //:
    //: ```
    //: #70c710 = R 461937
    //: #0dc571 = D 56407
    //: #5713f0 = R 356671
    //: #d2c081 = D 863240
    //: #59c680 = R 367720
    //: #411b91 = D 266681
    //: #8ceee2 = L 577262
    //: #caa173 = U 829975
    //: #1b58a2 = L 112010
    //: #caa171 = D 829975
    //: #7807d2 = L 491645
    //: #a77fa3 = U 686074
    //: #015232 = L 5411
    //: #7a21e3 = U 500254
    //: ```
    //:
    //: Digging out this loop and its interior produces a lagoon that can hold an impressive 952408144115 cubic meters of lava.
    //:
    //: Convert the hexadecimal color codes into the correct instructions; if the Elves follow this new dig plan, how many cubic meters of lava could the lagoon hold?
    
    static func solveDay18Puzzle2() -> Int {
        DigPlan(
            digSteps: getDay18Input()
                .components(separatedBy: .newlines)
                .filter { !$0.isEmpty }
                .map { DigStep(puzzle2: $0) }
        ).area
    }
}

private extension Character {
    var direction: Direction2D {
        switch self {
        case "R", "0": return .east
        case "D", "1": return .south
        case "L", "2": return .west
        case "U", "3": return .north
        default: fatalError("Unsupported direction: \(self)")
        }
    }
}

private extension [Point2D] {
    var area: Int {
        var area = 0
        var perimeter = 0
        
        for vertexId in indices {
            let p1 = self[vertexId]
            let p2 = self[(vertexId + 1) % count]
            area += p1.x * p2.y - p2.x * p1.y
            // Simplified
            perimeter += abs(p1.x - p2.x) + abs(p1.y - p2.y)
        }
        
        area = abs(area) / 2
        perimeter = perimeter / 2
        //  The interior area of a polygon can be calculated using Pick's Theorem:
        //  I = A - B/2 + 1
        return area + perimeter + 1
    }
}
