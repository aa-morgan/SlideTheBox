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
    
    let numbersSelectorKey = "Number of Numbers"
    let arrowsSelectorKey = "Number of Arrows"
    
    var blocksReal = Array<Array<Int>>()
    
    init() {
    }
    
    init(numBlocksX: Int, numBlocksY: Int) {
        self.numBlocksX = numBlocksX
        self.numBlocksY = numBlocksY
    }
    
    func propose(difficulty: DifficultyCriteria, useNumbers: Bool, useArrows: Bool) -> Level {
    
        let level = Level(numBlocksX: numBlocksX, numBlocksY: numBlocksY)
        
        var startPosition = Array<Int>()
        var endPosition = Array<Int>()
        var numBlocks = Int()
        var numNumbers = Int()
        var numArrows = Int()
        
        (blocksReal, startPosition, endPosition, numBlocks, numNumbers, numArrows) = proposeBlocksReal(difficulty: difficulty, useNumbers: useNumbers, useArrows: useArrows)
        
        level.setBlocksReal(blocks: blocksReal)
        level.setStartPosition(position: startPosition)
        level.setEndPosition(position: endPosition)
        level.setNumBlockBlocks(number: numBlocks)
        level.setNumNumberBlocks(number: numNumbers)
        level.setNumArrowBlocks(number: numArrows)
        
        return level
    }
    
    func proposeBlocksReal(difficulty: DifficultyCriteria, useNumbers: Bool, useArrows: Bool) -> (blocksReal: Array<Array<Int>>,
        startPosition: Array<Int>, endPosition: Array<Int>, numBlocks: Int, numNumbers: Int, numArrows: Int) {
            
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
            
            // Place N block blocks randomly
            let numBlocks = generateNumBlockBlocks(difficulty: difficulty)
            blocksReal = addBlockBlocks(blocksReal: blocksReal, numBlocks: numBlocks)
            
            // Place N number blocks randomly
            var numNumbers = 0
            if useNumbers {
                numNumbers = generateNumNumberBlocks(difficulty: difficulty)
                blocksReal = addNumberBlocks(blocksReal: blocksReal, numNumbers: numNumbers)
            }
            
            // Place N arrow blocks randomly
            var numArrows = 0
            if useArrows {
                numArrows = generateNumNumberBlocks(difficulty: difficulty)
                blocksReal = addArrowBlocks(blocksReal: blocksReal, numArrows: numArrows)
            }
            
            return (blocksReal: blocksReal, startPosition: startPosition, endPosition: endPosition, numBlocks: numBlocks, numNumbers: numNumbers, numArrows: numArrows)
    }
    
    func addBlockBlocks(blocksReal: Array<Array<Int>>, numBlocks: Int) -> Array<Array<Int>> {
        var newBlocksReal = blocksReal
        var trialPosition = Array<Int>()
        
        // Place N blocks randomly
        var blocksPlaced = 0
        while(blocksPlaced < numBlocks) {
            trialPosition = [Int(arc4random_uniform(UInt32(numBlocksX))),
                             Int(arc4random_uniform(UInt32(numBlocksY)))]
            
            if newBlocksReal[trialPosition[1]][trialPosition[0]] == 0 {
                newBlocksReal[trialPosition[1]][trialPosition[0]] = 1
                blocksPlaced += 1
            }
        }
        
        return newBlocksReal
    }
    
    func addNumberBlocks(blocksReal: Array<Array<Int>>, numNumbers: Int) -> Array<Array<Int>> {
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
    
    func addArrowBlocks(blocksReal: Array<Array<Int>>, numArrows: Int) -> Array<Array<Int>> {
        var newBlocksReal = blocksReal
        var trialPosition = Array<Int>()
        
        // Place N arrows randomly
        var blocksPlaced = 0
        while(blocksPlaced < numArrows) {
            trialPosition = [Int(arc4random_uniform(UInt32(numBlocksX))),
                             Int(arc4random_uniform(UInt32(numBlocksY)))]
            
            if newBlocksReal[trialPosition[1]][trialPosition[0]] == 0 {
                // Number: 0 -> Code: up
                // Number: 1 -> Code: down
                // Number: 2 -> Code: left
                // Number: 3 -> Code: right
                let maxNumber = 3
                let numberValue = Int(arc4random_uniform(UInt32(maxNumber+1)))
                newBlocksReal[trialPosition[1]][trialPosition[0]] = 20+numberValue
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
        
        return UserDefaults.standard.integer(forKey: numbersSelectorKey)
        
//        let maxNumNumberBlocks = 4
//        let levelNumBlocks = Int(arc4random_uniform(UInt32(maxNumNumberBlocks))+1)
//        
//        return levelNumBlocks
    }
    
    func generateNumArrowBlocks(difficulty: DifficultyCriteria) -> Int {
        
        return UserDefaults.standard.integer(forKey: arrowsSelectorKey)
    }
    
}
