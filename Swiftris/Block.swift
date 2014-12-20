//
//  Block.swift
//  Swiftris
//
//  Created by Marcus Gomes on 12/18/14.
//  Copyright (c) 2014 Bloc. All rights reserved.
//

import Foundation
import SpriteKit

let NumberOfColors: UInt32 = 6

enum BlockColor: Int, Printable {
    
    // supported colors
    case Blue = 0, Orange, Purple, Red, Teal, Yellow
    
    // returns the correct filename for the given color
    var spriteName: String {
        switch self {
        case .Blue:
            return "blue"
        case .Orange:
            return "orange"
        case .Purple:
            return "purple"
        case .Red:
            return "red"
        case .Teal:
            return "teal"
        case .Yellow:
            return "yellow"
        }
    }
    
    var description: String {
        return self.spriteName
    }
    
    static func random() -> BlockColor {
        return BlockColor(rawValue: Int(arc4random_uniform(NumberOfColors)))!
    }
}

/**
    Block class.

    :type: Hashable. Allows to be stored into Array2D.
    :column: block column.
    :row: block row.
    :color: block color.
*/
class Block: Hashable, Printable {
    
    // variables
    let color: BlockColor
    
    var column: Int
    var row: Int
    var sprite: SKSpriteNode?
    
    // return the file mane of the sprite
    var spriteName: String {
        return color.spriteName
    }
    
    // hashValue calculated property. Is required to support Hashable protocol.
    var hashValue: Int {
        return self.column ^ self.row
    }
    
    // description caculated propoerty. Is required to support Printable protocol.
    var description: String {
        return "\(color): [\(column), \(row)]"
    }
    
    init(column: Int, row: Int, color: BlockColor) {
        self.column = column
        self.row = row
        self.color = color
    }
}

// Custom operator to compare two blocks. This opeartor is requires to support the Hashable protocol. 
func ==(lhs: Block, rhs: Block) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row && lhs.color.rawValue == rhs.color.rawValue
}