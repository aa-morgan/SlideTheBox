//
//  BasicLevel.swift
//  Slide the Box
//
//  Created by Alex Morgan on 06/12/2016.
//  Copyright © 2016 Alex Morgan. All rights reserved.
//

import SpriteKit

class BasicLevel {
    
    var blocksReal = Array<Array<Int>>()
    var blocksExploration = Array<Array<Int>>()
    
    private var numBlocksX = Int()
    private var numBlocksY = Int()
    
    private var startPosition = Array<Int>()
    private var endPosition = Array<Int>()
    
    private var solved = Bool()
    private var solvable = Bool()
    private var stuckable = Bool()
    
    init() {
    }
    
    init(numBlocksX: Int, numBlocksY: Int) {
        self.numBlocksX = numBlocksX
        self.numBlocksY = numBlocksY
        solved = false
        
        blocksReal = Array(repeating: Array(repeating: 0, count: numBlocksX), count: numBlocksY)
        blocksExploration = Array(repeating: Array(repeating: 0, count: numBlocksX), count: numBlocksY)
    }
    
    func calculateMove(position: Array<Int>, direction: String)
        -> (newPosition: Array<Int>, numMoves: Int, endBlock: Bool) {
        
        var finished = false
        var col = position[0]
        var row = position[1]
        var newPosition = position
        var numMoves = 0
        var endBlock = false
        
        while(!finished) {
            if (direction == "up") {
                row -= 1
            } else if direction == "down" {
                row += 1
            } else if direction == "left" {
                col -= 1
            } else if direction == "right" {
                col += 1
            }
            
            if (row >= 0 && row < numBlocksY) && (col >= 0 && col < numBlocksX) {
                if blocksReal[row][col] == 0 || blocksReal[row][col] == 8 { // Empty or start Block
                    numMoves += 1
                } else if blocksReal[row][col] == 9 { // End Block
                    numMoves += 1
                    finished = true
                    endBlock = true
                } else {
                    finished = true
                }
            } else {
                finished = true
            }
            
        }
        
        if (direction == "up") {
            newPosition[1] -= numMoves
        } else if direction == "down" {
            newPosition[1] += numMoves
        } else if direction == "left" {
            newPosition[0] -= numMoves
        } else if direction == "right" {
            newPosition[0] += numMoves
        }
        
            return (newPosition: newPosition, numMoves: numMoves, endBlock: endBlock)
    }
    
    func isSolved() -> Bool {
        return solved
    }
    
    func setSolved(isSolved: Bool) {
        self.solved = isSolved
    }
    
    func isSolvable() -> Bool {
        return solvable
    }
    
    func setSolvable(isSolvable: Bool) {
        self.solvable = isSolvable
    }
    
    func isStuckable() -> Bool {
        return stuckable
    }
    
    func setStuckable(isStuckable: Bool) {
        self.stuckable = isStuckable
    }
    
    func getBlocksReal() -> Array<Array<Int>> {
        return self.blocksReal
    }
    
    func setBlocksReal(blocks: Array<Array<Int>>) {
        self.blocksReal = blocks
    }
    
    func getBlocksExploration() -> Array<Array<Int>> {
        return self.blocksExploration
    }
    
    func getBlocksExplorationValue(position: Array<Int>) -> Int {
        return self.blocksExploration[position[1]][position[0]]
    }
    
    func setBlocksExploration(blocks: Array<Array<Int>>) {
        self.blocksExploration = blocks
    }
    
    func setBlocksExplorationValue(position: Array<Int>, value: Int) {
        self.blocksExploration[position[1]][position[0]] = value
    }
    
    func resetBlocksExploration() {
        self.blocksExploration = Array(repeating: Array(repeating: 0, count: numBlocksX), count: numBlocksY)
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
        if self.solved {
            return getBlocksExplorationValue(position: getEndPosition()) - 1
        } else {
            return -1
        }
    }
    
}
