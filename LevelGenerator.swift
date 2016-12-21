//
//  LevelGenerator.swift
//  Slide the Box
//
//  Created by Alex Morgan on 11/12/2016.
//  Copyright © 2016 Alex Morgan. All rights reserved.
//

import SpriteKit

class LevelGenerator {
    
    var level = BasicLevel()
    var levelProposer = BasicLevelProposer()
    var levelSolver = BasicLevelSolver()
    var difficulty = BasicDifficultyCriteria()
    var genStats = LevelGeneratorStatistics()
    
    var numBlocksX = Int()
    var numBlocksY = Int()
    
    init() {
    }
    
    init(levelType: String, numBlocksX: Int, numBlocksY: Int, difficulty: BasicDifficultyCriteria) {
        self.numBlocksX = numBlocksX
        self.numBlocksY = numBlocksY
        
        self.difficulty = difficulty
        
        if levelType == "Basic" {
            
            levelProposer = BasicLevelProposer(numBlocksX: numBlocksX, numBlocksY: numBlocksY)
            
        } else if levelType == "Arrow" {
            // To Do
        }
        
    }
    
    func generate() -> BasicLevel {
        
        var levelSolvable = Bool()
        var levelStuckable = Bool()
        
        repeat {
    
            //let maxBlocks = UInt32(floor(Float(numBlocksX*numBlocksY) * difficulty.getBlockSpaceRatio()))
            //let levelNumBlocks = Int(arc4random_uniform(maxBlocks+1))

            let levelNumBlocks = (numBlocksX*numBlocksY)/8

            //levelNumBlocks = randomGaussian(mean: Double(numBlocksX*numBlocksY)/3,
            //                                spread: Double(numBlocksX*numBlocksY)/4)
            
            level = levelProposer.propose(numBlocks: levelNumBlocks)
            levelSolver.solve(level: level)
            
            levelSolvable = level.isSolvable()
            levelStuckable = level.isStuckable()
            
            genStats.incrementLevelsPropsed()
            if !(levelSolvable) {
                genStats.incrementLevelsUnsolvable()
            } else if (levelStuckable) {
                genStats.incrementLevelsStuckable()
            } else if (difficulty.met(level: level) == false) {
                genStats.incrementLevelsTooDifficult()
            }
        } while !(  levelSolvable == true &&
                    levelStuckable == false &&
                    difficulty.met(level: level) == true)
        
        print("Levels proposed: ", genStats.getLevelsProposed())
        print("Levels unsolvable: ", genStats.getLevelsUnsolvable())
        print("Levels stuckable: ", genStats.getLevelsStuckable())
        print("Levels too difficult: ", genStats.getLevelsTooDifficult())
        print("Level difficult properties,")
        print("\t minMoves: ", difficulty.getMinMoves(level: level))
        print("\t percentOfBlockBlocks: ", difficulty.getPercentOfBlockBlocks(level: level))
        print("\t maxExplorationStage: ", difficulty.getMaxExplorationStage(level: level))
        print("\t numberOfExplorablePositions: ", difficulty.getNumberOfExplorablePositions(level: level))
        print("\t averageMoveDistance: ", difficulty.getAverageMoveDistance(level: level))
        print("\t percentOfRouteOnBoundary: ", difficulty.getPercentOfRouteOnBoundary(level: level))
        print("\t endBlockOnBoundary: ", difficulty.isEndBlockOnBoundary(level: level))
        
        //print(level.getBlocksExploration())

        return level
    }
    
    func randomGaussian(mean: Double, spread: Double) -> Int {
        
        let u1 = Double(arc4random_uniform(UInt32(1000))) / 1000 // uniform distribution
        let u2 = Double(arc4random_uniform(UInt32(1000))) / 1000 // uniform distribution
        let f1 = sqrt(-2 * log(u1));
        let f2 = 2 * 3.14159 * u2;
        let g1 = f1 * cos(f2); // gaussian distribution
        let g2 = f1 * sin(f2); // gaussian distribution
        
        return Int((g1 * Double(spread)) + (Double(mean) - 0.5))
    }

}
