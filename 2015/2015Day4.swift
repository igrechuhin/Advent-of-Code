import Foundation
import CryptoKit

extension AoC2015 {
    private static func getPuzzleInput(mode: AoCMode) -> String {
        getInput(day: .day4, mode: mode)
    }
    
    private static func solveForPrefix(_ prefix: String, mode: AoCMode) -> Int {
        let secretKey = getPuzzleInput(mode: mode)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        var value = 1
        while !secretKey.appending("\(value)").md5.hasPrefix(prefix) {
            value += 1
        }
        return value
    }

    // --- Day 4: The Ideal Stocking Stuffer ---
    // Santa needs help mining some AdventCoins (very similar to bitcoins) to use as gifts for all the economically forward-thinking little girls and boys.

    // To do this, he needs to find MD5 hashes which, in hexadecimal, start with at least five zeroes. The input to the MD5 hash is some secret key (your puzzle input, given below) followed by a number in decimal. To mine AdventCoins, you must find Santa the lowest positive number (no leading zeroes: 1, 2, 3, ...) that produces such a hash.

    // For example:

    // If your secret key is abcdef, the answer is 609043, because the MD5 hash of abcdef609043 starts with five zeroes (000001dbbfa...), and it is the lowest such number to do so.
    // If your secret key is pqrstuv, the lowest number it combines with to make an MD5 hash starting with five zeroes is 1048970; that is, the MD5 hash of pqrstuv1048970 looks like 000006136ef....

    // Your puzzle answer was 117946.
    
    static func solveDay4Puzzle1(_ mode: AoCMode) -> Int {
        solveForPrefix("00000", mode: mode)
    }

    // --- Part Two ---
    // Now find one that starts with six zeroes.

    // Your puzzle answer was 3938038.
    
    static func solveDay4Puzzle2(_ mode: AoCMode) -> Int {
        solveForPrefix("000000", mode: mode)
    }
}
