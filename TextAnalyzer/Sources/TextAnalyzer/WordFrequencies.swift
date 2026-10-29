/// Counts words in text.
///
/// - Words are separated by any non-letter character.
/// - Counting is case-insensitive.
/// - Input containing no letters returns an empty dictionary.
func wordFrequencies(
    in text: String,
    ignoring ignoredWords: Set<String>
) -> [String: Int] {
    
    let words = text.split(whereSeparator: {!$0.isLetter}).map(String.init)
    
    var wordCountsDic: [String: Int] = [:]
    
    for word in words {
        let lowerCaseWord = word.lowercased()
        if ignoredWords.contains(lowerCaseWord) { continue }
        if let count = wordCountsDic[lowerCaseWord] {
            wordCountsDic[lowerCaseWord] = count+1
        }else{
            wordCountsDic[lowerCaseWord] = 1
        }
    }
    return wordCountsDic
}
