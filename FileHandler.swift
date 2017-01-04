//
//  FileHandler.swift
//  Slide the Box
//
//  Created by Alex Morgan on 04/01/2017.
//  Copyright © 2017 Alex Morgan. All rights reserved.
//

import Foundation

class FileHandler {
    
    init() {
        
    }
    
    func toFile(level: Level, filename: String) {
        
        let savedLevel = SavedLevel(numBlocksX: level.numBlocksX, numBlocksY: level.numBlocksY, numBlockBlocks: level.getNumBlockBlocks(), numNumberBlocks: level.getNumNumberBlocks(), numArrowBlocks: level.getNumArrowBlocks(), startPosition: level.getStartPosition(), endPosition: level.getEndPosition(), enemyPositions: level.getEnemyPositions(), blocksReal: level.getBlocksReal())
        
        let jsonString = savedLevel.toJSON()
        
        // Write string to file
        
    }
    
    func fromFile(filename: String) -> Level {
        
        // Read string from file
        let jsonString = String?("")
        
        var level = Level()
        
        var data = jsonString?.data(using: .utf8)!
        if let parsedData = try? JSONSerialization.jsonObject(with: data!) as! [String:Any] {
            let numBlocksX = parsedData["numBlocksX"] as! Int
            let numBlocksY = parsedData["numBlocksY"] as! Int
            
            let numBlockBlocks = parsedData["numBlockBlocks"] as! Int
            let numNumberBlocks = parsedData["numNumberBlocks"] as! Int
            let numArrowBlocks = parsedData["numArrowBlocks"] as! Int
            
            let startPosition = parsedData["startPosition"] as! Array<Int>
            let endPosition = parsedData["endPosition"] as! Array<Int>
            let enemyPositions = parsedData["enemyPositions"] as! Array<Array<Int>>
            
            let blocksReal = parsedData["blocksReal"] as! Array<Array<Int>>
            
            let level = Level(numBlocksX: numBlocksX, numBlocksY: numBlocksY)
            level.numBlockBlocks = numBlockBlocks
            level.numNumberBlocks = numNumberBlocks
            level.numBlockBlocks = numBlockBlocks
            level.numNumberBlocks = numNumberBlocks
            level.numArrowBlocks = numArrowBlocks
            level.startPosition = startPosition
            level.endPosition = endPosition
            level.enemyPositions = enemyPositions
            level.blocksReal = blocksReal
        }
        
        return level
    }
}
