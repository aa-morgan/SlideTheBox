//
//  BasicLevelSolver.swift
//  Slide the Box
//
//  Created by Alex Morgan on 09/12/2016.
//  Copyright © 2016 Alex Morgan. All rights reserved.
//

import Foundation

class BasicLevelSolver: BaseLevelSolver {
    
    let directions = ["left", "right", "up", "down"]
    
    // Given a BasicLevel, run the main exploration algorithm and set the results
    func solve(level: BaseLevel) {
        runExplorationAlgorithm(level: level, startPosition: level.getStartPosition())
        setLevelProperties(level: level)
    }
    
    // Given a BasicLevel and a custom start position, return the next move
    func solveForNextMove(level: BaseLevel, customStart: Array<Int>) -> String {
        var nextMove = String()
        
        if !(level.getEndPosition() == customStart) {
            let calculatedRoute = customSolve(level: level, customStart: customStart)
            nextMove = nextMoveFromRoute(calculatedRoute: calculatedRoute, startPosition: customStart, endPosition: level.getEndPosition())
        } else {
            nextMove = "none"
            print("Error (in BasicLevelSolver.solveForNextMove): CustomStart is equal to EndPosition!")
        }
        
        return nextMove
    }
    
    // Given a BasicLevel and custom start location, return the respective calculatedRoute
    func customSolve(level: BaseLevel, customStart: Array<Int>) -> Array<Array<Array<Array<Int>>>> {
        let copyOfBlocksExploration = level.getBlocksExploration()
        let copyOfCalculatedRoute = level.getCalculatedRoute()
        
        runExplorationAlgorithm(level: level, startPosition: customStart)
        
        let customCalculatedRoute = level.getCalculatedRoute()
        
        level.setBlocksExploration(blocks: copyOfBlocksExploration)
        level.setCalculatedRoute(calculatedRoute: copyOfCalculatedRoute)
        
        return customCalculatedRoute
    }
    
    func nextMoveFromRoute(calculatedRoute: Array<Array<Array<Array<Int>>>>, startPosition: Array<Int>, endPosition: Array<Int>) -> String {
        
        var currentPosition = endPosition
        var currentRoute: Array<Array<Int>>
        var finished = false
        
        repeat {
            
            currentRoute = calculatedRoute[currentPosition[1]][currentPosition[0]]
            
            if currentRoute.first! == startPosition {
                finished = true
            } else {
                currentPosition = currentRoute.first!
            }
            
        } while (!finished)
        
        return directionBetween(from: startPosition, to: currentRoute[1])
    }
    
    // Main exploration algorithm
    func runExplorationAlgorithm(level: BaseLevel, startPosition: Array<Int>) {
        
        var currentExplorationStage = 1
        var numSpans = Int()
        
        level.resetBlocksExploration()
        level.resetCalculatedRoute()
        
        level.setBlocksExplorationValue(position: startPosition, value: currentExplorationStage)
        
        repeat {
            numSpans = searchSpanAndMark(level: level, currentExplorationStage: currentExplorationStage)
            currentExplorationStage += 1
        } while(numSpans > 0)
    }
    
    func searchSpanAndMark(level: BaseLevel, currentExplorationStage: Int) -> Int {
        
        var numSpans = 0
        var positions = Array<Array<Int>>()
        var newPosition = Array<Int>()
        
        var row = 0
        var col = 0
        for curRow in level.getBlocksExploration() {
            for expStage in curRow {
                if expStage == currentExplorationStage {
                    if [col, row] != level.getEndPosition() {
                        numSpans += 1
                        for direction in directions {
                            (positions, _, _) = level.calculateMove(position: [col, row], direction: direction)
                            newPosition = positions.last!
                            if level.getBlocksExplorationValue(position: newPosition) == 0 {
                                level.setBlocksExplorationValue(position: newPosition,
                                                                value: currentExplorationStage + 1)
                                level.setCalculatedRouteValue(position: newPosition, value: positions)
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
    
    func checkSolvable(level: BaseLevel) -> Bool {
        
        if level.getBlocksExplorationValue(position: level.getEndPosition()) == 0 {
            return false
        } else {
            return true
        }

    }
    
    func checkStuckable(level: BaseLevel) -> Bool {
        let copyOfBlocksExploration = level.getBlocksExploration()
        let copyOfCalculatedRoute = level.getCalculatedRoute()
        
        var row = 0
        var col = 0
        for curRow in copyOfBlocksExploration {
            for expStage in curRow {
                if expStage >= 2 {
                    runExplorationAlgorithm(level: level, startPosition: [col, row])
                    if (checkSolvable(level: level) == false) {
                        level.setBlocksExploration(blocks: copyOfBlocksExploration)
                        level.setCalculatedRoute(calculatedRoute: copyOfCalculatedRoute)
                        return true
                    }
                }
                col += 1
            }
            col = 0
            row += 1
        }
        
        level.setBlocksExploration(blocks: copyOfBlocksExploration)
        level.setCalculatedRoute(calculatedRoute: copyOfCalculatedRoute)
        return false
    }
    
    func setLevelProperties(level: BaseLevel) {
        level.setSolvable(isSolvable: checkSolvable(level: level))
        if (level.isSolvable()) {
            level.setStuckable(isStuckable: checkStuckable(level: level))
            
        } else {
            level.setStuckable(isStuckable: true)
        }
        level.setSolved(isSolved: true)
    }
    
    func incrementPosition(position: Array<Int>, direction: String) -> Array<Int> {
        var newPosition = position
        if direction == "up" {
            newPosition[1] -= 1
        } else if direction == "down" {
            newPosition[1] += 1
        } else if direction == "left" {
            newPosition[0] -= 1
        } else if direction == "right" {
            newPosition[0] += 1
        }
        
        return newPosition
    }
    
    func inverseDirection(direction: String) -> String {
        if (direction == "up") {
            return "down"
        } else if (direction == "down") {
            return "up"
        } else if (direction == "left") {
            return "right"
        } else if (direction == "right") {
            return "left"
        } else {
            return "none"
        }
    }
    
    func directionBetween(from: Array<Int>, to: Array<Int>) -> String {
        
        var triggers = 0
        var direction = "none"
        
        if (from[0] > to[0]) {
            direction = "left"
            triggers += 1
        }
        if (from[0] < to[0]) {
            direction = "right"
            triggers += 1
        }
        if (from[1] > to[1]) {
            direction = "up"
            triggers += 1
        }
        if (from[1] < to[1]) {
            direction = "down"
            triggers += 1
        }
        
        if (triggers == 0) {
            print("Error (in BasicLevelSolver.directionBetween): From and To locations are the same!")
        } else if (triggers > 1) {
            print("Error (in BasicLevelSolver.directionBetween): From and To locations do not share an axis!")
        }
        
        return direction
    }
}
