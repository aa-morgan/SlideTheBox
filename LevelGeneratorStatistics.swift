//
//  LevelGeneratorStatistics.swift
//  Slide the Box
//
//  Created by Alex Morgan on 17/12/2016.
//  Copyright © 2016 Alex Morgan. All rights reserved.
//

import Foundation

class LevelGeneratorStatistics {
    
    var levelsProposed = Int()
    var levelsUnsolvable = Int()
    var levelsStuckable = Int()
    var levelsTooDifficult = Int()
    
    init() {
        reset()
    }
    
    func reset() {
        levelsProposed = 0
        levelsUnsolvable = 0
        levelsStuckable = 0
    }
    
    func getLevelsProposed() -> Int {
        return self.levelsProposed
    }
    
    func incrementLevelsPropsed() {
        self.levelsProposed += 1
    }
    
    func getLevelsUnsolvable() -> Int {
        return self.levelsUnsolvable
    }
    
    func incrementLevelsUnsolvable() {
        self.levelsUnsolvable += 1
    }
    
    func getLevelsStuckable() -> Int {
        return self.levelsStuckable
    }
    
    func incrementLevelsStuckable() {
        self.levelsStuckable += 1
    }
    
    func getLevelsTooDifficult() -> Int {
        return self.levelsTooDifficult
    }
    
    func incrementLevelsTooDifficult() {
        self.levelsTooDifficult += 1
    }
}
