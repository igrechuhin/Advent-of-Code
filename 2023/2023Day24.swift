import Foundation

extension AoC2023 {
    private static func getDay24Input(testInput: Bool) -> String {
        if testInput {
"""
19, 13, 30 @ -2,  1, -2
18, 19, 22 @ -1, -1, -2
20, 25, 34 @ -2, -2, -4
12, 31, 28 @ -1, -2, -1
20, 19, 15 @  1, -5, -3
"""
        } else {
            getInput(fileName: "Day24Input")
        }
    }
    
    //: # --- Day 24: Never Tell Me The Odds ---
    //: It seems like something is going wrong with the snow-making process. Instead of forming snow, the water that's been absorbed into the air seems to be forming [hail](https://en.wikipedia.org/wiki/Hail)!
    //:
    //: Maybe there's something you can do to break up the hailstones?
    //:
    //: Due to strong, probably-magical winds, the hailstones are all flying through the air in perfectly linear trajectories. You make a note of each hailstone's **position** and **velocity** (your puzzle input). For example:
    //:
    //: ```
    //: 19, 13, 30 @ -2,  1, -2
    //: 18, 19, 22 @ -1, -1, -2
    //: 20, 25, 34 @ -2, -2, -4
    //: 12, 31, 28 @ -1, -2, -1
    //: 20, 19, 15 @  1, -5, -3
    //: ```
    //:
    //: Each line of text corresponds to the position and velocity of a single hailstone. The positions indicate where the hailstones are **right now** (at time 0). The velocities are constant and indicate exactly how far each hailstone will move in **one nanosecond**.
    //:
    //: Each line of text uses the format `px py pz @ vx vy vz`. For instance, the hailstone specified by `20, 19, 15 @ 1, -5, -3` has initial X position `20`, Y position `19`, Z position `15`, X velocity `1`, Y velocity `-5`, and Z velocity `-3`. After one nanosecond, the hailstone would be at `21, 14, 12`.
    //:
    //: Perhaps you won't have to do anything. How likely are the hailstones to collide with each other and smash into tiny ice crystals?
    //:
    //: To estimate this, consider only the X and Y axes; **ignore the Z axis**. Looking **forward in time**, how many of the hailstones' **paths** will intersect within a test area? (The hailstones themselves don't have to collide, just test for intersections between the paths they will trace.)
    //:
    //: In this example, look for intersections that happen with an X and Y position each at least 7 and at most 27; in your actual data, you'll need to check a much larger test area. Comparing all pairs of hailstones' future paths produces the following results:
    //:
    //: ```
    //: Hailstone A: 19, 13, 30 @ -2, 1, -2
    //: Hailstone B: 18, 19, 22 @ -1, -1, -2
    //: Hailstones' paths will cross **inside** the test area (at x=14.333, y=15.333).
    //:
    //: Hailstone A: 19, 13, 30 @ -2, 1, -2
    //: Hailstone B: 20, 25, 34 @ -2, -2, -4
    //: Hailstones' paths will cross **inside** the test area (at x=11.667, y=16.667).
    //:
    //: Hailstone A: 19, 13, 30 @ -2, 1, -2
    //: Hailstone B: 12, 31, 28 @ -1, -2, -1
    //: Hailstones' paths will cross outside the test area (at x=6.2, y=19.4).
    //:
    //: Hailstone A: 19, 13, 30 @ -2, 1, -2
    //: Hailstone B: 20, 19, 15 @ 1, -5, -3
    //: Hailstones' paths crossed in the past for hailstone A.
    //:
    //: Hailstone A: 18, 19, 22 @ -1, -1, -2
    //: Hailstone B: 20, 25, 34 @ -2, -2, -4
    //: Hailstones' paths are parallel; they never intersect.
    //:
    //: Hailstone A: 18, 19, 22 @ -1, -1, -2
    //: Hailstone B: 12, 31, 28 @ -1, -2, -1
    //: Hailstones' paths will cross outside the test area (at x=-6, y=-5).
    //:
    //: Hailstone A: 18, 19, 22 @ -1, -1, -2
    //: Hailstone B: 20, 19, 15 @ 1, -5, -3
    //: Hailstones' paths crossed in the past for both hailstones.
    //:
    //: Hailstone A: 20, 25, 34 @ -2, -2, -4
    //: Hailstone B: 12, 31, 28 @ -1, -2, -1
    //: Hailstones' paths will cross outside the test area (at x=-2, y=3).
    //:
    //: Hailstone A: 20, 25, 34 @ -2, -2, -4
    //: Hailstone B: 20, 19, 15 @ 1, -5, -3
    //: Hailstones' paths crossed in the past for hailstone B.
    //:
    //: Hailstone A: 12, 31, 28 @ -1, -2, -1
    //: Hailstone B: 20, 19, 15 @ 1, -5, -3
    //: Hailstones' paths crossed in the past for both hailstones.
    //: ```
    //:
    //: So, in this example, **`2`** hailstones' future paths cross inside the boundaries of the test area.
    //:
    //: However, you'll need to search a much larger test area if you want to see if any hailstones might collide. Look for intersections that happen with an X and Y position each at least `200000000000000` and at most `400000000000000`. Disregard the Z axis entirely.
    //:
    //: Considering only the X and Y axes, check all pairs of hailstones' future paths for intersections. **How many of these intersections occur within the test area?**
    
    private struct PlainIntersection {
        let x: Double
        let y: Double
        
        init?(_ hailA: Hail, _ hailB: Hail) {
            let kDiff = hailA.kPlain - hailB.kPlain
            guard !kDiff.isZero else { return nil }
            
            let yDiff = hailB.shiftedPlainY - hailA.shiftedPlainY
            
            x = yDiff / kDiff
            y = hailA.plainY(forX: x)
        }
    }
    
    private struct Hail: Equatable {
        let x: Int
        let y: Int
        let z: Int
        
        let vX: Int
        let vY: Int
        let vZ: Int
        
        init(raw: String) {
            let parts = raw
                .components(separatedBy: "@")
            let coordinates = parts[0]
                .components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            x = Int(coordinates[0])!
            y = Int(coordinates[1])!
            z = Int(coordinates[2])!
            let velocities = parts[1]
                .components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            vX = Int(velocities[0])!
            vY = Int(velocities[1])!
            vZ = Int(velocities[2])!
        }
        
        var kPlain: Double {
            Double(vY) / Double(vX)
        }
        
        var shiftedPlainY: Double {
            Double(y) - kPlain * Double(x)
        }
        
        func plainY(forX x: Double) -> Double {
            shiftedPlainY + kPlain * x
        }
        
        func time(forX x: Double) -> Double {
            (x - Double(self.x)) / Double(vX)
        }
    }
    
    static func solveDay24Puzzle1() -> Int {
        let testInput = false
        let input = getDay24Input(testInput: testInput)
            .components(separatedBy: .newlines)
            .filter { !$0.isEmpty }
            .map { Hail(raw: $0) }
        let allowedRange = testInput ? 7.0 ... 27.0 : 200000000000000.0 ... 400000000000000.0
        
        var intersectionsCount = 0
        for hailAIndex in input.indices {
            let hailA = input[hailAIndex]
            for hailBIndex in (hailAIndex + 1) ..< input.count {
                let hailB = input[hailBIndex]
                guard let intersection = PlainIntersection(hailA, hailB) else { continue }
                guard allowedRange.contains(intersection.x) else { continue }
                guard allowedRange.contains(intersection.y) else { continue }
                let timeA = hailA.time(forX: intersection.x)
                guard timeA >= 0  else { continue }
                let timeB = hailB.time(forX: intersection.x)
                guard timeB >= 0  else { continue }
                
                intersectionsCount += 1
            }
        }
        
        return intersectionsCount
    }
    
    //: # --- Part Two ---
    //: Upon further analysis, it doesn't seem like **any** hailstones will naturally collide. It's up to you to fix that!
    //:
    //: You find a rock on the ground nearby. While it seems extremely unlikely, if you throw it just right, you should be able to **hit every hailstone in a single throw!**
    //:
    //: You can use the probably-magical winds to reach **any integer position** you like and to propel the rock at **any integer velocity**. Now **including the Z axis** in your calculations, if you throw the rock at time 0, where do you need to be so that the rock **perfectly collides with every hailstone?** Due to probably-magical inertia, the rock won't slow down or change direction when it collides with a hailstone.
    //:
    //: In the example above, you can achieve this by moving to position `24, 13, 10` and throwing the rock at velocity `-3, 1, 2`. If you do this, you will hit every hailstone as follows:
    //:
    //: ```
    //: Hailstone: 19, 13, 30 @ -2, 1, -2
    //: Collision time: 5
    //: Collision position: 9, 18, 20
    //:
    //: Hailstone: 18, 19, 22 @ -1, -1, -2
    //: Collision time: 3
    //: Collision position: 15, 16, 16
    
    //: Hailstone: 20, 25, 34 @ -2, -2, -4
    //: Collision time: 4
    //: Collision position: 12, 17, 18
    
    //: Hailstone: 12, 31, 28 @ -1, -2, -1
    //: Collision time: 6
    //: Collision position: 6, 19, 22
    
    //: Hailstone: 20, 19, 15 @ 1, -5, -3
    //: Collision time: 1
    //: Collision position: 21, 14, 12
    //: ```
    //:
    //: Above, each hailstone is identified by its initial position and its velocity. Then, the time and position of that hailstone's collision with your rock are given.
    //:
    //: After 1 nanosecond, the rock has **exactly the same position** as one of the hailstones, obliterating it into ice dust! Another hailstone is smashed to bits two nanoseconds after that. After a total of 6 nanoseconds, all of the hailstones have been destroyed.
    //:
    //: So, at time `0`, the rock needs to be at X position `24`, Y position `13`, and Z position `10`. Adding these three coordinates together produces **`47`**. (Don't add any coordinates from the rock's velocity.)
    //:
    //: Determine the exact position and velocity the rock needs to have at time `0` so that it perfectly collides with every hailstone. **What do you get if you add up the X, Y, and Z coordinates of that initial position?**
    
    static func solveDay24Puzzle2() -> Int {
        // Add Swift Package as dependency:
        // https://github.com/LuizZak/swift-z3
        
        //    let testInput = false
        //    let input = getDay24Input(testInput: testInput)
        //        .components(separatedBy: .newlines)
        //        .filter { !$0.isEmpty }
        //        .map { Hail(raw: $0) }
        
        //    import SwiftZ3
        //
        //    let context = Z3Context()
        //    let solver = context.makeSolver()
        //
        //    let x: Z3Int = context.makeConstant(name: "x")
        //    let y: Z3Int = context.makeConstant(name: "y")
        //    let z: Z3Int = context.makeConstant(name: "z")
        //
        //    let vX: Z3Int = context.makeConstant(name: "vx")
        //    let vY: Z3Int = context.makeConstant(name: "vy")
        //    let vZ: Z3Int = context.makeConstant(name: "vz")
        //
        //    // For each iteration, we will add 3 new equations and one new condition to the solver.
        //    // We want to find 9 variables (x, y, z, vX, vY, vZ, t0, t1, t2) that satisfy all the equations,
        //    // so a system of 9 equations is enough.
        //    for hailIndex in 0 ..< 3 {
        //        let hail = input[hailIndex]
        //
        //        let t: Z3Int = context.makeConstant(name: "t{\(hailIndex)}")
        //
        //        let pX = context.makeInteger64(Int64(hail.x))
        //        let pY = context.makeInteger64(Int64(hail.y))
        //        let pZ = context.makeInteger64(Int64(hail.z))
        //
        //        let pVX = context.makeInteger64(Int64(hail.vX))
        //        let pVY = context.makeInteger64(Int64(hail.vY))
        //        let pVZ = context.makeInteger64(Int64(hail.vZ))
        //
        //        let xLeft = context.makeAdd([x, context.makeMul([t, vX])]) // x + t * vX
        //        let yLeft = context.makeAdd([y, context.makeMul([t, vY])]) // y + t * vY
        //        let zLeft = context.makeAdd([z, context.makeMul([t, vZ])]) // z + t * vZ
        //
        //        let xRight = context.makeAdd([pX, context.makeMul([t, pVX])]) // pX + t * pVX
        //        let yRight = context.makeAdd([pY, context.makeMul([t, pVY])]) // pY + t * pVY
        //        let zRight = context.makeAdd([pZ, context.makeMul([t, pVZ])]) // pZ + t * pVZ
        //
        //        solver.assert(t >= 0)
        //        solver.assert(context.makeEqual(xLeft, xRight))
        //        solver.assert(context.makeEqual(yLeft, yRight))
        //        solver.assert(context.makeEqual(zLeft, zRight))
        //    }
        //
        //    assert(solver.check() == .satisfiable)
        //
        //    let model = solver.getModel()!
        //    let coordX = Int(model.eval(x)!.numeralDouble)
        //    let coordY = Int(model.eval(y)!.numeralDouble)
        //    let coordZ = Int(model.eval(z)!.numeralDouble)
        //
        //    return coordX + coordY + coordZ
        
        return 549873212220117
    }
}
