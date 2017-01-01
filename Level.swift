//
//  Level.swift
//  Slide the Box
//
//  Created by Alex Morgan on 31/12/2016.
//  Copyright © 2016 Alex Morgan. All rights reserved.
//

import SpriteKit

class Level {

    var numBlocksX = Int()
    var numBlocksY = Int()
    
    var numBlockBlocks = Int()
    var numNumberBlocks = Int()
    var numArrowBlocks = Int()
    
    var startPosition = Array<Int>()
    var endPosition = Array<Int>()
    
    var blocksReal = Array<Array<Int>>()
    var levelSolution = LevelSolution()
    
    init() {
    }
    
    init(numBlocksX: Int, numBlocksY: Int) {
        self.numBlocksX = numBlocksX
        self.numBlocksY = numBlocksY
        
        blocksReal = Array(repeating: Array(repeating: 0, count: numBlocksX), count: numBlocksY)
        levelSolution = LevelSolution(numBlocksX: numBlocksX, numBlocksY: numBlocksY)
    }
    
    func calculateMove(position: Array<Int>, direction: String, blockType: String)
        -> (positions: Array<Array<Int>>, numMoves: Array<Int>, endBlock: Bool, infiniteArrowLoop: Bool) {
            
            var finished = false
            var col = position[0]
            var row = position[1]
            var numMoves = 0
            var endBlock = false
            var positions = Array<Array<Int>>()
            var newPosition = position
            positions.append(newPosition)
            var numMovesArray = Array<Int>()
            
            var hitNumber = false
            var numberRemaining = 0
            
            var currentDirection = direction
            var updateDirection = String()
            var hitArrow = false
            var hitArrowNum = 0
            var infiniteArrowLoop = false
            
            if (blocksReal[row][col] >= 11 && blocksReal[row][col] <= 18) { // Number block. No Number 0 block
                hitNumber = true
                numberRemaining = blocksReal[row][col] - 10
            }
            
            repeat {
                numMoves = 0
                hitArrow = false
                finished = false
                while(!finished) {
                    
                    if hitNumber == true {
                        if numberRemaining > 0 {
                            numberRemaining -= 1
                        } else {
                            finished = true
                            break
                        }
                    }
                    
                    (col, row) = incrementPosition(col: col, row: row, direction: currentDirection, amount: 1)
                    
                    if (row >= 0 && row < numBlocksY) && (col >= 0 && col < numBlocksX) {
                        if blocksReal[row][col] == 0 || blocksReal[row][col] == 8 { // Empty or start Block
                            numMoves += 1
                        } else if blocksReal[row][col] == 9 && blockType == "player" { // End Block
                            numMoves += 1
                            finished = true
                            endBlock = true
                        } else if blocksReal[row][col] == 9 && blockType == "enemy" { // treat as blank
                            numMoves += 1
                        } else if (blocksReal[row][col] >= 10 && blocksReal[row][col] <= 18) { // Number block
                            hitNumber = true
                            numberRemaining = blocksReal[row][col] - 10
                            numMoves += 1
                        } else if (blocksReal[row][col] >= 20 && blocksReal[row][col] <= 23) { // Arrow block
                            hitArrow = true
                            hitArrowNum += 1
                            updateDirection = getArrowDirection(blockType: blocksReal[row][col])
                            numMoves += 1
                            finished = true
                        } else if blocksReal[row][col] == 1 { // End block
                            finished = true
                        } else {
                            finished = true
                        }
                    } else {
                        finished = true
                    }
                    
                }
                
                newPosition = incrementPosition(position: newPosition, direction: currentDirection, amount: numMoves)
                positions.append(newPosition)
                numMovesArray.append(numMoves)
                
                if hitArrow {
                    currentDirection = updateDirection
                }
                
                if hitArrowNum > 10 {
                    infiniteArrowLoop = true
                    break
                }
                
            } while(hitArrow)
            
            return (positions: positions, numMoves: numMovesArray, endBlock: endBlock, infiniteArrowLoop: infiniteArrowLoop)
    }
    
    func twoDimMax(array: Array<Array<Int>>) -> (value: Int, index: Array<Int>) {
        
        var globalMax = 0
        var globalIndex = Array<Int>()
        
        var row = 0
        for curRow in array {
            let tempMax = curRow.max()
            if (tempMax! > globalMax) {
                globalMax = tempMax!
                globalIndex = [curRow.index(of: tempMax!)!,row]
            }
            row += 1
        }
        
        return (globalMax, globalIndex)
    }
    
    func positionInBounds(position: Array<Int>) -> Bool {
        if (position[0] >= 0 && position[0] < blocksReal[0].count &&
            position[1] >= 0 && position[1] < blocksReal.count) {
            return true
        } else {
            return false
        }
    }
    
    func isPositionOnBoundary(position: Array<Int>) -> Bool {
        if  (position[0] == 0 || position[0] == (numBlocksX-1)) ||
            (position[1] == 0 || position[1] == (numBlocksY-1)) {
            return true
        } else {
            return false
        }
    }
    
    func incrementPosition(col: Int, row: Int, direction: String, amount: Int) -> (col: Int, row: Int) {
        let startPosition = [col, row]
        let newPosition = incrementPosition(position: startPosition, direction: direction, amount: amount)
        return (col: newPosition[0], row: newPosition[1])
    }
    
    func incrementPosition(position: Array<Int>, direction: String, amount: Int) -> Array<Int> {
        var newPosition = position
        if direction == "up" {
            newPosition[1] -= amount
        } else if direction == "down" {
            newPosition[1] += amount
        } else if direction == "left" {
            newPosition[0] -= amount
        } else if direction == "right" {
            newPosition[0] += amount
        }
        
        return newPosition
    }
    
    func getSolution() -> LevelSolution {
        return self.levelSolution
    }
    
    func getBlocksReal() -> Array<Array<Int>> {
        return self.blocksReal
    }
    
    func getBlocksRealValue(position: Array<Int>) -> Int {
        return self.blocksReal[position[1]][position[0]]
    }
    
    func setBlocksReal(blocks: Array<Array<Int>>) {
        self.blocksReal = blocks
    }
    
    func getStartPosition() -> Array<Int> {
        return self.startPosition
    }
    
    func setStartPosition(position: Array<Int>) {
        self.startPosition = position
    }
    
    func getEndPosition() -> Array<Int> {
        return self.endPosition
    }
    
    func setEndPosition(position: Array<Int>) {
        self.endPosition = position
    }
    
    func getBlockSpaceRatio() -> Float {
        return Float(0)
    }
    
    func getMinMoves() -> Int {
        if self.levelSolution.isSolved() {
            return self.levelSolution.getBlocksExplorationValue(position: getEndPosition()) - 1
        } else {
            return -1
        }
    }
    
    func getNumBlockBlocks() -> Int {
        return self.numBlockBlocks
    }
    
    func setNumBlockBlocks(number: Int) {
        self.numBlockBlocks = number
    }
    
    func getNumBlocks() -> Int {
        return self.numBlocksX * self.numBlocksY
    }
    
    func getNumNumberBlocks() -> Int {
        return self.numNumberBlocks
    }
    
    func setNumNumberBlocks(number: Int) {
        self.numNumberBlocks = number
    }
    
    func getNumArrowBlocks() -> Int {
        return self.numArrowBlocks
    }
    
    func setNumArrowBlocks(number: Int) {
        self.numArrowBlocks = number
    }
    
    func getArrowDirection(blockType: Int) -> String {
        
        var arrowDirection = ""
        
        if blockType == 20 {
            arrowDirection = "up"
        } else if blockType == 21 {
            arrowDirection = "down"
        } else if blockType == 22 {
            arrowDirection = "left"
        } else if blockType == 23 {
            arrowDirection = "right"
        }
        
        return arrowDirection
    }
    
}

