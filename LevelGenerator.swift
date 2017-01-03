//
//  LevelGenerator.swift
//  Slide the Box
//
//  Created by Alex Morgan on 11/12/2016.
//  Copyright © 2016 Alex Morgan. All rights reserved.
//

import SpriteKit

class LevelGenerator {
    
    var level: Level
    var levelProposer: LevelProposer
    var levelSolver: LevelSolver
    var difficulty: DifficultyCriteria
    var genStats: LevelGeneratorStatistics
    
    var numBlocksX = Int()
    var numBlocksY = Int()
    
    var useNumbers = Bool()
    var useArrows = Bool()
    
    let testingStage = "all"
    
    // Temp init before the class is properly init
    init(){
        self.level = Level()
        self.levelProposer = LevelProposer()
        self.levelSolver = LevelSolver()
        self.difficulty = DifficultyCriteria()
        self.genStats = LevelGeneratorStatistics()
    }
    
    init(numBlocksX: Int, numBlocksY: Int, useNumbers: Bool, useArrows: Bool) {
        self.numBlocksX = numBlocksX
        self.numBlocksY = numBlocksY
        self.useNumbers = useNumbers
        self.useArrows = useArrows
        
        self.level = Level()
        self.levelProposer = LevelProposer(numBlocksX: numBlocksX, numBlocksY: numBlocksY)
        self.levelSolver = LevelSolver()
        self.difficulty = DifficultyCriteria(difficulty: "easy")
        self.genStats = LevelGeneratorStatistics()
    }
    
    func generate() -> Level {
        
        var levelSolvable: Bool
        var levelStuckable: Bool
        var infiniteArrowLoop: Bool
        
        if testingStage == "all" {
            repeat {
                
                level = levelProposer.propose(difficulty: difficulty, useNumbers: useNumbers, useArrows: useArrows)
                levelSolver.solve(level: level)
                
                levelSolvable = level.getSolution().isSolvable()
                levelStuckable = level.getSolution().isStuckable()
                infiniteArrowLoop = level.getSolution().isInfiniteArrowLoop()
                
                genStats.incrementLevelsPropsed()
                if !(levelSolvable) {
                    genStats.incrementLevelsUnsolvable()
                } else if (levelStuckable) {
                    genStats.incrementLevelsStuckable()
                } else if (infiniteArrowLoop) {
                    genStats.incrementInfiniteArrowLoop()
                } else if (difficulty.met(level: level) == false) {
                    genStats.incrementLevelsTooDifficult()
                }
                
                
            } while !(  levelSolvable == true &&
                        levelStuckable == false &&
                        infiniteArrowLoop == false &&
                        difficulty.met(level: level) == true)
            
            print("Levels proposed: ", genStats.getLevelsProposed())
            print("Levels unsolvable: ", genStats.getLevelsUnsolvable())
            print("Levels stuckable: ", genStats.getLevelsStuckable())
            print("Levels infinity arrow loop: ", genStats.getInfiniteArrowLoop())
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
            level = levelProposer.propose(difficulty: difficulty, useNumbers: useNumbers, useArrows: useArrows)
        } else {
            level = Level()
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
    
    func getSolver() -> LevelSolver {
        return self.levelSolver
    }

}
