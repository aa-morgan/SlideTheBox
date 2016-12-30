//
//  BaseLevelProposer.swift
//  Slide the Box
//
//  Created by Alex Morgan on 30/12/2016.
//  Copyright © 2016 Alex Morgan. All rights reserved.
//

import SpriteKit

protocol BaseLevelProposer {
    
    func propose(difficulty: BaseDifficultyCriteria) -> BaseLevel
}
