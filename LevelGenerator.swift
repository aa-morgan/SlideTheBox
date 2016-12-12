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
    
    var numBlocksX = Int()
    var numBlocksY = Int()
    
    init() {
    }
    
    init(levelType: String, numBlocksX: Int, numBlocksY: Int) {
        self.numBlocksX = numBlocksX
        self.numBlocksY = numBlocksY
        
        if levelType == "Basic" {
            
            levelProposer = BasicLevelProposer(numBlocksX: numBlocksX, numBlocksY: numBlocksY)
            
        } else if levelType == "Arrow" {
            // To Do
        }
        
    }
    
    func generate() -> BasicLevel {
            
        level = levelProposer.propose()
        level = levelSolver.solve(level: level)

        return level
    }

}
