import Foundation

@main
struct TextAnalyzer {
    static func main() {
       
        
        guard CommandLine.arguments.count > 1 else {
            print("Usage: swift run TextAnalyzer <file-path> [limit]")
            return
        }
        
      
        var limit = 3
        if CommandLine.arguments.count > 2{
            guard let limitArg = Int(CommandLine.arguments[2]), limitArg > 0 else {
                print("The limit must be a positive integer")
                return
            }
            
            limit = limitArg
        }
        
        
        var text = ""
        let path = CommandLine.arguments[1]
       
        
        do {
            text = try String(
                contentsOfFile: path,
                encoding: .utf8
            )
        } catch(let error) {
            print("reading .txt gave this error: '\(error.localizedDescription)'")
            return
        }
        
        let ignoredWords: Set<String> = ["the", "and", "is"]
        let counts = wordFrequencies(in: text, ignoring: ignoredWords)
        
        let rankedWords = topWords(from: counts, limit: limit)
      
        for entry in rankedWords {
            print("\(entry.key): \(entry.value)")
        }
    }
    
  
    
}

