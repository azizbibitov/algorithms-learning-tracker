//
//  WordRanking.swift
//  TextAnalyzer
//
//  Created by Aziz Bibitov on 29.10.2026.
//

func isBetter(first: (key: String, value: Int), second: (key: String, value: Int)) -> Bool {
    return first.value > second.value || first.value == second.value && first.key < second.key
}
