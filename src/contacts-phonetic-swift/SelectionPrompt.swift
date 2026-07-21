import Foundation

enum SelectionPrompt {
    static func read(count: Int) -> Int {
        while true {
            print("Select: ", terminator: "")
            fflush(stdout)
            if let input = readLine(), let selection = Int(input), (1...count).contains(selection) {
                return selection - 1
            }
        }
    }
}
