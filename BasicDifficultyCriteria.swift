//
//  DifficultyCriteria.swift
//  Slide the Box
//
//  Created by Alex Morgan on 13/12/2016.
//  Copyright © 2016 Alex Morgan. All rights reserved.
//

import Foundation

class BasicDifficultyCriteria {
    
    private var minMoves = Int()
    private var blockSpaceRatio = Float()
    
    init() {
    }
    
    init(difficulty: String) {
        
        if difficulty == "easy" {
            self.minMoves = Int(5)
            self.blockSpaceRatio = Float(0.5)
        } else if difficulty == "medium" {
            
        } else if difficulty == "hard" {
            
        }
        
    }
    
    func met(level: BasicLevel) -> Bool {
        
        if (level.getMinMoves() > self.minMoves &&
            level.getBlockSpaceRatio() < self.blockSpaceRatio) {
            return true
        } else {
            return false
        }
        
    }
    
    func getBlockSpaceRatio() -> Float {
        return self.blockSpaceRatio
    }
}
