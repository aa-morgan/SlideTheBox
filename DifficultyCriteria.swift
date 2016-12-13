//
//  DifficultyCriteria.swift
//  Slide the Box
//
//  Created by Alex Morgan on 13/12/2016.
//  Copyright © 2016 Alex Morgan. All rights reserved.
//

import Foundation

class DifficultyCriteria {
    
    private var minMoves = Int()
    
    init() {
    }
    
    init(minMoves: Int) {
        self.minMoves = minMoves
    }
    
    func getMinMoves() -> Int {
        return self.minMoves
    }
}
