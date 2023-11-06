//
//  Extensions.swift
//  Find3
//
//  Created by Bhavya Bhatia
//

import Foundation

extension Array {
    mutating func shuffle() {
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            self.swapAt(i, j)
        }
    }
}
