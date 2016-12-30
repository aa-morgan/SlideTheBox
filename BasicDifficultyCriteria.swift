//
//  DifficultyCriteria.swift
//  Slide the Box
//
//  Created by Alex Morgan on 13/12/2016.
//  Copyright © 2016 Alex Morgan. All rights reserved.
//

import Foundation

class BasicDifficultyCriteria: BaseDifficultyCriteria {
    
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
            self.percentOfBlockBlocks = Float(0.25)
        } else if difficulty == "medium" {
            self.minMoves = Int(8)
            self.percentOfBlockBlocks = Float(0.2)
        } else if difficulty == "hard" {
            self.minMoves = Int(12)
            self.percentOfBlockBlocks = Float(0.2)
        }
        
    }
    
    func met(level: BaseLevel) -> Bool {
        
        if (getMinMoves(level: level as! BasicLevel) >= self.minMoves &&
            getPercentOfBlockBlocks(level: level as! BasicLevel) <= self.percentOfBlockBlocks) {
            return true
        } else {
            return false
        }
        
    }
    
    func score(level: BaseLevel) -> Int {
        // Calculate difficulty score
        
        
        return 0
    }
    
    func getMinMoves(level: BaseLevel) -> Int {
        return (level as! BasicLevel).getMinMoves()
    }
    
    func getMinMovesCriteria() -> Int {
        return self.minMoves
    }
    
    func getPercentOfBlockBlocks(level: BaseLevel) -> Float {
        return Float((level as! BasicLevel).getNumBlockBlocks()) / Float(((level as! BasicLevel).getNumBlocks()))
    }
    
    func getPercentOfBlockBlocksCriteria() -> Float {
        return self.percentOfBlockBlocks
    }
    
    func getMaxExplorationStage(level: BaseLevel) -> Int {
        let (value, _) = (level as! BasicLevel).twoDimMax(array: (level as! BasicLevel).getBlocksExploration())
        return value
    }
    
    func getNumberOfExplorablePositions(level: BaseLevel) -> Int {
        var explorableCount = 0
        
        var row = 0
        var col = 0
        for curRow in (level as! BasicLevel).getBlocksExploration() {
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
    
    func getAverageMoveDistance(level: BaseLevel) -> Float {
        var routePositions = (level as! BasicLevel).getRoutePositions()
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
    
    func getPercentOfRouteOnBoundary(level: BaseLevel) -> Float {
        var routePositions = (level as! BasicLevel).getRoutePositions()
        var distance = Int()
        var totalDistanceOn = Int(0)
        var totalDistanceOff = Int(0)
        
        var lastPosition = routePositions.remove(at: 0)
        
        for position in routePositions {
            distance = distanceBetween(from: lastPosition, to: position)
            if ((level as! BasicLevel).isPositionOnBoundary(position: lastPosition) &&
                (level as! BasicLevel).isPositionOnBoundary(position: position)) {
                totalDistanceOn += distance
            } else {
                totalDistanceOff += distance
            }
            
            lastPosition = position
        }
        
        let percentOfRouteOnBoundary = Float(totalDistanceOn) / Float(totalDistanceOn + totalDistanceOff)
        return percentOfRouteOnBoundary
    }
    
    func isEndBlockOnBoundary(level: BaseLevel) -> Bool {
        let endPosition = (level as! BasicLevel).getEndPosition()
        
        return (level as! BasicLevel).isPositionOnBoundary(position: endPosition)
    }
    
    func distanceBetween(from: Array<Int>, to: Array<Int>) -> Int {
        let xDistance = to[0] - from[0]
        let yDistance = to[1] - from[1]
        let totalDistance = abs(xDistance + yDistance)
        
        return totalDistance
    }
}
