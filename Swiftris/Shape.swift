//
//  Shape.swift
//  Swiftris
//
//  Created by Marcus Gomes on 12/18/14.
//  Copyright (c) 2014 Bloc. All rights reserved.
//

import Foundation
import SpriteKit

// Number of possible orientations
let NumOrientations: UInt32 = 4

// Orientation enumerable helper
enum Orientation: Int, Printable {
    
    case Zero = 0, Ninety, OneEighty, TwoSeventy
    
    var description: String {
        switch self {
        case .Zero:
            return "0"
        case .Ninety:
            return "90"
        case .OneEighty:
            return "180"
        case .TwoSeventy:
            return "270"
        }
    }
    
    static func random() -> Orientation {
        return Orientation(rawValue: Int(arc4random_uniform(NumOrientations)))!
    }
    
    static func rotate(orientation: Orientation, clockwise: Bool) -> Orientation {
        var rotated = orientation.rawValue + (clockwise ? 1 : -1)
        if rotated > Orientation.TwoSeventy.rawValue {
            rotated = Orientation.Zero.rawValue
        } else if rotated < 0 {
            rotated = Orientation.TwoSeventy.rawValue
        }
        return Orientation(rawValue: rotated)!
    }
}

// The number of total shapes varieties
let NumShapeTypes: UInt32 = 7

// Shape indexes
let FirstBlockIdx: Int = 0
let SecondBlockIdx: Int = 1
let ThirdBlockIdx: Int = 2
let FourthBlockIdx: Int = 3

class Shape: Hashable, Printable {
    
    // The color of the shape
    let color: BlockColor
    
    // The blocks comprising the shape
    var blocks = Array<Block>()
    // The current orientation of the shape
    var orientation: Orientation
    // The column and row representing the shape's anchor point 
    var column, row: Int
    
    // Requirred Overrides
    
    // Subclasses must override this property
    var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>] {
        return [:]
    }
    
    // Subclasses must override this property
    var bottomBlocksForOrientations: [Orientation : Array<Block>] {
        return [:]
    }
    
    var bottomBlocks: Array<Block> {
        if let bottomBlocks = bottomBlocksForOrientations[orientation] {
            return bottomBlocks
        }
        return []
    }
    
    // Hashable
    var hashValue: Int {
        return reduce(blocks, 0) { $0.hashValue ^ $1.hashValue}
    }
    
    // Printable
    var description: String {
        return "\(color) block facing \(orientation): \(blocks[FirstBlockIdx]), \(blocks[SecondBlockIdx]), \(blocks[ThirdBlockIdx]), \(blocks[FourthBlockIdx])"
    }
    
    /** 
        - Constructor: initialize a new shape with the provided column, row, color and orientation.
    
        :param: column Tne indicator column for the shape.
        :param: row    The indicator row for the shape.
        :param: color  The color of the the shape.
        :param: orientation The orientation for the shape.
    */
    init(column: Int, row: Int, color: BlockColor, orientation: Orientation){
        self.column = column
        self.row = row
        self.color = color
        self.orientation = orientation
        initializeBlocks()
    }
    
    /**
        - Conveninence constructor: initialize a new shape with the provided column and row.
    
        :param: column Tne indicator column for the shape.
        :param: row    The indicator row for the shape.
    */
    convenience init(column: Int, row: Int) {
        self.init(column: column, row: row, color: BlockColor.random(), orientation: Orientation.random())
    }
    
    /**
        - initializeBlocks : create a new block for a shape and append it to the existent blocks.
    */
    final func initializeBlocks() {
        if let blockRowColumnTranslations = blockRowColumnPositions[orientation] {
            for i in 0..<blockRowColumnTranslations.count {
                let blockRow = row + blockRowColumnTranslations[i].rowDiff
                let blockColumn = column + blockRowColumnTranslations[i].columnDiff
                let newBlock = Block(column: blockColumn, row: blockRow, color: color)
                blocks.append(newBlock)
            }
        }
    }
    /**
        - rotateBlock: rotate all blocks of the shape according the provided orientation.
    
        :param: orientation The orientation to be applied to the shape.
    */
    final func rotateBlocks(orientation: Orientation) {
        if let blockRowColumnTranslation : Array<(columnDiff : Int, rowDiff : Int)> = blockRowColumnPositions[orientation] {
            for (idx, (columnDiff : Int, rowDiff : Int)) in enumerate(blockRowColumnTranslation) {
                blocks[idx].column = column + columnDiff
                blocks[idx].row = row + rowDiff
            }
        }
    }
    
    /**
        - lowerShapeByOneRow : lower the shape by one row.
    */
    final func lowerShapeByOneRow() {
        shiftBy(0, rows:1)
    }
    
    /**
        - shifBy : update the column and row values for a shape.
    
        :param: column The number of columns to be added to a shape.
        :param: row The number of row to be added to a shape.
    */
    final func shiftBy(columns: Int, rows: Int) {
        self.column += columns
        self.row += rows
        for block in blocks {
            block.column += columns
            block.row += rows
        }
    }
    
    /**
        - moveTo : move the shape to a position specified by column and row.
    
        :param: column The column to move the shape.
        :param: row The row to move the shape.
    */
    final func moveTo(column: Int, row: Int) {
        self.column = column
        self.row = row
        rotateBlocks(orientation)
    }
    
    /**
        - random : generates a random shape in a given column and row.
    
        :param: startingColumn The starting column of the shape.
        :param: startingRow The starting row of the shape.
    
        :returns: Shape
    */
    final class func random(startingColumn: Int, startingRow: Int) -> Shape {
        switch Int(arc4random_uniform(NumShapeTypes)) {
        case 0:
            return SquareShape(column: startingColumn, row: startingRow)
        case 1:
            return LineShape(column: startingColumn, row: startingRow)
        case 2:
            return TShape(column: startingColumn, row: startingRow)
        case 3:
            return LShape(column: startingColumn, row: startingRow)
        case 4:
            return JShape(column: startingColumn, row: startingRow)
        case 5:
            return SShape(column: startingColumn, row: startingRow)
        default:
            return ZShape(column: startingColumn, row: startingRow)
        }
    }
}

/**
    - == : custom method to compare two shapes
    
    :param: lhs A random shape
    :param: rhs A random shape

    :returns: Bool 
*/
func ==(lhs: Shape, rhs: Shape) -> Bool {
    return lhs.row == rhs.row && lhs.column == rhs.column
}

