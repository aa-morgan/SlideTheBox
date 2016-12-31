//
//  NumberLevel.swift
//  Slide the Box
//
//  Created by Alex Morgan on 23/12/2016.
//  Copyright © 2016 Alex Morgan. All rights reserved.
//

import SpriteKit

class NumberLevel: BasicLevel {
    
    var numNumberBlocks = Int()
    
    override func calculateMove(position: Array<Int>, direction: String)
        -> (positions: Array<Array<Int>>, numMoves: Array<Int>, endBlock: Bool) {
            
            var finished = false
            var col = position[0]
            var row = position[1]
            var numMoves = 0
            var endBlock = false
            var positions = Array<Array<Int>>()
            var newPosition = position
            positions.append(newPosition)
            
            var hitNumber = false
            var numberRemaining = 0
            
            if (blocksReal[row][col] >= 11 && blocksReal[row][col] <= 18) { // Number block. No Number 0 block
                hitNumber = true
                numberRemaining = blocksReal[row][col] - 10
            }
            
            while(!finished) {
                
                if hitNumber == true {
                    if numberRemaining > 0 {
                        numberRemaining -= 1
                    } else {
                        finished = true
                        break
                    }
                }
                
                (col, row) = incrementPosition(col: col, row: row, direction: direction, amount: 1)
                
                if (row >= 0 && row < numBlocksY) && (col >= 0 && col < numBlocksX) {
                    if blocksReal[row][col] == 0 || blocksReal[row][col] == 8 { // Empty or start Block
                        numMoves += 1
                    } else if blocksReal[row][col] == 9 { // End Block
                        numMoves += 1
                        finished = true
                        endBlock = true
                    } else if (blocksReal[row][col] >= 10 && blocksReal[row][col] <= 18) { // Number block
                        hitNumber = true
                        numberRemaining = blocksReal[row][col] - 10
                        numMoves += 1
                    } else {
                        finished = true
                    }
                } else {
                    finished = true
                }
                
            }
            
            newPosition = incrementPosition(position: newPosition, direction: direction, amount: numMoves)
            positions.append(newPosition)
            
            return (positions: positions, numMoves: [numMoves], endBlock: endBlock)
    }
    
    
    func getNumNumberBlocks() -> Int {
        return self.numNumberBlocks
    }
    
    func setNumNumberBlocks(number: Int) {
        self.numNumberBlocks = number
    }
}

