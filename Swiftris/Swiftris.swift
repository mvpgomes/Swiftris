//
//  Swiftris.swift
//  Swiftris
//
//  Created by Marcus Gomes on 12/20/14.
//  Copyright (c) 2014 Bloc. All rights reserved.
//

import Foundation

// constants that specify the board dimension
let NumColumns = 10
let NumRows = 20

// constants that specify the initial column/row for a shape
let StartingColumn = 4
let StartingRow = 0

let PreviewColumn = 12
let PreviewRow = 1

class Swiftris {
    
    var blockArray: Array2D<Block>
    var nextShape: Shape?
    var fallingShape: Shape?
    
    // Constructor
    init() {
        fallingShape = nil
        nextShape = nil
        blockArray = Array2D<Block>(columns: NumColumns, rows: NumRows)
    }
    
    /**
        - beginGame : initializes the game.
    */
    func beginGame() {
        if (nextShape == nil) {
            nextShape = Shape.random(PreviewColumn, startingRow: PreviewRow)
        }
    }
    
    /**
        - newShape : generates a new shape to falling in the board.
    
        :retuns: (Shape, Shape) Return a tuple that optionally contains the falling
        shape and the next Shape to fallen.
    */
    func newShape() -> (fallingShape: Shape?, nextShape: Shape?) {
        fallingShape = nextShape
        nextShape = Shape.random(PreviewColumn, startingRow: PreviewRow)
        fallingShape?.moveTo(StartingColumn, row: StartingRow)
        return (fallingShape, nextShape)
    }
}