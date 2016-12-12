//
//  GameplayScene.swift
//  Slide the Box
//
//  Created by Alex Morgan on 06/12/2016.
//  Copyright © 2016 Alex Morgan. All rights reserved.
//

import SpriteKit

class GameplayScene: SKScene {
    
    var backBtn = SKSpriteNode()
    var playerBox = SKSpriteNode()
    
    let levelType = "Basic"
    var level = BasicLevel()
    var levelGenerator = LevelGenerator()
    
    var numBlocksX = Int()
    var numBlocksY = Int()
    var blockWidth = CGFloat();
    var blockHeight = CGFloat();
    var menuBarHeight = CGFloat(100)
    
    var currentPosition = Array<Int>()
    
    var isMoving = false
    var canMove = true
    
    override func didMove(to view: SKView) {
        initialise()
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            if atPoint(location) == backBtn {
                let mainMenu = MainMenuScene(fileNamed: "MainMenuScene")
                mainMenu!.scaleMode = .aspectFill
                self.view?.presentScene(mainMenu!, transition: SKTransition.doorway(withDuration: TimeInterval(1.3)))
            }
            
        }
    }
    
    func initialise() {
        setupUsefulConstants()
        setupMenuBar()
        setupLevel()
        setupGestures()
    }
    
    func setupUsefulConstants() {
        
        let playableWidth = self.size.width
        let playableHeight = self.size.height - menuBarHeight
        
        numBlocksX = 12
        numBlocksY = 6
        blockWidth = playableWidth / CGFloat(numBlocksX)
        blockHeight = playableHeight / CGFloat(numBlocksY)
        
    }
    
    func setupMenuBar() {
        backBtn = self.childNode(withName: "Back Button") as! SKSpriteNode
    }
    
    func setupLevel() {
        levelGenerator = LevelGenerator(levelType: levelType, numBlocksX: numBlocksX, numBlocksY: numBlocksY)
        level = levelGenerator.generate()
        currentPosition = level.getStartPosition()
        
        var rowIndex = 0
        var columnIndex = 0
        for row in level.getBlocksReal() {
            for blockType in row {
                if blockType == 1 { // Add block box
                    let blockBoxSprite = SKSpriteNode(imageNamed: "Block Box")
                    blockBoxSprite.anchorPoint = CGPoint(x: 0, y: 1)
                    blockBoxSprite.size = CGSize(width: blockWidth, height: blockHeight)
                    blockBoxSprite.name = "Block Box"
                    blockBoxSprite.position = CGPoint(x: CGFloat(columnIndex) * blockWidth, y: -(CGFloat(rowIndex) * blockHeight))
                    blockBoxSprite.zPosition = 5
                    self.addChild(blockBoxSprite)
                    
                    //print("Size: ", blockBoxSprite.size)
                    //print("Position: ", blockBoxSprite.position)
                    
                } else if blockType == 8 { // Setup player box
                    setupPlayerBox(rowIndex: rowIndex, columnIndex: columnIndex)
                }
                columnIndex += 1
            }
            columnIndex = 0
            rowIndex += 1
        }
    
        
    }
    
    func setupPlayerBox(rowIndex: Int, columnIndex: Int) {
        playerBox = SKSpriteNode(imageNamed: "Player Box")
        playerBox.anchorPoint = CGPoint(x: 0, y: 1)
        playerBox.size = CGSize(width: blockWidth, height: blockHeight)
        playerBox.name = "Player Box"
        playerBox.position = CGPoint(x: CGFloat(columnIndex) * blockWidth, y: -(CGFloat(rowIndex) * blockHeight))
        playerBox.zPosition = 5
        
        self.addChild(playerBox)
    }
    
    func setupGestures() {
        let swipeRight : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameplayScene.handleSwipe))
        let swipeLeft : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameplayScene.handleSwipe))
        let swipeUp : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameplayScene.handleSwipe))
        let swipeDown : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameplayScene.handleSwipe))
        
        swipeRight.direction = .right
        swipeLeft.direction = .left
        swipeUp.direction = .up
        swipeDown.direction = .down
        
        self.view?.addGestureRecognizer(swipeRight)
        self.view?.addGestureRecognizer(swipeLeft)
        self.view?.addGestureRecognizer(swipeUp)
        self.view?.addGestureRecognizer(swipeDown)
    }
    
    func handleSwipe(sender: UISwipeGestureRecognizer) {
        
        var numBlocks = Int()
        var direction = String()
        
        if (!isMoving && canMove) {
            if (sender.direction.rawValue == 1){
                direction = "right"
                numBlocks = level.calculateMove(position: currentPosition, direction: direction)
            } else if (sender.direction.rawValue == 2){
                direction = "left"
                numBlocks = -level.calculateMove(position: currentPosition, direction: direction)
            } else if (sender.direction.rawValue == 4){
                direction = "up"
                numBlocks = level.calculateMove(position: currentPosition, direction: direction)
            } else if (sender.direction.rawValue == 8){
                direction = "down"
                numBlocks = -level.calculateMove(position: currentPosition, direction: direction)
            }

            moveBox(direction: direction, numBlocks: numBlocks)
            updateCurrentPosition(direction: direction, numMoves: numBlocks)
        }
        
    }
    
    func moveBox(direction: String, numBlocks: Int) {
        
        let perBlockTime = CGFloat(0.2)
        var moveAnimation = SKAction();
        
        isMoving = true
        
        if direction == "left" || direction == "right" {
            moveAnimation = SKAction.move(by: CGVector(dx: CGFloat(numBlocks) * blockHeight, dy: 0), duration: TimeInterval(perBlockTime * abs(CGFloat(numBlocks))))
        } else if direction == "up" || direction == "down" {
            moveAnimation = SKAction.move(by: CGVector(dx: 0, dy: CGFloat(numBlocks) * blockWidth), duration: TimeInterval(perBlockTime * abs(CGFloat(numBlocks))))
        }
        
        playerBox.run(moveAnimation, completion: moveComplete)
    }
    
    func updateCurrentPosition(direction: String, numMoves: Int) {
        
        if direction == "left" || direction == "right" {
            currentPosition[0] += numMoves
        } else if direction == "up" || direction == "down" {
            currentPosition[1] -= numMoves
        }
        
    }
    
    func moveComplete() -> Void {
        isMoving = false
    }
}
