func topWords(
    from counts: [String: Int],
    limit: Int
) -> [(key: String, value: Int)] {
    if limit <= 0 { return [] }

//    let rankedWords = counts.sorted {
//        if $0.value == $1.value {
//            return $0.key < $1.key
//        }
//
//        return $0.value > $1.value
//    }
    
    let rankedWords = mergeSort(array: Array(counts))

    return Array(rankedWords.prefix(limit))
}
