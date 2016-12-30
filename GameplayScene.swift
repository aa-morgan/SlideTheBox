//
//  GameplayScene.swift
//  Slide the Box
//
//  Created by Alex Morgan on 06/12/2016.
//  Copyright © 2016 Alex Morgan. All rights reserved.
//

import SpriteKit

class GameplayScene: SKScene {
    
    var pauseBtn = SKSpriteNode()
    var homeBtn = SKSpriteNode()
    var resumeBtn = SKSpriteNode()
    var hintBtn = SKSpriteNode()
    var newLevelBtn = SKSpriteNode()
    var popupPanel = SKSpriteNode()
    
    var playerBlock = SKSpriteNode()
    var endBlock = SKSpriteNode()
    
    let levelType = "Number"
    var basicLevel = BasicLevel()
    var numberLevel = NumberLevel()
    var levelGenerator = LevelGenerator()
    
    var numBlocksX = Int(16)
    var numBlocksY = Int(8)
    var blockWidth = CGFloat()
    var blockHeight = CGFloat()
    let menuBarHeight = CGFloat(100)
    let blockGap = CGFloat(4)
    
    var currentPosition = Array<Int>()
    
    var isMoving = Bool()
    var levelPaused = Bool()
    var levelComplete = Bool()
    
    let perBlockTime = CGFloat(0.1)
    
    override func didMove(to view: SKView) {
        initialise()
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            
            if atPoint(location).name == "Pause" {
                if (!levelPaused && !levelComplete) {
                    createPausePanel()
                }
            }
            
            if atPoint(location).name == "Home" {
                let mainMenu = MainMenuScene(fileNamed: "MainMenuScene")
                mainMenu!.scaleMode = .aspectFill
                self.view?.presentScene(mainMenu!)
            }
            
            if atPoint(location).name == "Resume" {
                popupPanel.removeFromParent()
                self.scene?.isPaused = false
                levelPaused = false
            }
            
            if atPoint(location).name == "Hint" {
                if (!levelPaused && !levelComplete) {
                    hintButtonPressed()
                }
            }
            
            if atPoint(location).name == "New" {
                let gameplay = GameplayScene(fileNamed: "GameplayScene")
                gameplay!.scaleMode = .aspectFill
                self.view?.presentScene(gameplay!)
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
        
        blockWidth = playableWidth / CGFloat(numBlocksX)
        blockHeight = playableHeight / CGFloat(numBlocksY)
        
    }
    
    func setupMenuBar() {
        pauseBtn = self.childNode(withName: "Pause") as! SKSpriteNode
        hintBtn = self.childNode(withName: "Hint") as! SKSpriteNode
    }
    
    func setupLevel() {
        levelGenerator = LevelGenerator(levelType: levelType, numBlocksX: numBlocksX, numBlocksY: numBlocksY)
        let level = levelGenerator.generate()
        currentPosition = level.getStartPosition()
        
        if levelType == "Basic" {
            basicLevel = (level as! BasicLevel)
        } else if levelType == "Number" {
            numberLevel = (level as! NumberLevel)
        }
        
        isMoving = false
        levelPaused = false
        levelComplete = false
        
        var rowIndex = 0
        var columnIndex = 0
        for row in level.getBlocksReal() {
            for blockType in row {
                if blockType == 1 { // Add blocking block
                    addBlockBlock(columnIndex: columnIndex, rowIndex: rowIndex)
                } else if blockType == 8 { // Setup player box
                    setupPlayerBox(columnIndex: columnIndex, rowIndex: rowIndex)
                } else if blockType == 9 { // Setup end block
                    setupEndBlock(columnIndex: columnIndex, rowIndex: rowIndex)
                } else if (blockType >= 10 && blockType <= 18) { // Setup number block
                    addNumberBlock(columnIndex: columnIndex, rowIndex: rowIndex, blockType: blockType)
                }
                
                columnIndex += 1
            }
            columnIndex = 0
            rowIndex += 1
        }
        
    }
    
    func addBlockBlock(columnIndex: Int, rowIndex: Int) {
        let blockBlockSprite = SKSpriteNode(imageNamed: "Block Block")
        blockBlockSprite.size = CGSize(width: blockWidth, height: blockHeight)
        blockBlockSprite.anchorPoint = CGPoint(x: 0, y: 1)
        blockBlockSprite.name = "Block Block"
        blockBlockSprite.position = CGPoint(x: CGFloat(columnIndex) * blockWidth, y: -(CGFloat(rowIndex) * blockHeight))
        blockBlockSprite.zPosition = 5
        self.addChild(blockBlockSprite)
    }
    
    func setupPlayerBox(columnIndex: Int, rowIndex: Int) {
        playerBlock = SKSpriteNode(imageNamed: "Player Block")
        playerBlock.size = CGSize(width: blockWidth, height: blockHeight)
        playerBlock.anchorPoint = CGPoint(x: 0, y: 1)
        playerBlock.name = "Player Block"
        playerBlock.position = CGPoint(x: CGFloat(columnIndex) * blockWidth, y: -(CGFloat(rowIndex) * blockHeight))
        playerBlock.zPosition = 6
        
        self.addChild(playerBlock)
    }
    
    func setupEndBlock(columnIndex: Int, rowIndex: Int) {
        endBlock = SKSpriteNode(imageNamed: "End Block")
        endBlock.size = CGSize(width: blockWidth, height: blockHeight)
        endBlock.anchorPoint = CGPoint(x: 0, y: 1)
        endBlock.name = "End Block"
        endBlock.position = CGPoint(x: CGFloat(columnIndex) * blockWidth, y: -(CGFloat(rowIndex) * blockHeight))
        endBlock.zPosition = 5
        
        self.addChild(endBlock)
    }
    
    func addNumberBlock(columnIndex: Int, rowIndex: Int, blockType: Int) {
        let numberBlockSprite: SKSpriteNode
        let imageName = "Number " + String(blockType-10) + " Block"
        numberBlockSprite = SKSpriteNode(imageNamed: imageName)
        numberBlockSprite.size = CGSize(width: blockWidth, height: blockHeight)
        numberBlockSprite.anchorPoint = CGPoint(x: 0, y: 1)
        numberBlockSprite.name = "Number Block"
        numberBlockSprite.position = CGPoint(x: CGFloat(columnIndex) * blockWidth, y: -(CGFloat(rowIndex) * blockHeight))
        numberBlockSprite.zPosition = 5
        self.addChild(numberBlockSprite)
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
    
    func hintButtonPressed() {
        
        let direction = levelGenerator.getSolver().solveForNextMove(level: getCurrentLevel(), customStart: currentPosition)
        if (direction != "none") {
            handleMove(direction: direction)
        }
    }
    
    func handleSwipe(sender: UISwipeGestureRecognizer) {
        
        if (sender.direction.rawValue == 1){
            handleMove(direction: "right")
        } else if (sender.direction.rawValue == 2){
            handleMove(direction: "left")
        } else if (sender.direction.rawValue == 4){
            handleMove(direction: "up")
        } else if (sender.direction.rawValue == 8){
            handleMove(direction: "down")
        }
        
    }
    
    func handleMove(direction: String) {
        var positions = Array<Array<Int>>()
        var newPosition = Array<Int>()
        var numMovesArray = Array<Int>()
        var numMoves = Int()
        
        if (!isMoving && !levelPaused && !levelComplete) {
            (positions, numMovesArray, levelComplete) = getCurrentLevel().calculateMove(position: currentPosition, direction: direction)
            newPosition = positions[0]
            numMoves = numMovesArray[0]
            
            currentPosition = newPosition
            moveBox(toPosition: currentPosition, numBlocks: numMoves)
        }
    }
    
    func moveBox(toPosition: Array<Int>, numBlocks: Int) {
    
        let moveTime = TimeInterval(perBlockTime * abs(CGFloat(numBlocks)))
        var moveToPosition = CGPoint()
        var moveAnimation = SKAction();
        
        isMoving = true
        
        moveToPosition = CGPoint(x:  CGFloat(toPosition[0])*blockWidth,
                                 y: -CGFloat(toPosition[1])*blockHeight)
        
        moveAnimation = SKAction.move(to: moveToPosition, duration: moveTime)
        
        playerBlock.run(moveAnimation, completion: moveComplete)
    }
    
    func moveComplete() -> Void {
        isMoving = false
        
        if (levelComplete) {
            createLevelCompletePanel()
        }
    }
    
    func createPausePanel() {
        levelPaused = true
        self.scene?.isPaused = true
        
        popupPanel = SKSpriteNode(imageNamed: "Panel")
        popupPanel.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        popupPanel.position = CGPoint(x: self.size.width/2, y: -self.size.height/2)
        popupPanel.size = CGSize(width: 800, height: 500)
        popupPanel.zPosition = 11
        
        let label = SKLabelNode()
        let resume = SKSpriteNode(imageNamed: "Play Button")
        let new = SKSpriteNode(imageNamed: "New Button")
        let quit = SKSpriteNode(imageNamed: "Home Button")
    
        label.name = "Pause Label"
        label.fontName = "Helvetica"
        label.fontSize = 96
        label.text = "Paused"
        label.fontColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
        label.position = CGPoint(x: 0, y: 120)
        label.zPosition = 11
        
        resume.name = "Resume"
        resume.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        resume.position = CGPoint(x: -250, y: -50)
        resume.size = CGSize(width: 200, height: 200)
        resume.zPosition = 12
        
        new.name = "New"
        new.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        new.position = CGPoint(x: 0, y: -50)
        new.size = CGSize(width: 200, height: 200)
        new.zPosition = 12
        
        quit.name = "Home"
        quit.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        quit.position = CGPoint(x: 250, y: -50)
        quit.size = CGSize(width: 200, height: 200)
        quit.zPosition = 12
        
        popupPanel.addChild(label)
        popupPanel.addChild(resume)
        popupPanel.addChild(new)
        popupPanel.addChild(quit)
        
        self.addChild(popupPanel)
    }
    
    func createLevelCompletePanel() {
        levelComplete = true
        self.scene?.isPaused = true
        
        popupPanel = SKSpriteNode(imageNamed: "Panel")
        popupPanel.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        popupPanel.position = CGPoint(x: self.size.width/2, y: -self.size.height/2)
        popupPanel.size = CGSize(width: 800, height: 500)
        popupPanel.zPosition = 11
        
        let label = SKLabelNode()
        let new = SKSpriteNode(imageNamed: "New Button")
        let quit = SKSpriteNode(imageNamed: "Home Button")
        
        label.name = "Level Complete Label"
        label.fontName = "Helvetica"
        label.fontSize = 96
        label.text = "Level Complete"
        label.fontColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
        label.position = CGPoint(x: 0, y: 120)
        label.zPosition = 11
        
        new.name = "New"
        new.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        new.position = CGPoint(x: -150, y: -50)
        new.size = CGSize(width: 200, height: 200)
        new.zPosition = 12
        
        quit.name = "Home"
        quit.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        quit.position = CGPoint(x: 150, y: -50)
        quit.size = CGSize(width: 200, height: 200)
        quit.zPosition = 12
        
        popupPanel.addChild(label)
        popupPanel.addChild(new)
        popupPanel.addChild(quit)
        
        self.addChild(popupPanel)
    }
    
    func getCurrentLevel() -> BaseLevel {
        let level: BaseLevel
        if levelType == "Basic" {
            level = basicLevel
        } else if levelType == "Number" {
            level = numberLevel
        } else {
            level = basicLevel
        }
        return level
    }
}
