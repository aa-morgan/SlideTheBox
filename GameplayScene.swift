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
    var hintBtn = SKSpriteNode()
    var minMovesIndicator = SKLabelNode()
    var curMovesIndicator = SKLabelNode()
    var homeBtn = SKSpriteNode()
    var resumeBtn = SKSpriteNode()
    var newLevelBtn = SKSpriteNode()
    var popupPanel = SKSpriteNode()
    var popupPanelLabel = SKLabelNode()
    
    var playerBlock = SKSpriteNode()
    var endBlock = SKSpriteNode()
    var enemyBlocks = Array<SKSpriteNode>()
    let numOfEnemies = 2
    
    var level = Level()
    var levelGenerator = LevelGenerator()
    let numbersKey = "Use Numbers"
    let arrowsKey = "Use Arrows"
    let enemiesKey = "Use Enemies"
    var useNumbers = Bool()
    var useArrows = Bool()
    var useEnemies = Bool()
    
    var numBlocksX = Int(16)
    var numBlocksY = Int(8)
    var blockWidth = CGFloat()
    var blockHeight = CGFloat()
    let menuBarHeight = CGFloat(100)
    let blockGap = CGFloat(4)
    
    var currentPlayerPosition = Array<Int>()
    var previousPlayerPosition = Array<Int>()
    var currentEnemyPositions = Array<Array<Int>>()
    var curNumMoves = 0
    
    var playerIsMoving = Bool()
    var enemiesMoving = Int()
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
            
            if atPoint(location).name == "Hint" {
                if (!levelPaused && !levelComplete) {
                    hintButtonPressed()
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
        
        useNumbers = UserDefaults.standard.bool(forKey: numbersKey)
        useArrows = UserDefaults.standard.bool(forKey: arrowsKey)
        useEnemies = UserDefaults.standard.bool(forKey: enemiesKey)
    
    }
    
    func setupMenuBar() {
        pauseBtn = self.childNode(withName: "Pause") as! SKSpriteNode
        hintBtn = self.childNode(withName: "Hint") as! SKSpriteNode
        
        minMovesIndicator = self.childNode(withName: "Minimum Moves") as! SKLabelNode
        curMovesIndicator = self.childNode(withName: "Number Moves") as! SKLabelNode
        
        minMovesIndicator.text = "-"
        curMovesIndicator.text = "-"
    }
    
    func setupLevel() {
        levelGenerator = LevelGenerator(numBlocksX: numBlocksX, numBlocksY: numBlocksY, useNumbers: useNumbers, useArrows: useArrows)
        level = levelGenerator.generate()
        currentPlayerPosition = level.getStartPosition()
        
        playerIsMoving = false
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
                } else if (blockType >= 20 && blockType <= 23) { // Setup arrow block
                    addArrowBlock(columnIndex: columnIndex, rowIndex: rowIndex, blockType: blockType)
                }
                
                columnIndex += 1
            }
            columnIndex = 0
            rowIndex += 1
        }
        
        if useEnemies {
            setupEnemyBlocks(level: level)
        }
        
        curNumMoves = 0
        minMovesIndicator.text = String(level.getMinMoves())
        curMovesIndicator.text = String(curNumMoves)
        
        previousPlayerPosition = level.getStartPosition()
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
    
    func setupEnemyBlocks(level: Level) {
    
        for index in 1...numOfEnemies {
            
            let explorablePosition = level.getSolution().getExplorablePosition(greaterThan: level.getMinMoves()-1, level: level, seed: index)
            let columnIndex = explorablePosition[0]
            let rowIndex = explorablePosition[1]
            
            let enemyBlock = SKSpriteNode(imageNamed: "Enemy Block")
            enemyBlock.size = CGSize(width: blockWidth, height: blockHeight)
            enemyBlock.anchorPoint = CGPoint(x: 0, y: 1)
            enemyBlock.name = "Enemy Block"
            enemyBlock.position = CGPoint(x: CGFloat(columnIndex) * blockWidth, y: -(CGFloat(rowIndex) * blockHeight))
            enemyBlock.zPosition = 7
            
            enemyBlocks.append(enemyBlock)
            currentEnemyPositions.append(explorablePosition)
            self.addChild(enemyBlock)
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

    func addArrowBlock(columnIndex: Int, rowIndex: Int, blockType: Int) {
        let arrowBlockSprite: SKSpriteNode
        var arrowType = ""
        
        if blockType == 20 {
            arrowType = "Up"
        } else if blockType == 21 {
            arrowType = "Down"
        } else if blockType == 22 {
            arrowType = "Left"
        } else if blockType == 23 {
            arrowType = "Right"
        }
        
        let imageName = "Arrow " + arrowType
        arrowBlockSprite = SKSpriteNode(imageNamed: imageName)
        arrowBlockSprite.size = CGSize(width: blockWidth, height: blockHeight)
        arrowBlockSprite.anchorPoint = CGPoint(x: 0, y: 1)
        arrowBlockSprite.name = "Arrow Block"
        arrowBlockSprite.position = CGPoint(x: CGFloat(columnIndex) * blockWidth, y: -(CGFloat(rowIndex) * blockHeight))
        arrowBlockSprite.zPosition = 5
        self.addChild(arrowBlockSprite)
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
        
        let (direction, _) = levelGenerator.getSolver().solveForNextMove(level: level, customStart: currentPlayerPosition, customEnd: level.getEndPosition())
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
        
        if (!playerIsMoving && enemiesMoving == 0 && !levelPaused && !levelComplete) {
            var positions = Array<Array<Int>>()
            var newPosition = Array<Int>()
            var numMovesArray = Array<Int>()
            curNumMoves += 1
            curMovesIndicator.text = String(curNumMoves)
            
            (positions, numMovesArray, levelComplete, _) = level.calculateMove(position: currentPlayerPosition, direction: direction, blockType: "player")
            newPosition = positions.last!
            
            currentPlayerPosition = newPosition
            moveBlock(spriteNode: playerBlock, type: "player", toPositions: positions, numBlocks: numMovesArray)
            
            if useEnemies {
                var enemyPositions = Array<Array<Int>>()
                var enemyNewPosition = Array<Int>()
                var enemyNumMovesArray = Array<Int>()

                var index = 0
                for enemyBlock in enemyBlocks {
                    
                    var (enemyDirection, notFound) = levelGenerator.getSolver().solveForNextMove(level: level, customStart: currentEnemyPositions[index], customEnd: currentPlayerPosition)
                    
                    if notFound {
                        (enemyDirection, notFound) = levelGenerator.getSolver().solveForNextMove(level: level, customStart: currentEnemyPositions[index], customEnd: previousPlayerPosition)
                    }
                    
                    if notFound {
                        (enemyDirection, _) = levelGenerator.getSolver().solveForNextMove(level: level, customStart: currentEnemyPositions[index], customEnd: level.getEndPosition())
                    }
                    
                    (enemyPositions, enemyNumMovesArray, _, _) = level.calculateMove(position: currentEnemyPositions[index], direction: enemyDirection, blockType: "enemy")
                    enemyNewPosition = enemyPositions.last!
                    
                    currentEnemyPositions[index] = enemyNewPosition
                    moveBlock(spriteNode: enemyBlock, type: "enemy", toPositions: enemyPositions, numBlocks: enemyNumMovesArray)
                    
                    index += 1
                }
                
            }
            
            previousPlayerPosition = currentPlayerPosition
        }
    }
    
    func moveBlock(spriteNode: SKSpriteNode, type: String, toPositions: Array<Array<Int>>, numBlocks: Array<Int>) {
        
        if type == "player" {
            playerIsMoving = true
        } else if type == "enemy" {
            enemiesMoving += 1
        }
        
        
        var moveTime = TimeInterval()
        var moveToPosition = CGPoint()
        var moveAnimations = Array<SKAction>()
        
        var index = -1
        for position in toPositions {
            
            if index >= 0 { // Ignore first position
                moveTime = TimeInterval(perBlockTime * abs(CGFloat(numBlocks[index])))
                
                moveToPosition = CGPoint(x:  CGFloat(position[0])*blockWidth,
                                         y: -CGFloat(position[1])*blockHeight)
                
                moveAnimations.append(SKAction.move(to: moveToPosition, duration: moveTime))
            }
            index += 1
        }
        
        if type == "player" {
            spriteNode.run(SKAction.sequence(moveAnimations), completion: movePlayerComplete)
        } else if type == "enemy" {
            spriteNode.run(SKAction.sequence(moveAnimations), completion: moveEnemyComplete)
        }

    }
    
    func movePlayerComplete() -> Void {
        playerIsMoving = false
        
        if (levelComplete) {
            createLevelCompletePanel()
        }
    }
    
    func moveEnemyComplete() -> Void {
        enemiesMoving -= 1
    }
    
    func createPausePanel() {
        levelPaused = true
        self.scene?.isPaused = true
        
        popupPanel = SKSpriteNode(imageNamed: "Panel")
        popupPanel.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        popupPanel.position = CGPoint(x: self.size.width/2, y: -self.size.height/2)
        popupPanel.size = CGSize(width: 800, height: 500)
        popupPanel.zPosition = 11
        
        let resume = SKSpriteNode(imageNamed: "Play Button")
        let new = SKSpriteNode(imageNamed: "New Button")
        let quit = SKSpriteNode(imageNamed: "Home Button")
    
        popupPanelLabel.name = "Pause Label"
        popupPanelLabel.fontName = "Helvetica"
        popupPanelLabel.fontSize = 96
        popupPanelLabel.text = "Paused"
        popupPanelLabel.fontColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
        popupPanelLabel.position = CGPoint(x: 0, y: 120)
        popupPanelLabel.zPosition = 11
        
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
        
        popupPanel.addChild(popupPanelLabel)
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
        
        let new = SKSpriteNode(imageNamed: "New Button")
        let quit = SKSpriteNode(imageNamed: "Home Button")
        
        popupPanelLabel.name = "Level Complete Label"
        popupPanelLabel.fontName = "Helvetica"
        popupPanelLabel.fontSize = 96
        popupPanelLabel.text = "Level Complete"
        popupPanelLabel.fontColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
        popupPanelLabel.position = CGPoint(x: 0, y: 120)
        popupPanelLabel.zPosition = 11
        
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
        
        popupPanel.addChild(popupPanelLabel)
        popupPanel.addChild(new)
        popupPanel.addChild(quit)
        
        self.addChild(popupPanel)
    }

}
