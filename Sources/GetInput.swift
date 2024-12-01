import Foundation

func getInput(
    fileName: String,
    inDirectory subpath: String,
    ext: String = "txt"
) -> String {
    let inputPath = Bundle.main
        .paths(forResourcesOfType: ext, inDirectory: subpath)
        .first { $0.contains("\(fileName).\(ext)") }!
    return try! String(contentsOfFile: inputPath)
}
