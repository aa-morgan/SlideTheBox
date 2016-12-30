//
//  BaseDifficultyCriteria.swift
//  Slide the Box
//
//  Created by Alex Morgan on 30/12/2016.
//  Copyright © 2016 Alex Morgan. All rights reserved.
//

import SpriteKit

protocol BaseDifficultyCriteria {
    
    func met(level: BaseLevel) -> Bool
    func score(level: BaseLevel) -> Int
    
    func getPercentOfBlockBlocksCriteria() -> Float
    func getMinMoves(level: BaseLevel) -> Int
    func getPercentOfBlockBlocks(level: BaseLevel) -> Float
    func getMaxExplorationStage(level: BaseLevel) -> Int
    func getNumberOfExplorablePositions(level: BaseLevel) -> Int
    func getAverageMoveDistance(level: BaseLevel) -> Float
    func getPercentOfRouteOnBoundary(level: BaseLevel) -> Float
    func isEndBlockOnBoundary(level: BaseLevel) -> Bool
}
