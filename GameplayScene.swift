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
    
    var playerBox = SKSpriteNode()
    var endBlock = SKSpriteNode()
    
    let levelType = "Basic"
    var level = BasicLevel()
    var levelGenerator = LevelGenerator()
    var levelSolver = BasicLevelSolver()
    var difficulty = BasicDifficultyCriteria()
    
    var numBlocksX = Int()
    var numBlocksY = Int()
    var blockWidth = CGFloat()
    var blockHeight = CGFloat()
    let menuBarHeight = CGFloat(100)
    
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
        
        numBlocksX = 12
        numBlocksY = 6
        blockWidth = playableWidth / CGFloat(numBlocksX)
        blockHeight = playableHeight / CGFloat(numBlocksY)
        
    }
    
    func setupMenuBar() {
        pauseBtn = self.childNode(withName: "Pause") as! SKSpriteNode
        hintBtn = self.childNode(withName: "Hint") as! SKSpriteNode
    }
    
    func setupLevel() {
        difficulty = BasicDifficultyCriteria(difficulty: "easy")
        levelGenerator = LevelGenerator(levelType: levelType, numBlocksX: numBlocksX, numBlocksY: numBlocksY, difficulty: difficulty)
        level = levelGenerator.generate()
        currentPosition = level.getStartPosition()
        
        isMoving = false
        levelPaused = false
        levelComplete = false
        
        var rowIndex = 0
        var columnIndex = 0
        for row in level.getBlocksReal() {
            for blockType in row {
                if blockType == 1 { // Add block box
                    let blockBoxSprite = SKSpriteNode(imageNamed: "Block Box")
                    blockBoxSprite.size = CGSize(width: blockWidth, height: blockHeight)
                    blockBoxSprite.anchorPoint = CGPoint(x: 0, y: 1)
                    blockBoxSprite.name = "Block Box"
                    blockBoxSprite.position = CGPoint(x: CGFloat(columnIndex) * blockWidth, y: -(CGFloat(rowIndex) * blockHeight))
                    blockBoxSprite.zPosition = 5
                    self.addChild(blockBoxSprite)
                    
                } else if blockType == 8 { // Setup player box
                    setupPlayerBox(rowIndex: rowIndex, columnIndex: columnIndex)
                } else if blockType == 9 { // Setup end block
                    setupEndBlock(rowIndex: rowIndex, columnIndex: columnIndex)
                }
                columnIndex += 1
            }
            columnIndex = 0
            rowIndex += 1
        }
        
    }
    
    func setupPlayerBox(rowIndex: Int, columnIndex: Int) {
        playerBox = SKSpriteNode(imageNamed: "Player Box")
        playerBox.size = CGSize(width: blockWidth, height: blockHeight)
        playerBox.anchorPoint = CGPoint(x: 0, y: 1)
        playerBox.name = "Player Box"
        playerBox.position = CGPoint(x: CGFloat(columnIndex) * blockWidth, y: -(CGFloat(rowIndex) * blockHeight))
        playerBox.zPosition = 6
        
        self.addChild(playerBox)
    }
    
    func setupEndBlock(rowIndex: Int, columnIndex: Int) {
        endBlock = SKSpriteNode(imageNamed: "End Block")
        endBlock.size = CGSize(width: blockWidth, height: blockHeight)
        endBlock.anchorPoint = CGPoint(x: 0, y: 1)
        endBlock.name = "End Block"
        endBlock.position = CGPoint(x: CGFloat(columnIndex) * blockWidth, y: -(CGFloat(rowIndex) * blockHeight))
        endBlock.zPosition = 5
        
        self.addChild(endBlock)
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
        let direction = levelSolver.solveForNextMove(level: level, customStart: currentPosition)
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
        var newPosition = Array<Int>()
        var numMoves = Int()
        
        if (!isMoving && !levelPaused && !levelComplete) {
            (newPosition, numMoves, levelComplete) = level.calculateMove(position: currentPosition, direction: direction)
            
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
        
        playerBox.run(moveAnimation, completion: moveComplete)
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
        
        popupPanel = SKSpriteNode(imageNamed: "Popup Panel")
        popupPanel.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        popupPanel.position = CGPoint(x: self.size.width/2, y: -self.size.height/2)
        popupPanel.size = CGSize(width: 800, height: 500)
        popupPanel.zPosition = 11
        
        let label = SKLabelNode()
        let resume = SKSpriteNode(imageNamed: "Play")
        let new = SKSpriteNode(imageNamed: "New")
        let quit = SKSpriteNode(imageNamed: "Home")
    
        label.name = "Pause Label"
        label.fontName = "Chalkboard"
        label.fontSize = 96
        label.text = "Paused"
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
        
        popupPanel = SKSpriteNode(imageNamed: "Popup Panel")
        popupPanel.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        popupPanel.position = CGPoint(x: self.size.width/2, y: -self.size.height/2)
        popupPanel.size = CGSize(width: 800, height: 500)
        popupPanel.zPosition = 11
        
        let label = SKLabelNode()
        let new = SKSpriteNode(imageNamed: "New")
        let quit = SKSpriteNode(imageNamed: "Home")
        
        label.name = "Level Complete Label"
        label.fontName = "Chalkboard"
        label.fontSize = 96
        label.text = "Level Complete"
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
}
