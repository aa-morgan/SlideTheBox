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
    
    func isSolvable() -> Bool
    func isStuckable() -> Bool
    
    func getStartPosition() -> Array<Int>
    func getEndPosition() -> Array<Int>
    
    func getBlocksReal() -> Array<Array<Int>>
    func getBlocksRealValue(position: Array<Int>) -> Int
    func getBlocksExploration() -> Array<Array<Int>>
    func getBlocksExplorationValue(position: Array<Int>) -> Int

}
