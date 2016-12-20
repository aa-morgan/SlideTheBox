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
    var scoreBtn = SKSpriteNode()
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
                let gameplay = GameplayScene(fileNamed: "GameplayScene")
                gameplay!.scaleMode = .aspectFill
                //self.view?.presentScene(gameplay!, transition: SKTransition.doorway(withDuration: TimeInterval(1.5)))
                self.view?.presentScene(gameplay!)
            }
            
            if atPoint(location) == scoreBtn {
                showScore()
            }
            
        }
        
    }
    
    func initialise() {
        getButtons()
        getLabel()
    }
    
    func getButtons() {
        playBtn = self.childNode(withName: "Play Button") as! SKSpriteNode
        scoreBtn = self.childNode(withName: "Score Button") as! SKSpriteNode
    }
    
    func getLabel() {
        title = self.childNode(withName: "Title Label") as! SKLabelNode
        
        title.fontName = "RosewoodStd-Regular"
        title.fontSize = 120
        title.text = "Slide the Box"
        
        title.zPosition = 5
        
        let moveUp = SKAction.moveTo(y: title.position.y + 30, duration: TimeInterval(1.3))
        let moveDown = SKAction.moveTo(y: title.position.y - 30, duration: TimeInterval(1.3))
        
        let sequence = SKAction.sequence([moveUp, moveDown])
        
        title.run(SKAction.repeatForever(sequence))
    }
    
    func showScore() {
        score.removeFromParent()
        
        score = SKLabelNode(fontNamed: "RosewoodStd-Regular")
        score.fontSize = 120
        score.text = "\(UserDefaults.standard.integer(forKey: "Highscore"))"
        score.position = CGPoint(x: 0, y: -300)
        score.zPosition = 6
        
        self.addChild(score)
    }
    
}
