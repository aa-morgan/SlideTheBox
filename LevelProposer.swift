//
//  LevelProposer.swift
//  Slide the Box
//
//  Created by Alex Morgan on 31/12/2016.
//  Copyright © 2016 Alex Morgan. All rights reserved.
//

import SpriteKit

class LevelProposer {
    
    var numBlocksX = Int()
    var numBlocksY = Int()
    
    var useNumbers = Bool()
    var useArrows = Bool()
    
    var blocksReal = Array<Array<Int>>()
    
    init() {
    }
    
    init(numBlocksX: Int, numBlocksY: Int, useNumbers: Bool, useArrows: Bool) {
        self.numBlocksX = numBlocksX
        self.numBlocksY = numBlocksY
        self.useNumbers = useNumbers
        self.useArrows = useArrows
    }
    
    func propose(difficulty: DifficultyCriteria) -> Level {
    
        let level = Level(numBlocksX: numBlocksX, numBlocksY: numBlocksY)
        let numBlocks = generateNumBlockBlocks(difficulty: difficulty)
        let numNumbers = generateNumNumberBlocks(difficulty: difficulty)
        
        var startPosition = Array<Int>()
        var endPosition = Array<Int>()
        (blocksReal, startPosition, endPosition) = proposeBlocksReal(numBlocks: numBlocks)
        blocksReal = addNumbers(blocksReal: blocksReal, numNumbers: numNumbers)
        
        level.setBlocksReal(blocks: blocksReal)
        level.setStartPosition(position: startPosition)
        level.setEndPosition(position: endPosition)
        level.setNumBlockBlocks(number: numBlocks)
        level.setNumNumberBlocks(number: numNumbers)
        
        return level
    }
    
    func proposeBlocksReal(numBlocks: Int) -> (blocksReal: Array<Array<Int>>,
        startPosition: Array<Int>, endPosition: Array<Int>) {
            
            var blocksReal: Array<Array<Int>> = Array(repeating: Array(repeating: 0, count: numBlocksX), count: numBlocksY)
            
            // Place random starting location
            let startPosition = [Int(arc4random_uniform(UInt32(numBlocksX))),
                                 Int(arc4random_uniform(UInt32(numBlocksY)))]
            
            blocksReal[startPosition[1]][startPosition[0]] = 8
            
            // Place random end location
            var trialPosition = Array<Int>()
            
            var freePositionFound = false
            while(!freePositionFound) {
                trialPosition = [Int(arc4random_uniform(UInt32(numBlocksX))),
                                 Int(arc4random_uniform(UInt32(numBlocksY)))]
                
                if blocksReal[trialPosition[1]][trialPosition[0]] == 0 {
                    freePositionFound = true
                }
            }
            
            let endPosition = trialPosition
            
            blocksReal[endPosition[1]][endPosition[0]] = 9
            
            // Place N blocks randomly
            var blocksPlaced = 0
            while(blocksPlaced < numBlocks) {
                trialPosition = [Int(arc4random_uniform(UInt32(numBlocksX))),
                                 Int(arc4random_uniform(UInt32(numBlocksY)))]
                
                if blocksReal[trialPosition[1]][trialPosition[0]] == 0 {
                    
                    blocksReal[trialPosition[1]][trialPosition[0]] = 1
                    blocksPlaced += 1
                }
            }
            
            return (blocksReal: blocksReal, startPosition: startPosition, endPosition: endPosition)
    }
    
    func addNumbers(blocksReal: Array<Array<Int>>, numNumbers: Int) -> Array<Array<Int>> {
        var newBlocksReal = blocksReal
        var trialPosition = Array<Int>()
        
        // Place N random numbers randomly
        var blocksPlaced = 0
        while(blocksPlaced < numNumbers) {
            trialPosition = [Int(arc4random_uniform(UInt32(numBlocksX))),
                             Int(arc4random_uniform(UInt32(numBlocksY)))]
            
            if newBlocksReal[trialPosition[1]][trialPosition[0]] == 0 {
                // Number: 0 -> Code: 10
                // Number: 1 -> Code: 11
                // Number: 2 -> Code: 12
                // Number: 3 -> Code: 13
                let maxNumber = 3
                let numberValue = Int(arc4random_uniform(UInt32(maxNumber+1)))
                newBlocksReal[trialPosition[1]][trialPosition[0]] = 10+numberValue
                blocksPlaced += 1
            }
        }
        
        return newBlocksReal
    }
    
    func generateNumBlockBlocks(difficulty: DifficultyCriteria) -> Int {
        //            let levelNumBlocks = (numBlocksX*numBlocksY)/8
        
        let levelMaxBlocks = difficulty.getPercentOfBlockBlocksCriteria() * Float(numBlocksX * numBlocksY)
        let levelNumBlockBlocks = Int(arc4random_uniform(UInt32(levelMaxBlocks)-3)+3)
        
        //            var levelNumBlocks = Int()
        //            var percentOfBlockBlocks = Float()
        //            repeat {
        //                levelNumBlocks = randomGaussian(mean:   Float(numBlocksX*numBlocksY)/6,
        //                                                stddev: Float(numBlocksX*numBlocksY)/8)
        //                percentOfBlockBlocks = Float(levelNumBlocks) / Float(numBlocksX * numBlocksY)
        //            } while (percentOfBlockBlocks <= difficulty.getPercentOfBlockBlocksCriteria())
        
        return levelNumBlockBlocks
    }
    
    func generateNumNumberBlocks(difficulty: DifficultyCriteria) -> Int {
        
        let maxNumNumberBlocks = 4
        let levelNumBlocks = Int(arc4random_uniform(UInt32(maxNumNumberBlocks))+1)
        
        return levelNumBlocks
    }
    
}
