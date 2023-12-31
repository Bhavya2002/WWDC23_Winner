//
//  Array2D.swift
//  Find3
//
//  Created by Bhavya Bhatia
//

import Foundation

// Source: http://www.raywenderlich.com/75270/make-game-like-candy-crush-with-swift-tutorial-part-1



struct Array2D<T> {
    let columns: Int
    let rows: Int
    fileprivate var array: Array<T?>
    
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        array = Array<T?>(repeating: nil, count: rows*columns)
    }
    
    subscript(column: Int, row: Int) -> T? {
        get {
            return array[row*columns + column]
        }
        set {
            array[row*columns + column] = newValue
        }
    }
}
