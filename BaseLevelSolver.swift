//
//  BaseLevelSolver.swift
//  Slide the Box
//
//  Created by Alex Morgan on 30/12/2016.
//  Copyright © 2016 Alex Morgan. All rights reserved.
//

import SpriteKit

protocol BaseLevelSolver {
    
    func solve(level: BaseLevel)
    func solveForNextMove(level: BaseLevel, customStart: Array<Int>) -> String
    func routeToEnd(level: BaseLevel, customStart: Array<Int>) -> (routePositions: Array<Array<Int>>, routeDirections: Array<String>)
}
