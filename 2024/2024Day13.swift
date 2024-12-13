import Foundation

extension AoC2024 {
    private static func getPuzzleInput(mode: AoCMode) -> String {
        getInput(day: .day13, mode: mode)
    }

    // --- Day 13: Claw Contraption ---
    // Next up: the lobby of a resort on a tropical island. The Historians take a moment to admire the hexagonal floor tiles before spreading out.

    // Fortunately, it looks like the resort has a new arcade! Maybe you can win some prizes from the claw machines?

    // The claw machines here are a little unusual. Instead of a joystick or directional buttons to control the claw, these machines have two buttons labeled A and B. Worse, you can't just put in a token and play; it costs 3 tokens to push the A button and 1 token to push the B button.

    // With a little experimentation, you figure out that each machine's buttons are configured to move the claw a specific amount to the right (along the X axis) and a specific amount forward (along the Y axis) each time that button is pressed.

    // Each machine contains one prize; to win the prize, the claw must be positioned exactly above the prize on both the X and Y axes.

    // You wonder: what is the smallest number of tokens you would have to spend to win as many prizes as possible? You assemble a list of every machine's button behavior and prize location (your puzzle input). For example:

    // Button A: X+94, Y+34
    // Button B: X+22, Y+67
    // Prize: X=8400, Y=5400

    // Button A: X+26, Y+66
    // Button B: X+67, Y+21
    // Prize: X=12748, Y=12176

    // Button A: X+17, Y+86
    // Button B: X+84, Y+37
    // Prize: X=7870, Y=6450

    // Button A: X+69, Y+23
    // Button B: X+27, Y+71
    // Prize: X=18641, Y=10279
    // This list describes the button configuration and prize location of four different claw machines.

    // For now, consider just the first claw machine in the list:

    // Pushing the machine's A button would move the claw 94 units along the X axis and 34 units along the Y axis.
    // Pushing the B button would move the claw 22 units along the X axis and 67 units along the Y axis.
    // The prize is located at X=8400, Y=5400; this means that from the claw's initial position, it would need to move exactly 8400 units along the X axis and exactly 5400 units along the Y axis to be perfectly aligned with the prize in this machine.
    // The cheapest way to win the prize is by pushing the A button 80 times and the B button 40 times. This would line up the claw along the X axis (because 80*94 + 40*22 = 8400) and along the Y axis (because 80*34 + 40*67 = 5400). Doing this would cost 80*3 tokens for the A presses and 40*1 for the B presses, a total of 280 tokens.

    // For the second and fourth claw machines, there is no combination of A and B presses that will ever win a prize.

    // For the third claw machine, the cheapest way to win the prize is by pushing the A button 38 times and the B button 86 times. Doing this would cost a total of 200 tokens.

    // So, the most prizes you could possibly win is two; the minimum tokens you would have to spend to win all (two) prizes is 480.

    // You estimate that each button would need to be pressed no more than 100 times to win a prize. How else would someone be expected to play?

    // Figure out how to win as many prizes as possible. What is the fewest tokens you would have to spend to win all possible prizes?

    // Your puzzle answer was 36758.
    
    static func solveDay13Puzzle1(_ mode: AoCMode) -> Int {
        getPuzzleInput(mode: mode)
            .components(separatedBy: "\n\n")
            .map { $0.trimmingCharacters(in: .newlines) }
            .map { Machine(raw: $0) }
            .compactMap(\.numberOfPresses)
            .map { 3 * $0.aCount + $0.bCount }
            .sum
    }

    // --- Part Two ---
    // As you go to win the first prize, you discover that the claw is nowhere near where you expected it would be. Due to a unit conversion error in your measurements, the position of every prize is actually 10000000000000 higher on both the X and Y axis!

    // Add 10000000000000 to the X and Y position of every prize. After making this change, the example above would now look like this:

    // Button A: X+94, Y+34
    // Button B: X+22, Y+67
    // Prize: X=10000000008400, Y=10000000005400

    // Button A: X+26, Y+66
    // Button B: X+67, Y+21
    // Prize: X=10000000012748, Y=10000000012176

    // Button A: X+17, Y+86
    // Button B: X+84, Y+37
    // Prize: X=10000000007870, Y=10000000006450

    // Button A: X+69, Y+23
    // Button B: X+27, Y+71
    // Prize: X=10000000018641, Y=10000000010279
    // Now, it is only possible to win a prize on the second and fourth claw machines. Unfortunately, it will take many more than 100 presses to do so.

    // Using the corrected prize coordinates, figure out how to win as many prizes as possible. What is the fewest tokens you would have to spend to win all possible prizes?

    // Your puzzle answer was 76358113886726.

    static func solveDay13Puzzle2(_ mode: AoCMode) -> Int {
        getPuzzleInput(mode: mode)
            .components(separatedBy: "\n\n")
            .map { $0.trimmingCharacters(in: .newlines) }
            .map { Machine(raw: $0, prizeShift: 10000000000000) }
            .compactMap(\.numberOfPresses)
            .map { 3 * $0.aCount + $0.bCount }
            .sum
    }
}

private struct Machine {
    let a: Point2D
    let b: Point2D
    let prize: Point2D
    
    init(raw: String, prizeShift: Int = 0) {
        let numbers = raw.matches(of: /\d+/)
        
        a = Point2D(y: Int(numbers[1].0)!, x: Int(numbers[0].0)!)
        b = Point2D(y: Int(numbers[3].0)!, x: Int(numbers[2].0)!)
        prize = Point2D(y: Int(numbers[5].0)! + prizeShift, x: Int(numbers[4].0)! + prizeShift)
    }

    var numberOfPresses: (aCount: Int, bCount: Int)? {
        let zA = a.x*b.y - a.y*b.x
        let pA = prize.x*b.y - prize.y*b.x
        guard zA != 0, pA.isMultiple(of: zA) else { return nil }

        let zB = b.x*a.y - b.y*a.x
        let pB = prize.x*a.y - prize.y*a.x
        guard zB != 0, pB.isMultiple(of: zB) else { return nil }
        
        return (aCount: pA / zA, bCount: pB / zB)
    }
}
