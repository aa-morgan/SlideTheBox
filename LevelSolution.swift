//
//  LevelSolution.swift
//  Slide the Box
//
//  Created by Alex Morgan on 01/01/2017.
//  Copyright © 2017 Alex Morgan. All rights reserved.
//

import SpriteKit

class LevelSolution {
    
    var numBlocksX = Int()
    var numBlocksY = Int()
    
    var blocksExploration = Array<Array<Int>>()
    var calculatedRoute = Array<Array<Array<Array<Int>>>>()
    
    var solved = Bool()
    var solvable = Bool()
    var stuckable = Bool()
    
    var numNumbersUsed = Int()
    var numArrowsUsed = Int()
    var infiniteArrowLoop = Bool()
    
    init() {
    }
    
    init(numBlocksX: Int, numBlocksY: Int) {
        self.numBlocksX = numBlocksX
        self.numBlocksY = numBlocksY
        
        solved = false
        solvable = false
        stuckable = true
        numNumbersUsed = 0
        numArrowsUsed = 0
        infiniteArrowLoop = false
        
        blocksExploration = Array(repeating: Array(repeating: 0, count: numBlocksX), count: numBlocksY)
        calculatedRoute = Array(repeating: Array(repeating: Array<Array<Int>>(), count: numBlocksX), count: numBlocksY)
    }
    
    func getExplorablePosition(greaterThan: Int, level: Level, seed: Int) -> Array<Int> {
        
        var row = 0
        var col = 0
        var numFound = 0
        for curRow in getBlocksExploration() {
            for expStage in curRow {
                if (expStage > greaterThan) && (level.getBlocksRealValue(position: [col, row]) == 0) {
                    numFound += 1
                    if numFound == seed {
                        return [col, row]
                    }
                }
                col += 1
            }
            col = 0
            row += 1
        }
        
        print("Error (in LevelSolution.getExplorablePosition): Couldn't find suitable position!")
        return [0, 0]
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
    
    func getNumNumbersUsed() -> Int {
        return self.numNumbersUsed
    }
    
    func setNumNumbersUsed(value: Int) {
        self.numNumbersUsed = value
    }
    
    func getNumArrowsUsed() -> Int {
        return self.numArrowsUsed
    }
    
    func setNumArrowsUsed(value: Int) {
        self.numArrowsUsed = value
    }
    
    func isInfiniteArrowLoop() -> Bool {
        return self.infiniteArrowLoop
    }
    
    func setInfiniteArrowLoop(value: Bool) {
        self.infiniteArrowLoop = value
    }
    
}
