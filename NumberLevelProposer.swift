//
//  NumberLevelProposer.swift
//  Slide the Box
//
//  Created by Alex Morgan on 23/12/2016.
//  Copyright © 2016 Alex Morgan. All rights reserved.
//

import SpriteKit

class NumberLevelProposer: BasicLevelProposer {
      
    override func propose(difficulty: BaseDifficultyCriteria) -> BaseLevel {
        
        let level = NumberLevel(numBlocksX: numBlocksX, numBlocksY: numBlocksY)
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
    
    func generateNumNumberBlocks(difficulty: BaseDifficultyCriteria) -> Int {
       
        let maxNumNumberBlocks = 4
        let levelNumBlocks = Int(arc4random_uniform(UInt32(maxNumNumberBlocks))+1)
        
        return levelNumBlocks
    }
    
}
