//
//  LevelSolver.swift
//  Slide the Box
//
//  Created by Alex Morgan on 31/12/2016.
//  Copyright © 2016 Alex Morgan. All rights reserved.
//

import Foundation

class LevelSolver {
    
    let directions = ["left", "right", "up", "down"]
    
    // Given a BasicLevel, run the main exploration algorithm and set the results
    func solve(level: Level) {
        runExplorationAlgorithm(level: level, startPosition: level.getStartPosition())
        setLevelProperties(level: level)
    }
    
    // Given a BasicLevel and a custom start position, return the next move
    func solveForNextMove(level: Level, customStart: Array<Int>, customEnd: Array<Int>) -> (direction: String, notFound: Bool) {
        var nextMove = String()
        var notFound = Bool()
        
        if !(customEnd == customStart) {
            let calculatedRoute = customSolve(level: level, customStart: customStart)
            (nextMove, notFound) = nextMoveFromRoute(calculatedRoute: calculatedRoute, startPosition: customStart, endPosition: customEnd)
            
            if notFound {
                return (direction: "none", notFound: true)
            }
        } else {
            return (direction: "none", notFound: true)
        }
        
        return (direction: nextMove, notFound: false)
    }
    
    // Given a BasicLevel and custom start location, return the respective calculatedRoute
    func customSolve(level: Level, customStart: Array<Int>) -> Array<Array<Array<Array<Int>>>> {
        let copyOfBlocksExploration = level.getSolution().getBlocksExploration()
        let copyOfCalculatedRoute = level.getSolution().getCalculatedRoute()
        
        runExplorationAlgorithm(level: level, startPosition: customStart)
        
        let customCalculatedRoute = level.getSolution().getCalculatedRoute()
        
        level.getSolution().setBlocksExploration(blocks: copyOfBlocksExploration)
        level.getSolution().setCalculatedRoute(calculatedRoute: copyOfCalculatedRoute)
        
        return customCalculatedRoute
    }
    
    func nextMoveFromRoute(calculatedRoute: Array<Array<Array<Array<Int>>>>, startPosition: Array<Int>, endPosition: Array<Int>) -> (direction: String, notFound: Bool) {
        
        var currentPosition = endPosition
        var currentRoute: Array<Array<Int>>
        var finished = false
        
        repeat {
            
            currentRoute = calculatedRoute[currentPosition[1]][currentPosition[0]]
            
            if currentRoute.isEmpty {
                return (direction: "none", notFound: true)
            }
            
            if currentRoute.first! == startPosition {
                finished = true
            } else {
                currentPosition = currentRoute.first!
            }
            
        } while (!finished)
        
        return (direction: directionBetween(from: startPosition, to: currentRoute[1]), notFound: false)
    }
    
    // Main exploration algorithm
    func runExplorationAlgorithm(level: Level, startPosition: Array<Int>) {
        
        var currentExplorationStage = 1
        var numSpans = Int()
        
        level.getSolution().resetBlocksExploration()
        level.getSolution().resetCalculatedRoute()
        
        level.getSolution().setBlocksExplorationValue(position: startPosition, value: currentExplorationStage)
        
        repeat {
            numSpans = searchSpanAndMark(level: level, currentExplorationStage: currentExplorationStage)
            currentExplorationStage += 1
        } while(numSpans > 0)
    }
    
    func searchSpanAndMark(level: Level, currentExplorationStage: Int) -> Int {
        
        var numSpans = 0
        var positions = Array<Array<Int>>()
        var newPosition = Array<Int>()
        var infiniteArrowLoop = false
        
        var row = 0
        var col = 0
        for curRow in level.getSolution().getBlocksExploration() {
            for expStage in curRow {
                if expStage == currentExplorationStage {
                    if [col, row] != level.getEndPosition() {
                        numSpans += 1
                        for direction in directions {
                            (positions, _, _, infiniteArrowLoop) = level.calculateMove(position: [col, row], direction: direction, blockType: "player")
                            newPosition = positions.last!
                            if level.getSolution().getBlocksExplorationValue(position: newPosition) == 0 {
                                level.getSolution().setBlocksExplorationValue(position: newPosition,
                                                                value: currentExplorationStage + 1)
                                level.getSolution().setCalculatedRouteValue(position: newPosition, value: positions)
                            }
                            if infiniteArrowLoop {
                                level.getSolution().setInfiniteArrowLoop(value: true)
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
    
    func checkSolvable(level: Level) -> Bool {
        
        if level.getSolution().getBlocksExplorationValue(position: level.getEndPosition()) == 0 {
            return false
        } else {
            return true
        }
        
    }
    
    func checkStuckable(level: Level) -> Bool {
        let copyOfBlocksExploration = level.getSolution().getBlocksExploration()
        let copyOfCalculatedRoute = level.getSolution().getCalculatedRoute()
        
        var row = 0
        var col = 0
        for curRow in copyOfBlocksExploration {
            for expStage in curRow {
                if expStage >= 2 {
                    runExplorationAlgorithm(level: level, startPosition: [col, row])
                    if (checkSolvable(level: level) == false) {
                        level.getSolution().setBlocksExploration(blocks: copyOfBlocksExploration)
                        level.getSolution().setCalculatedRoute(calculatedRoute: copyOfCalculatedRoute)
                        return true
                    }
                }
                col += 1
            }
            col = 0
            row += 1
        }
        
        level.getSolution().setBlocksExploration(blocks: copyOfBlocksExploration)
        level.getSolution().setCalculatedRoute(calculatedRoute: copyOfCalculatedRoute)
        return false
    }
    
    func setLevelProperties(level: Level) {
        level.getSolution().setSolvable(isSolvable: checkSolvable(level: level))
        if (level.getSolution().isSolvable()) {
            level.getSolution().setStuckable(isStuckable: checkStuckable(level: level))
            
        } else {
            level.getSolution().setStuckable(isStuckable: true)
        }
        level.getSolution().setSolved(isSolved: true)
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
