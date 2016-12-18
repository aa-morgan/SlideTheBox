//
//  BasicLevelSolver.swift
//  Slide the Box
//
//  Created by Alex Morgan on 09/12/2016.
//  Copyright © 2016 Alex Morgan. All rights reserved.
//

import Foundation

class BasicLevelSolver {
    
    init() {
    }
    
    func solve(level: BasicLevel) {
        runExplorationAlgorithm(level: level, startPosition: level.getStartPosition())
        setLevelProperties(level: level)
    }
    
    func solveForNextMove(level: BasicLevel, customStart: Array<Int>) -> String {
        var nextMove = String()
        let customBlocksExploration = customSolve(level: level, customStart: customStart)
        
        // Dummy
        nextMove = "up"
        
        return nextMove
    }
    
    func customSolve(level: BasicLevel, customStart: Array<Int>) -> Array<Array<Int>> {
        let copyOfBlocksExploration = level.getBlocksExploration()
        runExplorationAlgorithm(level: level, startPosition: customStart)
        let customBlocksExploration = level.getBlocksExploration()
        level.setBlocksExploration(blocks: copyOfBlocksExploration)
        return customBlocksExploration
    }
    
    private func runExplorationAlgorithm(level: BasicLevel, startPosition: Array<Int>) {
    
        var currentExplorationStage = 1
        var numSpans = Int()
        
        level.resetBlocksExploration()
        level.setBlocksExplorationValue(position: startPosition, value: currentExplorationStage)
        
        repeat {
            numSpans = searchAndSpan(level: level, currentExplorationStage: currentExplorationStage)
            currentExplorationStage += 1
        } while(numSpans > 0)
    }
    
    private func setLevelProperties(level: BasicLevel) {
        level.setSolvable(isSolvable: checkSolvable(level: level))
        if (level.isSolvable()) {
            level.setStuckable(isStuckable: checkStuckable(level: level))
        } else {
            level.setStuckable(isStuckable: true)
        }
        level.setSolved(isSolved: true)
    }
    
    private func searchAndSpan(level: BasicLevel, currentExplorationStage: Int) -> Int {
        
        var numSpans = 0
        let directions = ["left", "right", "up", "down"]
        
        var newPosition = Array<Int>()
        
        var row = 0
        var col = 0
        for curRow in level.getBlocksExploration() {
            for expStage in curRow {
                
                if expStage == currentExplorationStage {
                    
                    if Array<Int>([row, col]) != level.getEndPosition() {
                        
                        numSpans += 1
                        for direction in directions {
                            (newPosition, _, _) = level.calculateMove(position: [col, row], direction: direction)
                            if level.getBlocksExplorationValue(position: newPosition) == 0 {
                                level.setBlocksExplorationValue(position: newPosition,
                                                                value: currentExplorationStage + 1)
                            }
                        }
                    }
                }
                col += 1
            }
            col = 0
            row += 1
        }

        return numSpans
    }
    
    func checkSolvable(level: BasicLevel) -> Bool {
        
        if level.getBlocksExplorationValue(position: level.getEndPosition()) == 0 {
            return false
        } else {
            return true
        }

    }
    
    func checkStuckable(level: BasicLevel) -> Bool {
        
        let copyOfBlocksExploration = level.getBlocksExploration()
        
        var row = 0
        var col = 0
        for curRow in copyOfBlocksExploration {
            for expStage in curRow {
                
                if expStage >= 2 {
                    
                    runExplorationAlgorithm(level: level, startPosition: [col, row])
                    if (checkSolvable(level: level) == false) {
                        level.setBlocksExploration(blocks: copyOfBlocksExploration)
                        return true
                    }
                }
                col += 1
            }
            col = 0
            row += 1
        }
        level.setBlocksExploration(blocks: copyOfBlocksExploration)
        return false
    }
}
