//
//  StatsScene.swift
//  Slide the Box
//
//  Created by Alex Morgan on 03/01/2017.
//  Copyright © 2017 Alex Morgan. All rights reserved.
//

import SpriteKit

class StatsScene: SKScene {
    
    var homeBtn = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        initialise()
    }
    
    func initialise() {
        getButtons()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let location = touch.location(in: self)
            
            if atPoint(location) == homeBtn {
                let mainMenuScene = MainMenuScene(fileNamed: "MainMenuScene")
                mainMenuScene!.scaleMode = .aspectFill
                self.view?.presentScene(mainMenuScene!)
            }
            
        }
    }
    
    func getButtons() {
        homeBtn = self.childNode(withName: "Home Button") as! SKSpriteNode
    }
}
