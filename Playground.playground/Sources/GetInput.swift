import Foundation

public func getInput(
    fileName: String,
    ext: String = "txt"
) -> String {
    let inputPath = Bundle.main
        .paths(forResourcesOfType: ext, inDirectory: nil)
        .first { $0.contains("\(fileName).\(ext)") }!
    return try! String(contentsOfFile: inputPath)
}
