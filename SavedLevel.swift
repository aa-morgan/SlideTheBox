//
//  SavedLevel.swift
//  Slide the Box
//
//  Created by Alex Morgan on 04/01/2017.
//  Copyright © 2017 Alex Morgan. All rights reserved.
//

import Foundation

struct SavedLevel: JSONSerialisable {
    let numBlocksX: Int
    let numBlocksY: Int
    
    let numBlockBlocks: Int
    let numNumberBlocks: Int
    let numArrowBlocks: Int
    
    let startPosition: Array<Int>
    let endPosition: Array<Int>
    let enemyPositions: Array<Array<Int>>
    
    let blocksReal: Array<Array<Int>>
}
