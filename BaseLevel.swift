//
//  BaseLevel.swift
//  Slide the Box
//
//  Created by Alex Morgan on 22/12/2016.
//  Copyright © 2016 Alex Morgan. All rights reserved.
//

import SpriteKit

protocol BaseLevel {
    
    func calculateMove(position: Array<Int>, direction: String)
        -> (positions: Array<Array<Int>>, numMoves: Array<Int>, endBlock: Bool)
    
    func positionInBounds(position: Array<Int>) -> Bool
    func isPositionOnBoundary(position: Array<Int>) -> Bool
    
    func isSolved() -> Bool
    func setSolved(isSolved: Bool)
    func isSolvable() -> Bool
    func setSolvable(isSolvable: Bool)
    func isStuckable() -> Bool
    func setStuckable(isStuckable: Bool)
    
    func getStartPosition() -> Array<Int>
    func getEndPosition() -> Array<Int>
    
    func getBlocksReal() -> Array<Array<Int>>
    func getBlocksRealValue(position: Array<Int>) -> Int
    func getBlocksExploration() -> Array<Array<Int>>
    func getBlocksExplorationValue(position: Array<Int>) -> Int
    func setBlocksExploration(blocks: Array<Array<Int>>)
    func setBlocksExplorationValue(position: Array<Int>, value: Int)
    func resetBlocksExploration()
    
    func getCalculatedRoute() -> Array<Array<Array<Array<Int>>>>
    func setCalculatedRoute(calculatedRoute: Array<Array<Array<Array<Int>>>>)
    func setCalculatedRouteValue(position: Array<Int>, value: Array<Array<Int>>)
    func resetCalculatedRoute()
    
    func twoDimMax(array: Array<Array<Int>>) -> (value: Int, index: Array<Int>)
    func getNumBlockBlocks() -> Int
    func setNumBlockBlocks(number: Int)
    func getMinMoves() -> Int
    func getNumBlocks() -> Int
    
}
