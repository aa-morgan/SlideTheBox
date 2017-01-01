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
    
    var numbersSelector = SKSpriteNode()
    var arrowsSelector = SKSpriteNode()
    var enemiesSelector = SKSpriteNode()
    let numbersKey = "Use Numbers"
    let arrowsKey = "Use Arrows"
    let enemiesKey = "Use Enemies"
    
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
            
            if atPoint(location) == numbersSelector {
                UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: numbersKey), forKey: numbersKey)
                
                if UserDefaults.standard.bool(forKey: numbersKey) == true {
                    numbersSelector.texture = SKTexture(imageNamed: "Select On")

                } else {
                    numbersSelector.texture = SKTexture(imageNamed: "Select Off")

                }
            }
            
            if atPoint(location) == arrowsSelector {
                UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: arrowsKey), forKey: arrowsKey)
                
                if UserDefaults.standard.bool(forKey: arrowsKey) == true {
                    arrowsSelector.texture = SKTexture(imageNamed: "Select On")
                    
                } else {
                    arrowsSelector.texture = SKTexture(imageNamed: "Select Off")
                    
                }
            }
            
            if atPoint(location) == enemiesSelector {
                UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: enemiesKey), forKey: enemiesKey)
                
                if UserDefaults.standard.bool(forKey: enemiesKey) == true {
                    enemiesSelector.texture = SKTexture(imageNamed: "Select On")
                    
                } else {
                    enemiesSelector.texture = SKTexture(imageNamed: "Select Off")
                    
                }
            }
            
        }
        
    }
    
    func initialise() {
        getButtons()
        getLabel()
        setupSelectors()
    }
    
    func getButtons() {
        playBtn = self.childNode(withName: "Play Button") as! SKSpriteNode
        scoreBtn = self.childNode(withName: "Score Button") as! SKSpriteNode
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
    
    func setupSelectors() {
        numbersSelector = self.childNode(withName: "Numbers Selector") as! SKSpriteNode
        arrowsSelector = self.childNode(withName: "Arrows Selector") as! SKSpriteNode
        enemiesSelector = self.childNode(withName: "Enemies Selector") as! SKSpriteNode
        
        if UserDefaults.standard.bool(forKey: numbersKey) == true {
            numbersSelector.texture = SKTexture(imageNamed: "Select On")
            
        } else {
            numbersSelector.texture = SKTexture(imageNamed: "Select Off")
            
        }
        
        if UserDefaults.standard.bool(forKey: arrowsKey) == true {
            arrowsSelector.texture = SKTexture(imageNamed: "Select On")
            
        } else {
            arrowsSelector.texture = SKTexture(imageNamed: "Select Off")
            
        }
        
        if UserDefaults.standard.bool(forKey: enemiesKey) == true {
            enemiesSelector.texture = SKTexture(imageNamed: "Select On")
            
        } else {
            enemiesSelector.texture = SKTexture(imageNamed: "Select Off")
            
        }
    }
    
    func showScore() {
        score.removeFromParent()
        
        score = SKLabelNode(fontNamed: "Helvetica")
        score.fontSize = 120
        score.fontColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
        score.text = "\(UserDefaults.standard.integer(forKey: "Highscore"))"
        score.position = CGPoint(x: 0, y: -300)
        score.zPosition = 6
        
        self.addChild(score)
    }
    
}
