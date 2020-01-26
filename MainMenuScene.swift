//
//  MainMenuScene.swift
//  Slide the Box
//
//  Created by Alex Morgan on 06/12/2016.
//  Copyright © 2016 Alex Morgan. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
    
    var playBtn = SKSpriteNode()
    var settingsBtn = SKSpriteNode()
    var statsBtn = SKSpriteNode()
    var savedLevelsBtn = SKSpriteNode()
    
    var title = SKLabelNode()
    var score = SKLabelNode()
    
    override func didMove(to view: SKView) {
        initialise();
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            if atPoint(location) == playBtn {
                let gameplayScene = GameplayScene(fileNamed: "GameplayScene")
                gameplayScene!.scaleMode = .aspectFit
                //self.view?.presentScene(gameplayScene!, transition: SKTransition.doorway(withDuration: TimeInterval(1.5)))
                self.view?.presentScene(gameplayScene!)
            }
            
            if atPoint(location) == settingsBtn {
                let settingsScene = SettingsScene(fileNamed: "SettingsScene")
                settingsScene!.scaleMode = .aspectFit
                self.view?.presentScene(settingsScene!)
            }
            
            if atPoint(location) == statsBtn {
                let statsScene = StatsScene(fileNamed: "StatsScene")
                statsScene!.scaleMode = .aspectFit
                self.view?.presentScene(statsScene!)
            }
            
            if atPoint(location) == savedLevelsBtn {
                let savedLevelsScene = SavedLevelsScene(fileNamed: "SavedLevelsScene")
                savedLevelsScene!.scaleMode = .aspectFit
                self.view?.presentScene(savedLevelsScene!)
            }
            
        }
        
    }
    
    func initialise() {
        getButtons()
        getLabel()
    }
    
    func getButtons() {
        playBtn = self.childNode(withName: "Play Button") as! SKSpriteNode
        statsBtn = self.childNode(withName: "Stats Button") as! SKSpriteNode
        settingsBtn = self.childNode(withName: "Settings Button") as! SKSpriteNode
        savedLevelsBtn = self.childNode(withName: "Saved Levels Button") as! SKSpriteNode
    }
    
    func getLabel() {
        title = self.childNode(withName: "Title Label") as! SKLabelNode
        
        title.fontName = "Helvetica"
        title.fontSize = 120
        title.fontColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
        title.text = "Slide the Box"
        title.zPosition = 5
        
        let moveUp = SKAction.moveTo(y: title.position.y + 30, duration: TimeInterval(1.3))
        let moveDown = SKAction.moveTo(y: title.position.y - 30, duration: TimeInterval(1.3))
        
        let sequence = SKAction.sequence([moveUp, moveDown])
        
        title.run(SKAction.repeatForever(sequence))
    }
    
}
