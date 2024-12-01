import Foundation

private let testInput = false

extension AoC2015 {
    private static func getDay3Input() -> String {
        if testInput {
            //"""
            //>
            //"""
            
            //"""
            //^>v<
            //"""
            
"""
^v^v^v^v^v
"""
        } else {
            getInput(fileName: "Day3Input")
        }
    }
    
    //: # --- Day 3: Perfectly Spherical Houses in a Vacuum ---
    //: Santa is delivering presents to an infinite two-dimensional grid of houses.
    //:
    //: He begins by delivering a present to the house at his starting location, and then an elf at the North Pole calls him via radio and tells him where to move next. Moves are always exactly one house to the north (^), south (v), east (>), or west (<). After each move, he delivers another present to the house at his new location.
    //:
    //: However, the elf back at the north pole has had a little too much eggnog, and so his directions are a little off, and Santa ends up visiting some houses more than once. How many houses receive **at least one present?**
    //:
    //: For example:
    //:
    //: - `>` delivers presents to `2` houses: one at the starting location, and one to the east.
    //: - `^>v<` delivers presents to `4` houses in a square, including twice to the house at his starting/ending location.
    //: - `^v^v^v^v^v` delivers a bunch of presents to some very lucky children at only `2` houses.

    static func solveDay3Puzzle1() -> Int {
        let shifts = getDay3Input()
            .compactMap { Direction2D(raw: $0) }
            .map(\.point2D)
        var location = Point2D.zero
        var uniqLocations = Set([location])
        for shift in shifts {
            location += shift
            uniqLocations.insert(location)
        }
        return uniqLocations.count
    }
    
    //: --- Part Two ---
    //: The next year, to speed up the process, Santa creates a robot version of himself, **Robo-Santa**, to deliver presents with him.
    //:
    //: Santa and Robo-Santa start at the same location (delivering two presents to the same starting house), then take turns moving based on instructions from the elf, who is eggnoggedly reading from the same script as the previous year.
    //:
    //: This year, how many houses receive **at least one present**?
    //:
    //: For example:
    //:
    //: - `^v` delivers presents to `3` houses, because Santa goes north, and then Robo-Santa goes south.
    //: - `^>v<` now delivers presents to `3` houses, and Santa and Robo-Santa end up back where they started.
    //: - `^v^v^v^v^v` now delivers presents to `11` houses, with Santa going one direction and Robo-Santa going the other.
    
    static func solveDay3Puzzle2() -> Int {
        let shifts = getDay3Input()
            .compactMap { Direction2D(raw: $0) }
            .map(\.point2D)
        var santaLocation = Point2D.zero
        var roboSantaLocation = Point2D.zero
        var uniqLocations = Set([santaLocation])
        var shiftIndex = shifts.startIndex
        while shifts.indices.contains(shiftIndex) {
            santaLocation += shifts[shiftIndex]
            uniqLocations.insert(santaLocation)
            shiftIndex += 1
            guard shifts.indices.contains(shiftIndex) else { break }
            roboSantaLocation += shifts[shiftIndex]
            uniqLocations.insert(roboSantaLocation)
            shiftIndex += 1
        }
        return uniqLocations.count
    }
}

private extension Direction2D {
    init?(raw: Character) {
        switch raw {
        case "^": self = .north
        case ">": self = .east
        case "v": self = .south
        case "<": self = .west
        default: return nil
        }
    }
}
