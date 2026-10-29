//
//  TopWordsKeepingBest.swift
//  TextAnalyzer
//
//  Created by Aziz Bibitov on 29.10.2026.
//


func topWordsKeepingBest(
    from counts: [String: Int],
    limit: Int
) -> [(key: String, value: Int)] {
    if limit <= 0 { return [] }
    
    var candidates: [(key: String, value: Int)] = []
    
    
    
    for count in counts {
        if candidates.count < limit {
            candidates.append(count)
        }else{
            
            var worstIndex = 0
            
            for k in 1..<candidates.count {
                if isBetter(first: candidates[worstIndex], second: candidates[k]) {
                    worstIndex = k
                }
            }
            
            if isBetter(first: count, second: candidates[worstIndex]) {
                candidates[worstIndex] = count
            }
            
        }
    }
    
    return mergeSort(array: candidates)
}
