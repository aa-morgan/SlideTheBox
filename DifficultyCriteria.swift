//
//  DifficultyCriteria.swift
//  Slide the Box
//
//  Created by Alex Morgan on 31/12/2016.
//  Copyright © 2016 Alex Morgan. All rights reserved.
//

import Foundation

class DifficultyCriteria {
    
    var minMoves = Int()
    var percentOfBlockBlocks = Float()
    var maxExplorationStage = Int()
    var numberOfExplorablePositions = Int()
    var averageMoveDistance = Float()
    var percentOfRouteOnBoundary = Float()
    var endBlockOnBoundary = Bool()
    var numNumberBlocksUsed = Int()
    
    init() {
    }
    
    init(difficulty: String) {
        
        if difficulty == "easy" {
            self.minMoves = Int(5)
            self.percentOfBlockBlocks = Float(0.25)
        } else if difficulty == "medium" {
            self.minMoves = Int(8)
            self.percentOfBlockBlocks = Float(0.2)
        } else if difficulty == "hard" {
            self.minMoves = Int(12)
            self.percentOfBlockBlocks = Float(0.2)
        }
        
    }
    
    func met(level: Level) -> Bool {
        
        if (getMinMoves(level: level) >= self.minMoves &&
            getPercentOfBlockBlocks(level: level) <= self.percentOfBlockBlocks) {
            return true
        } else {
            return false
        }
        
    }
    
    func score(level: Level) -> Int {
        // Calculate difficulty score
        
        
        return 0
    }
    
    func getMinMoves(level: Level) -> Int {
        return level.getMinMoves()
    }
    
    func getMinMovesCriteria() -> Int {
        return self.minMoves
    }
    
    func getPercentOfBlockBlocks(level: Level) -> Float {
        return Float(level.getNumBlockBlocks()) / Float((level.getNumBlocks()))
    }
    
    func getPercentOfBlockBlocksCriteria() -> Float {
        return self.percentOfBlockBlocks
    }
    
    func getMaxExplorationStage(level: Level) -> Int {
        let (value, _) = level.twoDimMax(array: level.getBlocksExploration())
        return value
    }
    
    func getNumberOfExplorablePositions(level: Level) -> Int {
        var explorableCount = 0
        
        var row = 0
        var col = 0
        for curRow in level.getBlocksExploration() {
            for stage in curRow {
                
                if (stage > 0) {
                    explorableCount += 1
                }
                
                col += 1
            }
            col = 0
            row += 1
        }
        
        return explorableCount
    }
    
    func getAverageMoveDistance(level: Level) -> Float {
        //        var routePositions = level.getRoutePositions()
        //        let numMoves = routePositions.count - 1
        //        var distance = Int()
        //        var totalDistance = Int(0)
        //
        //        var lastPosition = routePositions.remove(at: 0)
        //
        //        for position in routePositions {
        //            distance = distanceBetween(from: lastPosition, to: position)
        //            totalDistance += distance
        //
        //            lastPosition = position
        //        }
        //
        //        let averageMoveDistance = Float(totalDistance) / Float(numMoves)
        //        return averageMoveDistance
        return 0
    }
    
    func getPercentOfRouteOnBoundary(level: Level) -> Float {
        //        var routePositions = level.getRoutePositions()
        //        var distance = Int()
        //        var totalDistanceOn = Int(0)
        //        var totalDistanceOff = Int(0)
        //
        //        var lastPosition = routePositions.remove(at: 0)
        //
        //        for position in routePositions {
        //            distance = distanceBetween(from: lastPosition, to: position)
        //            if (level.isPositionOnBoundary(position: lastPosition) &&
        //                level.isPositionOnBoundary(position: position)) {
        //                totalDistanceOn += distance
        //            } else {
        //                totalDistanceOff += distance
        //            }
        //
        //            lastPosition = position
        //        }
        //
        //        let percentOfRouteOnBoundary = Float(totalDistanceOn) / Float(totalDistanceOn + totalDistanceOff)
        //        return percentOfRouteOnBoundary
        return 0
    }
    
    func isEndBlockOnBoundary(level: Level) -> Bool {
        let endPosition = level.getEndPosition()
        
        return level.isPositionOnBoundary(position: endPosition)
    }
    
    func distanceBetween(from: Array<Int>, to: Array<Int>) -> Int {
        let xDistance = to[0] - from[0]
        let yDistance = to[1] - from[1]
        let totalDistance = abs(xDistance + yDistance)
        
        return totalDistance
    }
    
    func getNumNumberBlocksUsed() -> Int {
        return self.numNumberBlocksUsed
    }
    
    func setNumNumberBlocksUsed(number: Int) {
        self.numNumberBlocksUsed = number
    }
    
    func incrementNumNumberBlocksUsed(number: Int) {
        self.numNumberBlocksUsed += 1
    }
}
