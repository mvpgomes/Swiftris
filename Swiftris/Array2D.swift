//
//  Array2D.swift
//  Swiftris
//
//  Created by Marcus Gomes on 12/18/14.
//  Copyright (c) 2014 Bloc. All rights reserved.
//

import Foundation

/**
    Class that represents the game board. For this
    game was necessary create a class that represents an
    array, in Swift a generic array is of type struct, because
    the structure needs be passed by reference, a struct is passed
    by value.

    :type: generic.
*/
class Array2D<T> {
    
    // Varibles to define the array size.
    let columns: Int
    let rows: Int
    
    /**
        Variable that represents the game board.
    
        :type: optional.
    */
    var array: Array<T?>
    
    // Constructor
    init(columns: Int, rows: Int){
        self.columns = columns
        self.rows = rows
        
        array = Array<T?>(count: rows * columns, repeatedValue: nil)
    }
    
    // Getters and setters
    subscript(column: Int, row: Int) -> T? {
        get {
            return array[(row * columns) + column]
        }
        set(newValue) {
            array[(row * columns) + column] = newValue
        }
    }
}