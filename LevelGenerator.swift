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
    var difficulty = DifficultyCriteria()
    
    var numBlocksX = Int()
    var numBlocksY = Int()
    
    init() {
    }
    
    init(levelType: String, numBlocksX: Int, numBlocksY: Int, difficulty: DifficultyCriteria) {
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
        var levelMinMoves = Int()
        var levelsProposed = 0
        
        repeat {

            level = levelProposer.propose()
            level = levelSolver.solve(level: level)
            
            levelSolvable = level.isSolvable()
            levelStuckable = level.isStuckable()
            levelMinMoves = level.getMinMoves()
            
            levelsProposed += 1
        } while !(  levelSolvable == true &&
                    levelStuckable == false &&
                    levelMinMoves >= difficulty.getMinMoves())
        
        print("Levels proposed: ", levelsProposed)
        print("Min Moves: ", level.getMinMoves())

        return level
    }

}
