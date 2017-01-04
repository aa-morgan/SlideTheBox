//
//  SavedLevelsScene.swift
//  Slide the Box
//
//  Created by Alex Morgan on 04/01/2017.
//  Copyright © 2017 Alex Morgan. All rights reserved.
//

import SpriteKit

class SavedLevelsScene: SKScene {
    
    var homeBtn = SKSpriteNode()
    var resetBtn = SKSpriteNode()
    var printBtn = SKSpriteNode()
    
    let savedLevelsKey = "Saved Levels"
    
    var levelsSaved = SKLabelNode()
    
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
                UserDefaults.standard.removeObject(forKey: savedLevelsKey)
                levelsSaved.text = String(0)
            }
            
            if atPoint(location) == printBtn {
                if UserDefaults.standard.array(forKey: savedLevelsKey) != nil {
                    let savedLevels = UserDefaults.standard.array(forKey: savedLevelsKey) as! Array<Array<Array<Int>>>
                    
                    for savedLevel in savedLevels {
                        print(savedLevel)
                    }
                }
            }
            
        }
    }
    
    func getButtons() {
        homeBtn = self.childNode(withName: "Home Button") as! SKSpriteNode
        resetBtn = self.childNode(withName: "Reset Button") as! SKSpriteNode
        printBtn = self.childNode(withName: "Print Button") as! SKSpriteNode
    }
    
    func setupLabels() {
        
        levelsSaved = self.childNode(withName: "Levels Saved") as! SKLabelNode
        var count: Int
        
        if UserDefaults.standard.array(forKey: savedLevelsKey) == nil {
            count = 0
        } else {
            count = (UserDefaults.standard.array(forKey: savedLevelsKey) as! Array<Array<Array<Int>>>).count
        }
        
        levelsSaved.text = String(count)
        
    }
    
}
