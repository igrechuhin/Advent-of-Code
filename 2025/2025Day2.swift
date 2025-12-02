import Foundation

extension AoC2025 {
    private static func getPuzzleInput(mode: AoCMode) -> [ClosedRange<Int>] {
        getInput(day: .day2, mode: mode)
            .components(separatedBy: .newlines)
            .filter(\.isNotEmpty)
            .first?
            .components(separatedBy: ",")
            .compactMap { rawRange in
                let lowHigh = rawRange.components(separatedBy: "-")
                guard lowHigh.count == 2 else { return nil }
                guard let lowString = lowHigh.first, let highString = lowHigh.last else { return nil }
                guard let low = Int(lowString), let high = Int(highString) else { return nil }
                return low ... high
            } ?? []
    }

    // --- Day 2: Gift Shop ---
    // You get inside and take the elevator to its only other stop: the gift shop. "Thank you for visiting the North Pole!" gleefully exclaims a nearby sign. You aren't sure who is even allowed to visit the North Pole, but you know you can access the lobby through here, and from there you can access the rest of the North Pole base.

    // As you make your way through the surprisingly extensive selection, one of the clerks recognizes you and asks for your help.

    // As it turns out, one of the younger Elves was playing on a gift shop computer and managed to add a whole bunch of invalid product IDs to their gift shop database! Surely, it would be no trouble for you to identify the invalid product IDs for them, right?

    // They've even checked most of the product ID ranges already; they only have a few product ID ranges (your puzzle input) that you'll need to check. For example:

    // 11-22,95-115,998-1012,1188511880-1188511890,222220-222224,
    // 1698522-1698528,446443-446449,38593856-38593862,565653-565659,
    // 824824821-824824827,2121212118-2121212124
    // (The ID ranges are wrapped here for legibility; in your input, they appear on a single long line.)

    // The ranges are separated by commas (,); each range gives its first ID and last ID separated by a dash (-).

    // Since the young Elf was just doing silly patterns, you can find the invalid IDs by looking for any ID which is made only of some sequence of digits repeated twice. So, 55 (5 twice), 6464 (64 twice), and 123123 (123 twice) would all be invalid IDs.

    // None of the numbers have leading zeroes; 0101 isn't an ID at all. (101 is a valid ID that you would ignore.)

    // Your job is to find all of the invalid IDs that appear in the given ranges. In the above example:

    // 11-22 has two invalid IDs, 11 and 22.
    // 95-115 has one invalid ID, 99.
    // 998-1012 has one invalid ID, 1010.
    // 1188511880-1188511890 has one invalid ID, 1188511885.
    // 222220-222224 has one invalid ID, 222222.
    // 1698522-1698528 contains no invalid IDs.
    // 446443-446449 has one invalid ID, 446446.
    // 38593856-38593862 has one invalid ID, 38593859.
    // The rest of the ranges contain no invalid IDs.
    // Adding up all the invalid IDs in this example produces 1227775554.

    // What do you get if you add up all of the invalid IDs?

    // Your puzzle answer was 44854383294.
    static func solveDay2Puzzle1(_ mode: AoCMode) -> Int {
        let ranges = getPuzzleInput(mode: mode)

        var sum = 0
        for range in ranges {
            for value in range where isRepeatedTwiceMath(value) {
                sum += value
            }
        }

        return sum
    }

    // --- Part Two ---
    // The clerk quickly discovers that there are still invalid IDs in the ranges in your list. Maybe the young Elf was doing other silly patterns as well?

    // Now, an ID is invalid if it is made only of some sequence of digits repeated at least twice. So, 12341234 (1234 two times), 123123123 (123 three times), 1212121212 (12 five times), and 1111111 (1 seven times) are all invalid IDs.

    // From the same example as before:

    // 11-22 still has two invalid IDs, 11 and 22.
    // 95-115 now has two invalid IDs, 99 and 111.
    // 998-1012 now has two invalid IDs, 999 and 1010.
    // 1188511880-1188511890 still has one invalid ID, 1188511885.
    // 222220-222224 still has one invalid ID, 222222.
    // 1698522-1698528 still contains no invalid IDs.
    // 446443-446449 still has one invalid ID, 446446.
    // 38593856-38593862 still has one invalid ID, 38593859.
    // 565653-565659 now has one invalid ID, 565656.
    // 824824821-824824827 now has one invalid ID, 824824824.
    // 2121212118-2121212124 now has one invalid ID, 2121212121.
    // Adding up all the invalid IDs in this example produces 4174379265.

    // What do you get if you add up all of the invalid IDs using these new rules?

    // Your puzzle answer was 55647141923.
    static func solveDay2Puzzle2(_ mode: AoCMode) -> Int {
        let ranges = getPuzzleInput(mode: mode)

        var sum = 0
        for range in ranges {
            for value in range where isRepeatedBlock(value) {
                sum += value
            }
        }

        return sum
    }
}

private func isRepeatedTwiceMath(_ number: Int) -> Bool {
    guard number > 0 else { return false }

    let totalDigits = countDigits(number)
    guard totalDigits % 2 == 0 && totalDigits > 1 else { return false }

    let halfDigits = totalDigits / 2

    let firstHalf = number / pow10(halfDigits)
    let secondHalf = number % pow10(halfDigits)

    return firstHalf == secondHalf
}

private func countDigits(_ number: Int) -> Int {
    var num = abs(number)
    var count = 0
    repeat {
        count += 1
        num /= 10
    } while num > 0
    return count
}

private func pow10(_ power: Int) -> Int {
    var result = 1
    for _ in 0..<power {
        result *= 10
    }
    return result
}

private func digitCount(_ num: Int) -> Int {
    var n = num
    var c = 0
    while n > 0 {
        c += 1
        n /= 10
    }
    return c
}

private func isRepeatedBlock(_ x: Int) -> Bool {
    if x <= 0 { return false }
    let digitsCount = digitCount(x)

    let maxBlockLen = digitsCount / 2
    guard maxBlockLen >= 1 else { return false }

    for blockLen in 1...maxBlockLen {
        if digitsCount % blockLen != 0 { continue }
        let times = digitsCount / blockLen
        if times < 2 { continue }

        let base = pow10(blockLen)
        var tmp = x
        let block = tmp % base
        var ok = true

        for _ in 1..<times {
            tmp /= base
            if tmp % base != block {
                ok = false
                break
            }
        }

        if ok { return true }
    }

    return false
}
