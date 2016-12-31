//
//  BasicLevel.swift
//  Slide the Box
//
//  Created by Alex Morgan on 06/12/2016.
//  Copyright © 2016 Alex Morgan. All rights reserved.
//

import SpriteKit

class BasicLevel: BaseLevel {
    
    var blocksReal = Array<Array<Int>>()
    var blocksExploration = Array<Array<Int>>()
    var calculatedRoute = Array<Array<Array<Array<Int>>>>()
    var numBlockBlocks = Int()
    
    var numBlocksX = Int()
    var numBlocksY = Int()
    
    var startPosition = Array<Int>()
    var endPosition = Array<Int>()
    
    var solved = Bool()
    var solvable = Bool()
    var stuckable = Bool()
    
    init() {
    }
    
    init(numBlocksX: Int, numBlocksY: Int) {
        self.numBlocksX = numBlocksX
        self.numBlocksY = numBlocksY
        solved = false
        
        blocksReal = Array(repeating: Array(repeating: 0, count: numBlocksX), count: numBlocksY)
        blocksExploration = Array(repeating: Array(repeating: 0, count: numBlocksX), count: numBlocksY)
        calculatedRoute = Array(repeating: Array(repeating: Array<Array<Int>>(), count: numBlocksX), count: numBlocksY)
    }
    
    func calculateMove(position: Array<Int>, direction: String)
    -> (positions: Array<Array<Int>>, numMoves: Array<Int>, endBlock: Bool) {
        
        var finished = false
        var col = position[0]
        var row = position[1]
        var numMoves = 0
        var endBlock = false
        var positions = Array<Array<Int>>()
        var newPosition = position
        positions.append(newPosition)
        
        while(!finished) {
            (col, row) = incrementPosition(col: col, row: row, direction: direction, amount: 1)
            
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
        
        newPosition = incrementPosition(position: newPosition, direction: direction, amount: numMoves)
        positions.append(newPosition)
        
        return (positions: positions, numMoves: [numMoves], endBlock: endBlock)
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
    
    func getBlocksRealValue(position: Array<Int>) -> Int {
        return self.blocksReal[position[1]][position[0]]
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
    
    func getCalculatedRoute() -> Array<Array<Array<Array<Int>>>> {
        return self.calculatedRoute
    }
    
    func setCalculatedRoute(calculatedRoute: Array<Array<Array<Array<Int>>>>) {
        self.calculatedRoute = calculatedRoute
    }
    
    func setCalculatedRouteValue(position: Array<Int>, value: Array<Array<Int>>) {
        self.calculatedRoute[position[1]][position[0]] = value
    }
    
    func resetCalculatedRoute() {
        self.calculatedRoute = Array(repeating: Array(repeating: Array<Array<Int>>(), count: numBlocksX), count: numBlocksY)
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
    
    func getNumBlockBlocks() -> Int {
        return self.numBlockBlocks
    }
    
    func setNumBlockBlocks(number: Int) {
        self.numBlockBlocks = number
    }
    
    func getNumBlocks() -> Int {
        return self.numBlocksX * self.numBlocksY
    }
    
}
