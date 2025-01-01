import Foundation
import Collections

extension AoC2015 {
    private static func getPuzzleInput(mode: AoCMode) -> String {
        getInput(day: .day7, mode: mode)
    }

    // --- Day 7: Some Assembly Required ---
    // This year, Santa brought little Bobby Tables a set of wires and bitwise logic gates! Unfortunately, little Bobby is a little under the recommended age range, and he needs help assembling the circuit.

    // Each wire has an identifier (some lowercase letters) and can carry a 16-bit signal (a number from 0 to 65535). A signal is provided to each wire by a gate, another wire, or some specific value. Each wire can only get a signal from one source, but can provide its signal to multiple destinations. A gate provides no signal until all of its inputs have a signal.

    // The included instructions booklet describes how to connect the parts together: x AND y -> z means to connect wires x and y to an AND gate, and then connect its output to wire z.

    // For example:

    // 123 -> x means that the signal 123 is provided to wire x.
    // x AND y -> z means that the bitwise AND of wire x and wire y is provided to wire z.
    // p LSHIFT 2 -> q means that the value from wire p is left-shifted by 2 and then provided to wire q.
    // NOT e -> f means that the bitwise complement of the value from wire e is provided to wire f.
    // Other possible gates include OR (bitwise OR) and RSHIFT (right-shift). If, for some reason, you'd like to emulate the circuit instead, almost all programming languages (for example, C, JavaScript, or Python) provide operators for these gates.

    // For example, here is a simple circuit:

    // 123 -> x
    // 456 -> y
    // x AND y -> d
    // x OR y -> e
    // x LSHIFT 2 -> f
    // y RSHIFT 2 -> g
    // NOT x -> h
    // NOT y -> i
    // After it is run, these are the signals on the wires:

    // d: 72
    // e: 507
    // f: 492
    // g: 114
    // h: 65412
    // i: 65079
    // x: 123
    // y: 456
    // In little Bobby's kit's instructions booklet (provided as your puzzle input), what signal is ultimately provided to wire a?

    // Your puzzle answer was 46065.

    static func solveDay7Puzzle1(_ mode: AoCMode) -> UInt16? {
        getPuzzleInput(mode: mode)
            .components(separatedBy: .newlines)
            .filter(\.isNotEmpty)
            .getWires()
            .evaluate()["a"]
    }

    // --- Part Two ---
    // Now, take the signal you got on wire a, override wire b to that signal, and reset the other wires (including wire a). What new signal is ultimately provided to wire a?

    // Your puzzle answer was 14134.

    static func solveDay7Puzzle2(_ mode: AoCMode) -> UInt16? {
        guard let bOverride = solveDay7Puzzle1(mode) else { return nil }

        return getPuzzleInput(mode: mode)
            .components(separatedBy: .newlines)
            .filter(\.isNotEmpty)
            .getWires()
            .map {
                if let value = $0 as? Value, value.output == "b" {
                    return Value(input: String(bOverride), output: "b")
                }
                return $0
            }.evaluate()["a"]
    }
}

private extension [String: UInt16] {
    func getValue(_ key: Key) -> UInt16? {
        UInt16(key) ?? self[key]
    }
}

private protocol Wire {}

private extension [Wire] {
    func evaluate() -> [String: UInt16] {
        var wires = self
        var values = [String: UInt16]()
        while !wires.isEmpty {
            wires = wires.filter { wire in
                switch wire {
                case let value as Value:
                    guard let resolved = values.getValue(value.input) else { return true }
                    values[value.output] = resolved
                    return false

                case let notGate as NotGate:
                    guard let resolved = values.getValue(notGate.input) else { return true }
                    values[notGate.output] = ~resolved
                    return false

                case let binaryGate as BinaryGate:
                    guard let v1 = values.getValue(binaryGate.input1),
                          let v2 = values.getValue(binaryGate.input2)
                    else { return true }
                    values[binaryGate.output] = binaryGate.calculateOutput(v1: v1, v2: v2)
                    return false

                default:
                    fatalError("Unknown wire type")
                }
            }
        }

        return values
    }
}

private struct Value: Wire {
    let input: String
    let output: String
}

private struct BinaryGate: Wire {
    let input1: String
    let input2: String
    let operation: String
    let output: String
    
    func calculateOutput(v1: UInt16, v2: UInt16) -> UInt16 {
        switch operation {
        case "AND": v1 & v2
        case "OR": v1 | v2
        case "LSHIFT": v1 << v2
        case "RSHIFT": v1 >> v2
        default: fatalError("Unknown operation \(operation)")
        }
    }
}

private struct NotGate: Wire {
    let input: String
    let output: String
}

private extension [String] {
    func getWires() -> [Wire] {
        compactMap { input in
            guard let match = input.wholeMatch(
                of: /(?:(\w+) )?(AND|OR|LSHIFT|RSHIFT|NOT)? ?(\w+) -> (\w+)/
            ) else { return nil }
            
            let input1 = match.output.1.map { String($0) }
            let operation = match.output.2.map { String($0) }
            let input2 = String(match.output.3)
            let output = String(match.output.4)

            guard let input1 else { return Value(input: input2, output: output) }
            guard let operation else { return NotGate(input: input2, output: output) }
            return BinaryGate(input1: input1, input2: input2, operation: operation, output: output)
        }
    }
}
