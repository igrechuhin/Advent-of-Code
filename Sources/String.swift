import Foundation
import CryptoKit

extension String {
    var as2DArray: [[Character]] {
        self
            .components(separatedBy: .newlines)
            .filter { !$0.isEmpty }
            .map { Array($0) }
    }

    var md5: String {
        Insecure.MD5
            .hash(data: Data(utf8))
            .map { String(format: "%02x", $0) }.joined()
    }
}
