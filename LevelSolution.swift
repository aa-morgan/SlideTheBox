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
    
    func randomEnemyPosition(notIn: Array<Array<Int>>, level: Level) -> Array<Int> {
        
        var potentialPositions: Array<Array<Int>>
        var (minExpStage, _) = level.twoDimMax(array: getBlocksExploration())
        
        repeat {
            potentialPositions = getPotentialEnemyPositions(array: level.getSolution().getBlocksExploration(), greaterThan: minExpStage, level: level)
            
            potentialPositions = removeFromArray(array: potentialPositions, remove: notIn)
            
            minExpStage -= 1
        } while (potentialPositions.count == 0)
        
        let randomPositionIndex = Int(arc4random_uniform(UInt32(potentialPositions.count)))
        
        return potentialPositions[randomPositionIndex]
    }
    
    func getPotentialEnemyPositions(array: Array<Array<Int>>, greaterThan: Int, level: Level) -> Array<Array<Int>> {
        var potentialPositions = Array<Array<Int>>()
        var row = 0
        var col = 0
        for curRow in getBlocksExploration() {
            for expStage in curRow {
                if (expStage > greaterThan) && (level.getBlocksRealValue(position: [col, row]) == 0) {
                    potentialPositions.append([col, row])
                }
                col += 1
            }
            col = 0
            row += 1
        }
        
        return potentialPositions
    }
    
    func removeFromArray(array: Array<Array<Int>>, remove: Array<Array<Int>>) -> Array<Array<Int>> {
        var potentialPositions = Array<Array<Int>>()
        var found: Bool
        
        for position in array {
            found = false
            for toRemove in remove {
                if position == toRemove {
                    found = true
                    break
                }
            }
            if !found {
                potentialPositions.append(position)
            }
        }
        
        return potentialPositions
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
