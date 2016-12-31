//
//  NumberDifficultyCriteria.swift
//  Slide the Box
//
//  Created by Alex Morgan on 23/12/2016.
//  Copyright © 2016 Alex Morgan. All rights reserved.
//

import SpriteKit

class NumberDifficultyCriteria: BasicDifficultyCriteria {
    
    var numNumberBlocksUsed = Int()
    
    
    func getNumNumberBlocksUsed() -> Int {
        return self.numNumberBlocksUsed
    }
    
    func setNumNumberBlocksUsed(number: Int) {
        self.numNumberBlocksUsed = number
    }
    
    func incrementNumNumberBlocksUsed(number: Int) {
        self.numNumberBlocksUsed += 1
    }
}
