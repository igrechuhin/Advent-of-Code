import Atomics
import Foundation

extension AoC2024 {
    private static func getPuzzleInput(mode: AoCMode) -> String {
        getInput(day: .day8, mode: mode)
    }

    // --- Day 8: Resonant Collinearity ---
    // You find yourselves on the roof of a top-secret Easter Bunny installation.

    // While The Historians do their thing, you take a look at the familiar huge antenna. Much to your surprise, it seems to have been reconfigured to emit a signal that makes people 0.1% more likely to buy Easter Bunny brand Imitation Mediocre Chocolate as a Christmas gift! Unthinkable!

    // Scanning across the city, you find that there are actually many such antennas. Each antenna is tuned to a specific frequency indicated by a single lowercase letter, uppercase letter, or digit. You create a map (your puzzle input) of these antennas. For example:

    // ............
    // ........0...
    // .....0......
    // .......0....
    // ....0.......
    // ......A.....
    // ............
    // ............
    // ........A...
    // .........A..
    // ............
    // ............
    // The signal only applies its nefarious effect at specific antinodes based on the resonant frequencies of the antennas. In particular, an antinode occurs at any point that is perfectly in line with two antennas of the same frequency - but only when one of the antennas is twice as far away as the other. This means that for any pair of antennas with the same frequency, there are two antinodes, one on either side of them.

    // So, for these two antennas with frequency a, they create the two antinodes marked with #:

    // ..........
    // ...#......
    // ..........
    // ....a.....
    // ..........
    // .....a....
    // ..........
    // ......#...
    // ..........
    // ..........
    // Adding a third antenna with the same frequency creates several more antinodes. It would ideally add four antinodes, but two are off the right side of the map, so instead it adds only two:

    // ..........
    // ...#......
    // #.........
    // ....a.....
    // ........a.
    // .....a....
    // ..#.......
    // ......#...
    // ..........
    // ..........
    // Antennas with different frequencies don't create antinodes; A and a count as different frequencies. However, antinodes can occur at locations that contain antennas. In this diagram, the lone antenna with frequency capital A creates no antinodes but has a lowercase-a-frequency antinode at its location:

    // ..........
    // ...#......
    // #.........
    // ....a.....
    // ........a.
    // .....a....
    // ..#.......
    // ......A...
    // ..........
    // ..........
    // The first example has antennas with two different frequencies, so the antinodes they create look like this, plus an antinode overlapping the topmost A-frequency antenna:

    // ......#....#
    // ...#....0...
    // ....#0....#.
    // ..#....0....
    // ....0....#..
    // .#....A.....
    // ...#........
    // #......#....
    // ........A...
    // .........A..
    // ..........#.
    // ..........#.
    // Because the topmost A-frequency antenna overlaps with a 0-frequency antinode, there are 14 total unique locations that contain an antinode within the bounds of the map.

    // Calculate the impact of the signal. How many unique locations within the bounds of the map contain an antinode?

    // Your puzzle answer was 261.
    
    static func solveDay8Puzzle1(_ mode: AoCMode) -> Int {
        let map = getPuzzleInput(mode: mode).as2DArray
        let antennaLocations = map.antennasLocations.values
        
        var uniquePoints = Set<Point2D>()
        
        for locations in antennaLocations {
            for antenna1 in locations {
                for antenna2 in locations where antenna1 != antenna2 {
                    let antiNode = antiNodeLocation(antenna1, antenna2)
                    
                    if map.contains(point: antiNode) {
                        uniquePoints.insert(antiNode)
                    }
                }
            }
        }
        
        return uniquePoints.count
    }

    // --- Part Two ---
    // Watching over your shoulder as you work, one of The Historians asks if you took the effects of resonant harmonics into your calculations.

    // Whoops!

    // After updating your model, it turns out that an antinode occurs at any grid position exactly in line with at least two antennas of the same frequency, regardless of distance. This means that some of the new antinodes will occur at the position of each antenna (unless that antenna is the only one of its frequency).

    // So, these three T-frequency antennas now create many antinodes:

    // T....#....
    // ...T......
    // .T....#...
    // .........#
    // ..#.......
    // ..........
    // ...#......
    // ..........
    // ....#.....
    // ..........
    // In fact, the three T-frequency antennas are all exactly in line with two antennas, so they are all also antinodes! This brings the total number of antinodes in the above example to 9.

    // The original example now has 34 antinodes, including the antinodes that appear on every antenna:

    // ##....#....#
    // .#.#....0...
    // ..#.#0....#.
    // ..##...0....
    // ....0....#..
    // .#...#A....#
    // ...#..#.....
    // #....#.#....
    // ..#.....A...
    // ....#....A..
    // .#........#.
    // ...#......##
    // Calculate the impact of the signal using this updated model. How many unique locations within the bounds of the map contain an antinode?

    // Your puzzle answer was 898.
    
    static func solveDay8Puzzle2(_ mode: AoCMode) -> Int {
        let map = getPuzzleInput(mode: mode).as2DArray
        let antennaLocations = map.antennasLocations.values
        
        var uniquePoints = Set<Point2D>()
        
        for locations in antennaLocations {
            for antenna1 in locations {
                for antenna2 in locations where antenna1 != antenna2 {
                    for location in antiNodeLocations(antenna1, antenna2, map: map) {
                        uniquePoints.insert(location)
                    }
                }
            }
        }
        
        return uniquePoints.count
    }
}

private extension [[Character]] {
    var antennasLocations: [Character: [Point2D]] {
        var result = [Character: [Point2D]]()
        enumerated().forEach { y, row in
            row.enumerated().forEach { x, character in
                guard character != "." else { return }
                result[character, default: []].append(Point2D(y: y, x: x))
            }
        }
        return result
    }
}

private func antiNodeLocation(
    _ antenna1: Point2D,
    _ antenna2: Point2D
) -> Point2D {
    antenna1 + antenna1 - antenna2
}

private func antiNodeLocations(
    _ antenna1: Point2D,
    _ antenna2: Point2D,
    map: [[Character]]
) -> [Point2D] {
    let diff = antenna1 - antenna2
    var result = [Point2D]()
    var location = antenna1
    while map.contains(point: location) {
        result.append(location)
        location += diff
    }
    return result
}
