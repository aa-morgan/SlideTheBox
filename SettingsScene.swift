//
//  SettingsScene.swift
//  Slide the Box
//
//  Created by Alex Morgan on 03/01/2017.
//  Copyright © 2017 Alex Morgan. All rights reserved.
//

import SpriteKit

class SettingsScene : SKScene {
    
    var homeBtn = SKSpriteNode()
    
    var numbersToggle = SKSpriteNode()
    var arrowsToggle = SKSpriteNode()
    var enemiesToggle = SKSpriteNode()
    let numbersToggleKey = "Use Numbers"
    let arrowsToggleKey = "Use Arrows"
    let enemiesToggleKey = "Use Enemies"
    
    var numbersDecrease = SKSpriteNode()
    var numbersIncrease = SKSpriteNode()
    var numbersValue = SKLabelNode()
    var arrowsDecrease = SKSpriteNode()
    var arrowsIncrease = SKSpriteNode()
    var arrowsValue = SKLabelNode()
    var enemiesDecrease = SKSpriteNode()
    var enemiesIncrease = SKSpriteNode()
    var enemiesValue = SKLabelNode()
    let numbersSelectorKey = "Number of Numbers"
    let arrowsSelectorKey = "Number of Arrows"
    let enemiesSelectorKey = "Number of Enemies"
    let selectorMax = 9
    
    
    override func didMove(to view: SKView) {
        initialise()
    }
    
    func initialise() {
        getButtons()
        setupToggles()
        setupSelectors()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            if atPoint(location) == homeBtn {
                let mainMenuScene = MainMenuScene(fileNamed: "MainMenuScene")
                mainMenuScene!.scaleMode = .aspectFill
                self.view?.presentScene(mainMenuScene!)
            }
            
            if atPoint(location) == numbersToggle {
                UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: numbersToggleKey), forKey: numbersToggleKey)
                
                if UserDefaults.standard.bool(forKey: numbersToggleKey) == true {
                    numbersToggle.texture = SKTexture(imageNamed: "Select On")
                    
                } else {
                    numbersToggle.texture = SKTexture(imageNamed: "Select Off")
                    
                }
            }
            
            if atPoint(location) == arrowsToggle {
                UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: arrowsToggleKey), forKey: arrowsToggleKey)
                
                if UserDefaults.standard.bool(forKey: arrowsToggleKey) == true {
                    arrowsToggle.texture = SKTexture(imageNamed: "Select On")
                    
                } else {
                    arrowsToggle.texture = SKTexture(imageNamed: "Select Off")
                    
                }
            }
            
            if atPoint(location) == enemiesToggle {
                UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: enemiesToggleKey), forKey: enemiesToggleKey)
                
                if UserDefaults.standard.bool(forKey: enemiesToggleKey) == true {
                    enemiesToggle.texture = SKTexture(imageNamed: "Select On")
                    
                } else {
                    enemiesToggle.texture = SKTexture(imageNamed: "Select Off")
                    
                }
            }
            
            if atPoint(location) == numbersDecrease {
                let oldValue = UserDefaults.standard.integer(forKey: numbersSelectorKey)
                if (oldValue > 0) {
                    let newValue = oldValue-1
                    UserDefaults.standard.set(newValue, forKey: numbersSelectorKey)
                    numbersValue.text = String(newValue)
                }
            }
            
            if atPoint(location) == numbersIncrease {
                let oldValue = UserDefaults.standard.integer(forKey: numbersSelectorKey)
                if (oldValue < selectorMax) {
                    let newValue = oldValue+1
                    UserDefaults.standard.set(newValue, forKey: numbersSelectorKey)
                    numbersValue.text = String(newValue)
                }
            }
            
            if atPoint(location) == arrowsDecrease {
                let oldValue = UserDefaults.standard.integer(forKey: arrowsSelectorKey)
                if (oldValue > 0) {
                    let newValue = oldValue-1
                    UserDefaults.standard.set(newValue, forKey: arrowsSelectorKey)
                    arrowsValue.text = String(newValue)
                }
            }
            
            if atPoint(location) == arrowsIncrease {
                let oldValue = UserDefaults.standard.integer(forKey: arrowsSelectorKey)
                if (oldValue < selectorMax) {
                    let newValue = oldValue+1
                    UserDefaults.standard.set(newValue, forKey: arrowsSelectorKey)
                    arrowsValue.text = String(newValue)
                }
            }
            
            if atPoint(location) == enemiesDecrease {
                let oldValue = UserDefaults.standard.integer(forKey: enemiesSelectorKey)
                if (oldValue > 0) {
                    let newValue = oldValue-1
                    UserDefaults.standard.set(newValue, forKey: enemiesSelectorKey)
                    enemiesValue.text = String(newValue)
                }
            }
            
            if atPoint(location) == enemiesIncrease {
                let oldValue = UserDefaults.standard.integer(forKey: enemiesSelectorKey)
                if (oldValue < selectorMax) {
                    let newValue = oldValue+1
                    UserDefaults.standard.set(newValue, forKey: enemiesSelectorKey)
                    enemiesValue.text = String(newValue)
                }
            }
            
        }
    }
    
    func getButtons() {
        homeBtn = self.childNode(withName: "Home Button") as! SKSpriteNode

    }
    
    func setupSelectors() {
        numbersDecrease = self.childNode(withName: "Numbers Decrease") as! SKSpriteNode
        numbersIncrease = self.childNode(withName: "Numbers Increase") as! SKSpriteNode
        numbersValue = self.childNode(withName: "Numbers Value") as! SKLabelNode
        numbersValue.text = String(UserDefaults.standard.integer(forKey: numbersSelectorKey))
        
        arrowsDecrease = self.childNode(withName: "Arrows Decrease") as! SKSpriteNode
        arrowsIncrease = self.childNode(withName: "Arrows Increase") as! SKSpriteNode
        arrowsValue = self.childNode(withName: "Arrows Value") as! SKLabelNode
        arrowsValue.text = String(UserDefaults.standard.integer(forKey: arrowsSelectorKey))
        
        enemiesDecrease = self.childNode(withName: "Enemies Decrease") as! SKSpriteNode
        enemiesIncrease = self.childNode(withName: "Enemies Increase") as! SKSpriteNode
        enemiesValue = self.childNode(withName: "Enemies Value") as! SKLabelNode
        enemiesValue.text = String(UserDefaults.standard.integer(forKey: enemiesSelectorKey))

    }
    
    func setupToggles() {
        numbersToggle = self.childNode(withName: "Numbers Toggle") as! SKSpriteNode
        arrowsToggle = self.childNode(withName: "Arrows Toggle") as! SKSpriteNode
        enemiesToggle = self.childNode(withName: "Enemies Toggle") as! SKSpriteNode
        
        if UserDefaults.standard.bool(forKey: numbersToggleKey) == true {
            numbersToggle.texture = SKTexture(imageNamed: "Select On")
            
        } else {
            numbersToggle.texture = SKTexture(imageNamed: "Select Off")
            
        }
        
        if UserDefaults.standard.bool(forKey: arrowsToggleKey) == true {
            arrowsToggle.texture = SKTexture(imageNamed: "Select On")
            
        } else {
            arrowsToggle.texture = SKTexture(imageNamed: "Select Off")
            
        }
        
        if UserDefaults.standard.bool(forKey: enemiesToggleKey) == true {
            enemiesToggle.texture = SKTexture(imageNamed: "Select On")
            
        } else {
            enemiesToggle.texture = SKTexture(imageNamed: "Select Off")
            
        }
    }

}
