//
//  BasicLevelSolver.swift
//  Slide the Box
//
//  Created by Alex Morgan on 09/12/2016.
//  Copyright © 2016 Alex Morgan. All rights reserved.
//

import Foundation

class BasicLevelSolver {
    
    let directions = ["left", "right", "up", "down"]
    
    init() {
    }
    
    // Given a BasicLevel, run the main exploration algorithm and set the results
    func solve(level: BasicLevel) {
        runExplorationAlgorithm(level: level, startPosition: level.getStartPosition())
        setLevelProperties(level: level)
    }
    
    // Given a BasicLevel and a custom start position, return the next move
    func solveForNextMove(level: BasicLevel, customStart: Array<Int>) -> String {
        var nextMove = String()
        
        if !(level.getEndPosition() == customStart) {
            let (_, routeDirections) = routeToEnd(level: level, customStart: customStart)
            nextMove = routeDirections[0]
        } else {
            nextMove = "none"
        }
        
        return nextMove
    }
    
    // Given a BasicLevel and a custom start position, return an array of directions to the end block
    private func routeToEnd(level: BasicLevel, customStart: Array<Int>) -> (routePositions: Array<Array<Int>>, routeDirections: Array<String>) {
        
        var routeDirections = Array<String>()
        var routePositions = Array<Array<Int>>()
        let customBlocksExploration = customSolve(level: level, customStart: customStart)
        
        var headPosition = level.getEndPosition()
        var headExploreStage = customBlocksExploration[headPosition[1]][headPosition[0]]
        var found = Bool()
        var direction = String()
        
        routePositions.append(headPosition)
        
        repeat {
            headExploreStage -= 1
            (found, headPosition, direction) = spanAndSearch(level: level, customBlocksExploration: customBlocksExploration, spanPosition: headPosition, searchFor: headExploreStage)
            if !found {
                print("Error: Could not find exploration stage!")
                break
            } else {
                routeDirections.append(inverseDirection(direction: direction))
                routePositions.append(headPosition)
            }
        } while(headExploreStage > 1)
        
        routeDirections.reverse()
        routePositions.reverse()
        
        return (routePositions: routePositions, routeDirections: routeDirections)
    }
    
    // Given a BasicLevel and custom start location, return the respective blocksExploration
    private func customSolve(level: BasicLevel, customStart: Array<Int>) -> Array<Array<Int>> {
        let copyOfBlocksExploration = level.getBlocksExploration()
        runExplorationAlgorithm(level: level, startPosition: customStart)
        let customBlocksExploration = level.getBlocksExploration()
        level.setBlocksExploration(blocks: copyOfBlocksExploration)
        return customBlocksExploration
    }
    
    // Given a BasicLevel, custom exploration blocks, position and exploration stage to search for,
    // Returns whether it was found and at what position
    private func spanAndSearch(level: BasicLevel, customBlocksExploration: Array<Array<Int>>,
                               spanPosition: Array<Int>, searchFor: Int) -> (found: Bool, index: Array<Int>, direction: String) {
        var positionFound = false;
        var currentPosition = Array<Int>()
        var stopSpanning = Bool()
        let blocksExplortation = customBlocksExploration
    
        for direction in directions {
            currentPosition = spanPosition
            stopSpanning = false
            
            repeat {
                currentPosition = incrementPosition(position: currentPosition, direction: direction)
                
                if (level.positionInBounds(position: currentPosition)) {
                    if (level.getBlocksRealValue(position: currentPosition) == 1 ) {
                        stopSpanning = true
                    } else {
                        if blocksExplortation[currentPosition[1]][currentPosition[0]] == searchFor {
                            positionFound = true
                            return (positionFound, currentPosition, direction)
                        }
                    }
                } else {
                    stopSpanning = true
                }
            
            } while(!stopSpanning)
        }
        
        return (positionFound, currentPosition, direction: "none")
    }
    
    // Main exploration algorithm
    private func runExplorationAlgorithm(level: BasicLevel, startPosition: Array<Int>) {
        
        var currentExplorationStage = 1
        var numSpans = Int()
        
        level.resetBlocksExploration()
        level.setBlocksExplorationValue(position: startPosition, value: currentExplorationStage)
        
        repeat {
            numSpans = searchSpanAndMark(level: level, currentExplorationStage: currentExplorationStage)
            currentExplorationStage += 1
        } while(numSpans > 0)
    }
    
    private func incrementPosition(position: Array<Int>, direction: String) -> Array<Int> {
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
    
    private func setLevelProperties(level: BasicLevel) {
        level.setSolvable(isSolvable: checkSolvable(level: level))
        if (level.isSolvable()) {
            level.setStuckable(isStuckable: checkStuckable(level: level))
        } else {
            level.setStuckable(isStuckable: true)
        }
        level.setSolved(isSolved: true)
    }
    
    private func searchSpanAndMark(level: BasicLevel, currentExplorationStage: Int) -> Int {
        
        var numSpans = 0
        
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
    
    private func twoDimMax(array: Array<Array<Int>>) -> (value: Int, index: Array<Int>) {
        
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
    
    private func inverseDirection(direction: String) -> String {
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
}
