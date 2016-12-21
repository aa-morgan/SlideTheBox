//
//  DifficultyCriteria.swift
//  Slide the Box
//
//  Created by Alex Morgan on 13/12/2016.
//  Copyright © 2016 Alex Morgan. All rights reserved.
//

import Foundation

class BasicDifficultyCriteria {
    
    private var minMoves = Int()
    private var percentOfBlockBlocks = Float()
    private var maxExplorationStage = Int()
    private var numberOfExplorablePositions = Int()
    private var averageMoveDistance = Float()
    private var percentOfRouteOnBoundary = Float()
    private var endBlockOnBoundary = Bool()
    
    init() {
    }
    
    init(difficulty: String) {
        
        if difficulty == "easy" {
            self.minMoves = Int(5)
            self.percentOfBlockBlocks = Float(0.5)
        } else if difficulty == "medium" {
            
        } else if difficulty == "hard" {
            
        }
        
    }
    
    func met(level: BasicLevel) -> Bool {
        
        if (getMinMoves(level: level) > self.minMoves &&
            getPercentOfBlockBlocks(level: level) < self.percentOfBlockBlocks) {
            return true
        } else {
            return false
        }
        
    }
    
    func score(level: BasicLevel) -> Int {
        // Calculate difficulty score
        return 0
    }
    
    func getMinMoves(level: BasicLevel) -> Int {
        return level.getMinMoves()
    }
    
    func getPercentOfBlockBlocks(level: BasicLevel) -> Float {
        return Float(level.getNumBlockBlocks()) / Float((level.getNumBlocks()))
    }
    
    func getMaxExplorationStage(level: BasicLevel) -> Int {
        let (value, _) = level.twoDimMax(array: level.getBlocksExploration())
        return value
    }
    
    func getNumberOfExplorablePositions(level: BasicLevel) -> Int {
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
    
    func getAverageMoveDistance(level: BasicLevel) -> Float {
        var routePositions = level.getRoutePositions()
        let numMoves = routePositions.count - 1
        var distance = Int()
        var totalDistance = Int(0)
        
        var lastPosition = routePositions.remove(at: 0)

        for position in routePositions {
            distance = distanceBetween(from: lastPosition, to: position)
            totalDistance += distance
            
            lastPosition = position
        }
        
        let averageMoveDistance = Float(totalDistance) / Float(numMoves)
        return averageMoveDistance
    }
    
    func getPercentOfRouteOnBoundary(level: BasicLevel) -> Float {
        var routePositions = level.getRoutePositions()
        var distance = Int()
        var totalDistanceOn = Int(0)
        var totalDistanceOff = Int(0)
        
        var lastPosition = routePositions.remove(at: 0)
        
        for position in routePositions {
            distance = distanceBetween(from: lastPosition, to: position)
            if (level.isPositionOnBoundary(position: lastPosition) &&
                level.isPositionOnBoundary(position: position)) {
                totalDistanceOn += distance
            } else {
                totalDistanceOff += distance
            }
            
            lastPosition = position
        }
        
        let percentOfRouteOnBoundary = Float(totalDistanceOn) / Float(totalDistanceOn + totalDistanceOff)
        return percentOfRouteOnBoundary
    }
    
    func isEndBlockOnBoundary(level: BasicLevel) -> Bool {
        let endPosition = level.getEndPosition()
        
        return level.isPositionOnBoundary(position: endPosition)
    }
    
    func distanceBetween(from: Array<Int>, to: Array<Int>) -> Int {
        let xDistance = to[0] - from[0]
        let yDistance = to[1] - from[1]
        let totalDistance = abs(xDistance + yDistance)
        
        return totalDistance
    }
}
