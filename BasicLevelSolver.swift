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
    
    func solve(level: BasicLevel) -> BasicLevel {
        
        var currentExplorationStage = 1
        var numSpans = Int()
        
        print(level.getStartPosition())
        print(level.getBlocksReal())
        //print(level.getBlocksExploration())
        
        level.setBlocksExplorationValue(position: level.getStartPosition(), value: currentExplorationStage)
        
        repeat {
            numSpans = searchAndSpan(level: level, currentExplorationStage: currentExplorationStage)
            currentExplorationStage += 1
        } while(numSpans > 0)
        
        level.setSolvable(isSolvable: checkSolvable(level: level))
        level.setStuckable(isStuckable: checkStuckable(level: level))
        level.setSolved(isSolved: true)
        return level
    }
    
    private func searchAndSpan(level: BasicLevel, currentExplorationStage: Int) -> Int {
        
        var numSpans = 0
        let directions = ["left", "right", "up", "down"]
        
        var newPosition = Array<Int>()
        var numMoves = Int()
        var levelFinished = Bool()
        
        var row = 0
        var col = 0
        for curRow in level.getBlocksExploration() {
            for expStage in curRow {
                
                if expStage == currentExplorationStage {
                    
                    if Array<Int>([row, col]) != level.getEndPosition() {
                        
                        numSpans += 1
                        for direction in directions {
                            (newPosition, numMoves, levelFinished)
                                = level.calculateMove(position: [col, row], direction: direction)
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
        
        return false
    }
}
