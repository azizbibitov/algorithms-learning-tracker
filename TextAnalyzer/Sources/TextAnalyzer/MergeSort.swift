//
//  MergeSort.swift
//  TextAnalyzer
//
//  Created by Aziz Bibitov on 28.10.2026.
//

func merge(
    _ left: [(key: String, value: Int)],
    _ right: [(key: String, value: Int)]
) -> [(key: String, value: Int)] {
    
    var result: [(key: String, value: Int)] = []
    
    var indexL = 0
    var indexR = 0
    
    while indexL < left.count && indexR < right.count {
        
        if left[indexL].value == right[indexR].value {
            if left[indexL].key < right[indexR].key {
                result.append(left[indexL])
                indexL += 1
            }else{
                result.append(right[indexR])
                indexR += 1
            }
        }else{
            if left[indexL].value > right[indexR].value {
                result.append(left[indexL])
                indexL += 1
            }else{
                result.append(right[indexR])
                indexR += 1
            }
        }
    }
    
    if indexL < left.count {
        for k in indexL..<left.count {
            result.append(left[k])
        }
    }
    
    if indexR < right.count {
        for k in indexR..<right.count {
            result.append(right[k])
        }
    }
    
    return result
}

func mergeSort(array: [(key: String, value: Int)]) -> [(key: String, value: Int)] {
    
    if array.count < 2 {
        return array
    }
    
    let middle = array.count / 2
    
    let left = Array(array.prefix(middle))
    let right = Array(array.dropFirst(middle))
    
    let sortedLeft = mergeSort(array: left)
    let sortedRight = mergeSort(array: right)
    
    return merge(sortedLeft, sortedRight)
}
