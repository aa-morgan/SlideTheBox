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
    var resetBtn = SKSpriteNode()

    let levelsAttemptedKey = "Level Attempted"
    let levelsCompletedKey = "Level Completed"
    let levelsLostKey = "Level Lost"
    
    var levelsAttempted = SKLabelNode()
    var levelsCompleted = SKLabelNode()
    var levelsLost = SKLabelNode()
    
    override func didMove(to view: SKView) {
        initialise()
    }
    
    func initialise() {
        getButtons()
        setupLabels()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let location = touch.location(in: self)
            
            if atPoint(location) == homeBtn {
                let mainMenuScene = MainMenuScene(fileNamed: "MainMenuScene")
                mainMenuScene!.scaleMode = .aspectFill
                self.view?.presentScene(mainMenuScene!)
            }
            
            if atPoint(location) == resetBtn {
                UserDefaults.standard.set(0, forKey: levelsAttemptedKey)
                levelsAttempted.text = String(0)
                
                UserDefaults.standard.set(0, forKey: levelsCompletedKey)
                levelsCompleted.text = String(0)
                
                UserDefaults.standard.set(0, forKey: levelsLostKey)
                levelsLost.text = String(0)
            }
            
        }
    }
    
    func getButtons() {
        homeBtn = self.childNode(withName: "Home Button") as! SKSpriteNode
        resetBtn = self.childNode(withName: "Reset Button") as! SKSpriteNode
    }
    
    func setupLabels() {
        
        levelsAttempted = self.childNode(withName: "Levels Attempted") as! SKLabelNode
        levelsAttempted.text = String(UserDefaults.standard.integer(forKey: levelsAttemptedKey))
        
        levelsCompleted = self.childNode(withName: "Levels Completed") as! SKLabelNode
        levelsCompleted.text = String(UserDefaults.standard.integer(forKey: levelsCompletedKey))
        
        levelsLost = self.childNode(withName: "Levels Lost") as! SKLabelNode
        levelsLost.text = String(UserDefaults.standard.integer(forKey: levelsLostKey))

        
    }
}
