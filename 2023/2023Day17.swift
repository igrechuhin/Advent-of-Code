import Foundation
import Collections

extension AoC2023 {
    private static func getDay17Input() -> String {
        //"""
        //2413432311323
        //3215453535623
        //3255245654254
        //3446585845452
        //4546657867536
        //1438598798454
        //4457876987766
        //3637877979653
        //4654967986887
        //4564679986453
        //1224686865563
        //2546548887735
        //4322674655533
        //"""
        
        getInput(fileName: "Day17Input")
    }
    
    //: # --- Day 17: Clumsy Crucible ---
    //: The lava starts flowing rapidly once the Lava Production Facility is operational. As you leave, the reindeer offers you a parachute, allowing you to quickly reach Gear Island.
    //:
    //: As you descend, your bird's-eye view of Gear Island reveals why you had trouble finding anyone on your way up: half of Gear Island is empty, but the half below you is a giant factory city!
    //:
    //: You land near the gradually-filling pool of lava at the base of your new **lavafall**. Lavaducts will eventually carry the lava throughout the city, but to make use of it immediately, Elves are loading it into large crucibles on wheels.
    //:
    //: The crucibles are top-heavy and pushed by hand. Unfortunately, the crucibles become very difficult to steer at high speeds, and so it can be hard to go in a straight line for very long.
    //:
    //: To get Desert Island the machine parts it needs as soon as possible, you'll need to find the best way to get the crucible **from the lava pool to the machine parts factory**. To do this, you need to minimize **heat loss** while choosing a route that doesn't require the crucible to go in a **straight line** for too long.
    //:
    //: Fortunately, the Elves here have a map (your puzzle input) that uses traffic patterns, ambient temperature, and hundreds of other parameters to calculate exactly how much heat loss can be expected for a crucible entering any particular city block.
    //:
    //: For example:
    //:
    //: ```
    //: 2413432311323
    //: 3215453535623
    //: 3255245654254
    //: 3446585845452
    //: 4546657867536
    //: 1438598798454
    //: 4457876987766
    //: 3637877979653
    //: 4654967986887
    //: 4564679986453
    //: 1224686865563
    //: 2546548887735
    //: 4322674655533
    //: ```
    //:
    //: Each city block is marked by a single digit that represents the **amount of heat loss if the crucible enters that block**. The starting point, the lava pool, is the top-left city block; the destination, the machine parts factory, is the bottom-right city block. (Because you already start in the top-left block, you don't incur that block's heat loss unless you leave that block and then return to it.)
    //:
    //: Because it is difficult to keep the top-heavy crucible going in a straight line for very long, it can move **at most three blocks** in a single direction before it must turn 90 degrees left or right. The crucible also can't reverse direction; after entering each city block, it may only turn left, continue straight, or turn right.
    //:
    //: One way to **minimize heat loss** is this path:
    //:
    //: ```
    //: 2>>34^>>>1323
    //: 32v>>>35v5623
    //: 32552456v>>54
    //: 3446585845v52
    //: 4546657867v>6
    //: 14385987984v4
    //: 44578769877v6
    //: 36378779796v>
    //: 465496798688v
    //: 456467998645v
    //: 12246868655<v
    //: 25465488877v5
    //: 43226746555v>
    //: ```
    //:
    //: This path never moves more than three consecutive blocks in the same direction and incurs a heat loss of only **`102`**.
    //:
    //: Directing the crucible from the lava pool to the machine parts factory, but not moving more than three consecutive blocks in the same direction, **what is the least heat loss it can incur?**

    struct Waypoint: Hashable, Comparable {
        let beam: Beam2D
        let heatLossSum: Int
        
        static func < (lhs: Waypoint, rhs: Waypoint) -> Bool {
            lhs.heatLossSum < rhs.heatLossSum
        }
    }
    
    private static func minHeatLoss(
        surface: [[Int]],
        start: Point2D,
        end: Point2D,
        block: (Point2D, Direction2D, Int) -> [Waypoint]
    ) -> Int {
        var heap = Heap([
            Waypoint(beam: Beam2D(point: .zero, direction: .east), heatLossSum: 0),
            Waypoint(beam: Beam2D(point: .zero, direction: .south), heatLossSum: 0)
        ])
        
        var minHeatLoss = Int.max
        
        while let current = heap.popMin() {
            if current.beam.point == end {
                minHeatLoss = min(minHeatLoss, current.heatLossSum)
                continue
            }
            if current.heatLossSum > minHeatLoss {
                continue
            }
            
            for direction in current.beam.direction.turnDirections {
                heap.insert(
                    contentsOf: block(current.beam.point, direction, current.heatLossSum)
                )
            }
        }
        
        return minHeatLoss
    }
    
    static func solveDay17Puzzle1() -> Int {
        let surface = getDay17Input()
            .as2DArray
            .map { $0.compactMap(\.wholeNumberValue) }
        
        var seen: [Beam2D: Int] = [:]
        
        return minHeatLoss(
            surface: surface,
            start: .zero,
            end: Point2D(y: surface.count - 1, x: surface[0].count - 1)
        ) { point, direction, currentHeatLossSum in
            var currentHeatLossSum = currentHeatLossSum
            var newWaypoints: [Waypoint] = []
            for offset in 1 ... 3 {
                let newPoint = point + (direction.point2D * offset)
                guard let newPointHeatLoss = surface[safe: newPoint] else { continue }
                currentHeatLossSum += newPointHeatLoss
                
                let newWaypoint = Waypoint(
                    beam: Beam2D(point: newPoint, direction: direction),
                    heatLossSum: currentHeatLossSum
                )
                if seen[newWaypoint.beam, default: .max] <= currentHeatLossSum {
                    continue
                }
                seen[newWaypoint.beam] = currentHeatLossSum
                newWaypoints.append(newWaypoint)
            }
            return newWaypoints
        }
    }
    
    //: # --- Part Two ---
    //: The crucibles of lava simply aren't large enough to provide an adequate supply of lava to the machine parts factory. Instead, the Elves are going to upgrade to **ultra crucibles**.
    //:
    //: Ultra crucibles are even more difficult to steer than normal crucibles. Not only do they have trouble going in a straight line, but they also have trouble turning!
    //:
    //: Once an ultra crucible starts moving in a direction, it needs to move **a minimum of four blocks** in that direction before it can turn (or even before it can stop at the end). However, it will eventually start to get wobbly: an ultra crucible can move a maximum of **ten consecutive blocks** without turning.
    //:
    //: In the above example, an ultra crucible could follow this path to minimize heat loss:
    //:
    //: ```
    //: 2>>>>>>>>1323
    //: 32154535v5623
    //: 32552456v4254
    //: 34465858v5452
    //: 45466578v>>>>
    //: 143859879845v
    //: 445787698776v
    //: 363787797965v
    //: 465496798688v
    //: 456467998645v
    //: 122468686556v
    //: 254654888773v
    //: 432267465553v
    //: ```
    //:
    //: In the above example, an ultra crucible would incur the minimum possible heat loss of **`94`**.
    //:
    //: Here's another example:
    //:
    //: ```
    //: 111111111111
    //: 999999999991
    //: 999999999991
    //: 999999999991
    //: 999999999991
    //: ```
    //:
    //: Sadly, an ultra crucible would need to take an unfortunate path like this one:
    //:
    //: ```
    //: 1>>>>>>>1111
    //: 9999999v9991
    //: 9999999v9991
    //: 9999999v9991
    //: 9999999v>>>>
    //: ```
    //:
    //: This route causes the ultra crucible to incur the minimum possible heat loss of **`71`**.
    //:
    //: Directing the **ultra crucible** from the lava pool to the machine parts factory, **what is the least heat loss it can incur?**
    
    static func solveDay17Puzzle2() -> Int {
        let surface = getDay17Input()
            .as2DArray
            .map { $0.compactMap(\.wholeNumberValue) }
        
        var seen: [Beam2D: Int] = [:]
        
        return minHeatLoss(
            surface: surface,
            start: .zero,
            end: Point2D(y: surface.count - 1, x: surface[0].count - 1)
        ) { point, direction, currentHeatLossSum in
            var currentHeatLossSum = currentHeatLossSum
            var newWaypoints: [Waypoint] = []
            for offset in 1 ... 3 {
                let newPoint = point + (direction.point2D * offset)
                guard let newPointHeatLoss = surface[safe: newPoint] else { continue }
                currentHeatLossSum += newPointHeatLoss
            }
            for offset in 4 ... 10 {
                let newPoint = point + (direction.point2D * offset)
                guard let newPointHeatLoss = surface[safe: newPoint] else { continue }
                currentHeatLossSum += newPointHeatLoss
                
                let newWaypoint = Waypoint(
                    beam: Beam2D(point: newPoint, direction: direction),
                    heatLossSum: currentHeatLossSum
                )
                if seen[newWaypoint.beam, default: .max] <= currentHeatLossSum {
                    continue
                }
                seen[newWaypoint.beam] = currentHeatLossSum
                newWaypoints.append(newWaypoint)
            }
            return newWaypoints
        }
    }
}

private extension Direction2D {
    var turnDirections: [Direction2D] {
        switch self {
        case .north, .south: return [.west, .east]
        case .west, .east: return [.north, .south]
        }
    }
}
