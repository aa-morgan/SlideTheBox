//
//  NumberLevel.swift
//  Slide the Box
//
//  Created by Alex Morgan on 23/12/2016.
//  Copyright © 2016 Alex Morgan. All rights reserved.
//

import SpriteKit

class NumberLevel: BasicLevel {
    
    var numNumberBlocks = Int()
    
    
    
    
    func getNumNumberBlocks() -> Int {
        return self.numNumberBlocks
    }
    
    func setNumNumberBlocks(number: Int) {
        self.numNumberBlocks = number
    }
}

