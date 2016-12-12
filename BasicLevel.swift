//
//  BasicLevel.swift
//  Slide the Box
//
//  Created by Alex Morgan on 06/12/2016.
//  Copyright © 2016 Alex Morgan. All rights reserved.
//

import SpriteKit

class BasicLevel {
    
    private var blocksReal = Array<Array<Int>>()
    private var blocksExploration = Array<Array<Int>>()
    
    private var numBlocksX = Int()
    private var numBlocksY = Int()
    
    private var startPosition = Array<Int>()
    private var endPosition = Array<Int>()
    
    init() {
    }
    
    init(numBlocksX: Int, numBlocksY: Int) {
        self.numBlocksX = numBlocksX
        self.numBlocksY = numBlocksY
    }
    
    func calculateMove(position: Array<Int>, direction: String) -> Int {
        
        var finished = false
        var numMoves = 0
        var col = position[0]
        var row = position[1]
        
        while(!finished) {
            if (direction == "up") {
                row -= 1
            } else if direction == "down" {
                row += 1
            } else if direction == "left" {
                col -= 1
            } else if direction == "right" {
                col += 1
            }
            
            if (row >= 0 && row < numBlocksY) && (col >= 0 && col < numBlocksX) {
                if blocksReal[row][col] != 1 {
                    numMoves += 1
                } else {
                    finished = true
                }
            } else {
                finished = true
            }
            
        }
        
        return numMoves
    }
    
    func getBlocksReal() -> Array<Array<Int>> {
        return self.blocksReal
    }
    
    func setBlocksReal(blocks: Array<Array<Int>>) {
        self.blocksReal = blocks
    }
    
    func getBlocksExploration() -> Array<Array<Int>> {
        return self.blocksExploration
    }
    
    func setBlocksExploration(blocks: Array<Array<Int>>) {
        self.blocksExploration = blocks
    }
    
    func getStartPosition() -> Array<Int> {
        return self.startPosition
    }
    
    func setStartPosition(position: Array<Int>) {
        self.startPosition = position
    }
    
    func getEndPosition() -> Array<Int> {
        return self.endPosition
    }
    
    func setEndPosition(position: Array<Int>) {
        self.endPosition = position
    }
    
    func getBlockDensity() -> CGFloat {
        return CGFloat(0)
    }
    
}
