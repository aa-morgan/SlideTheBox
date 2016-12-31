//
//  LevelGenerator.swift
//  Slide the Box
//
//  Created by Alex Morgan on 11/12/2016.
//  Copyright © 2016 Alex Morgan. All rights reserved.
//

import SpriteKit

class LevelGenerator {
    
    var level: BaseLevel
    var levelProposer: BaseLevelProposer
    var levelSolver: BaseLevelSolver
    var difficulty: BaseDifficultyCriteria
    var genStats: LevelGeneratorStatistics
    
    var numBlocksX = Int()
    var numBlocksY = Int()
    
    let testingStage = "all"
    
    // Temp init before the class is properly init
    init(){
        self.level = BasicLevel()
        self.levelProposer = BasicLevelProposer()
        self.levelSolver = BasicLevelSolver()
        self.difficulty = BasicDifficultyCriteria()
        self.genStats = LevelGeneratorStatistics()
    }
    
    init(levelType: String, numBlocksX: Int, numBlocksY: Int) {
        self.numBlocksX = numBlocksX
        self.numBlocksY = numBlocksY
        
        if levelType == "Basic" {
            self.level = BasicLevel()
            self.levelProposer = BasicLevelProposer(numBlocksX: numBlocksX, numBlocksY: numBlocksY)
            self.levelSolver = BasicLevelSolver()
            self.difficulty = BasicDifficultyCriteria(difficulty: "easy")
            
        } else if levelType == "Number" {
            // To Do
            self.level = NumberLevel()
            self.levelProposer = NumberLevelProposer(numBlocksX: numBlocksX, numBlocksY: numBlocksY)
            self.levelSolver = NumberLevelSolver()
            self.difficulty = NumberDifficultyCriteria(difficulty: "easy")
            
        } else { // Default
            self.level = BasicLevel()
            self.levelProposer = BasicLevelProposer(numBlocksX: numBlocksX, numBlocksY: numBlocksY)
            self.levelSolver = BasicLevelSolver()
            self.difficulty = BasicDifficultyCriteria(difficulty: "easy")
            
        }
        
        self.genStats = LevelGeneratorStatistics()
    }
    
    func generate() -> BaseLevel {
        
        var levelSolvable = Bool()
        var levelStuckable = Bool()
        
        if testingStage == "all" {
            repeat {
                
                level = levelProposer.propose(difficulty: difficulty)
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
            print("Level difficulty properties,")
            print("\t minMoves: ", difficulty.getMinMoves(level: level))
            print("\t percentOfBlockBlocks: ", difficulty.getPercentOfBlockBlocks(level: level))
            print("\t maxExplorationStage: ", difficulty.getMaxExplorationStage(level: level))
            print("\t numberOfExplorablePositions: ", difficulty.getNumberOfExplorablePositions(level: level))
            print("\t averageMoveDistance: ", difficulty.getAverageMoveDistance(level: level))
            print("\t percentOfRouteOnBoundary: ", difficulty.getPercentOfRouteOnBoundary(level: level))
            print("\t endBlockOnBoundary: ", difficulty.isEndBlockOnBoundary(level: level))
        } else if testingStage == "propose" {
            level = levelProposer.propose(difficulty: difficulty)
        } else {
            level = BasicLevel()
        }

        return level
    }
    
    func randomGaussian(mean: Float, stddev: Float) -> Int {
        
        let precision = 10000
        let seed1 = Float(arc4random_uniform(UInt32(precision))) / Float(precision)
        let seed2 = Float(arc4random_uniform(UInt32(precision))) / Float(precision)
        let blockCount = ( pow( -2.0 * log( seed1 ), 0.5 ) * cos( 2 * Float(M_PI) * seed2 ) * stddev ) + mean;
        return Int(floor(blockCount))
    }
    
    func getSolver() -> BaseLevelSolver {
        return self.levelSolver
    }

}
