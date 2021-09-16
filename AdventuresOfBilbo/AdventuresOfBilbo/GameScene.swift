//
//  GameScene.swift
//  AdventuresOfBilbo
//
//  Created by Marina De Pazzi on 10/09/21.
//

import SpriteKit
import GameplayKit
import UIKit

//MARK: - GameScene Class

class GameScene: SKScene {
    
    //MARK:- GameScene Nodes
    private var bilbo: SKSpriteNode = SKSpriteNode()
    private var bilboWalkingFrames: [SKTexture] = []
    private var floor: SKShapeNode = SKShapeNode()
    private var background: SKSpriteNode = SKSpriteNode()
    
    var touchUP = SKSpriteNode()
    
    //MARK:- GameScene Variables
    private var backgroundsCount = 0
    private var originalBilboPosY: CGFloat = 0
    private var previousTime: TimeInterval?

    //MARK:- GameScene Audio
    private let audio = SKAudioNode(fileNamed: "Ishikari_Lore_-_Kevin_MacLeod")
    private let playAudio = SKAction.play()
    
    //MARK:- GameScene Init
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        //set audio
        audio.autoplayLooped = true
        addChild(audio)
        audio.run(playAudio)
        
        buildBilbo()
        animateBilbo()
        createScenery()
        setSceneryPhysics()
        score.setup(size: size)
        addChild(score)
        createBackground(idealPosX: 0)
        startCount()
        isUserInteractionEnabled = true
        physicsWorld.contactDelegate = self
    }
    
    //MARK:- Hud Score
    private var score = HudNode()
    var totalTime = Timer()
    var timeInicial = 0
    
    func startCount(){
        totalTime = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(addCounter), userInfo: nil, repeats: true)
    }
    @objc func addCounter(){
        score.addPoint()
    }
    
    //MARK:- Bilbo's Movement
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let originalBilboPosY = floor.position.y + floor.frame.size.height/2 + bilbo.frame.size.height/2
        if bilbo.position.y < originalBilboPosY {
            bilbo.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 140))
        }
    }
    func updatePlayer () {
        let originalBilboPosY = floor.position.y + floor.frame.size.height/2 + bilbo.frame.size.height/2
        if bilbo.position.y < originalBilboPosY {
            bilbo.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 140))
        }
    }
    
    //MARK:- GameScene Functions
    func setSceneryPhysics() {
        //setting floor physics body
        let floorPhysicsBody = SKPhysicsBody(rectangleOf: self.floor.frame.size)
        floorPhysicsBody.isDynamic = false
        self.floor.physicsBody = floorPhysicsBody
    }
    
    func buildBilbo() {
        let catAnimatedAtlas = SKTextureAtlas(named: "CatMovement")
        var walkFrames: [SKTexture] = []
        
        let numImages = catAnimatedAtlas.textureNames.count
        for i in 1...numImages {
            let catTextureName = "gato_\(i)"
            walkFrames.append(catAnimatedAtlas.textureNamed(catTextureName))
        }
        bilboWalkingFrames = walkFrames
        
        let firstFrameTexture = bilboWalkingFrames[0]
        bilbo = SKSpriteNode(texture: firstFrameTexture)
        bilbo.position = CGPoint(x: -200, y: 0)
        bilbo.zPosition = 3
        bilbo.size = CGSize(width: ((scene?.size.width)! * 0.20), height: ((scene?.size.height)! * 0.25))
        bilbo.name = "Bilbo"
        
        //settings cat physics body
        for i in 1...numImages {
            let bilboPhysicsBody = SKPhysicsBody(texture: bilboWalkingFrames[i - 1], size: bilbo.size)
            bilboPhysicsBody.isDynamic = true
            bilboPhysicsBody.affectedByGravity = true
            bilboPhysicsBody.allowsRotation = false
            bilboPhysicsBody.restitution = 0.0
            bilboPhysicsBody.contactTestBitMask = 0x1 << 1
            bilboPhysicsBody.categoryBitMask = 0x1
            self.bilbo.physicsBody = bilboPhysicsBody
        }
        
        addChild(bilbo)
    }
    
    func createScenery() {
        //creating floor
        let floor = SKShapeNode(rectOf: CGSize(width: (scene?.size.width)!, height: 20))
        floor.name = "floor"
        floor.fillColor = #colorLiteral(red: 0.2631310523, green: 0.1023383066, blue: 0.2378421128, alpha: 1)
        floor.strokeColor = #colorLiteral(red: 0.2631310523, green: 0.1023383066, blue: 0.2378421128, alpha: 1)
        
        let floorPos = CGPoint(x: 0, y: -((scene?.size.height)! * 0.47))
        floor.position = floorPos
        floor.zPosition = 3
        
        self.floor = floor
        
        addChild(self.floor)
        originalBilboPosY = floor.position.y + floor.frame.size.height/2 + bilbo.frame.size.height/2
    }
    
    func createBackground(idealPosX: CGFloat) {
        //creating infinite background
        guard let sceneSize = scene?.size else { return }
        let background = SKSpriteNode(imageNamed: "background")
        background.name = "Background"
        let proportion = background.frame.width/background.frame.height
        
        
        let backgroundSize = CGSize(width: sceneSize.height * proportion, height: sceneSize.height)
        background.size = backgroundSize
        
        let offset = (backgroundSize.width - sceneSize.width)/2
        
        let backgroundPosition = CGPoint(x: idealPosX + offset, y: 0)
        background.position = backgroundPosition
        
        addChild(background)
        backgroundsCount += 1
    }
    //MARK: Obstacles
    func generateRandomObstacle() {
        guard let sceneSize = scene?.size else { return }
        let randomObstacleNumber = Int.random(in: 0...2)
        guard let obstacle = SceneryObstacles(rawValue: randomObstacleNumber) else { return }
        
        let obstacleNode = SKSpriteNode(imageNamed: obstacle.imageObstacles)
        obstacleNode.size = obstacle.size
        let posY = obstacle.positionType == .floor ? floor.position.y + floor.frame.height/2 + obstacle.size.height/2 : 0
        obstacleNode.position = CGPoint(x: sceneSize.width/2 + obstacleNode.size.width/2, y: posY)
        obstacleNode.zPosition = 100000
        obstacleNode.name = "Obstacle"
        obstacleNode.physicsBody = SKPhysicsBody(rectangleOf: obstacleNode.size)
        obstacleNode.physicsBody?.affectedByGravity = false
        obstacleNode.physicsBody?.isDynamic = true
        obstacleNode.physicsBody?.contactTestBitMask = 0x1
        obstacleNode.physicsBody?.categoryBitMask = 0x1 << 1
        
        addChild(obstacleNode)
    }
    //MARK:- Animation Functions
    func animateBilbo() {
        bilbo.run(SKAction.repeatForever(SKAction.animate(with: bilboWalkingFrames, timePerFrame: 0.1, resize: false, restore: true)), withKey:"walkingInPlaceCat")
    }
    
    func animateBackground() {
        let velocity: CGFloat = 5
        self.enumerateChildNodes(withName: "Background") { node, error in
            node.position.x -= velocity
            if node.position.x + node.frame.width/2 < ((self.scene?.frame.width ?? 0)/2) + velocity && self.backgroundsCount < 2 {
                if let sceneSize = self.scene?.frame.size {
                    self.createBackground(idealPosX: sceneSize.width)
                }
            }
            else if node.position.x + node.frame.width/2 < -(self.scene?.frame.width ?? 0)/2 {
                node.removeFromParent()
                self.backgroundsCount -= 1
            }
        }
        
        self.enumerateChildNodes(withName: "Obstacle") { node, error in
            node.position.x -= velocity
            if node.position.x + node.frame.width/2 < -(self.scene?.frame.width ?? 0)/2 {
                node.removeFromParent()
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        animateBackground()
        if let previousTime = previousTime {
            if currentTime - previousTime >= 2 {
                generateRandomObstacle()
                self.previousTime = currentTime
            }
        } else {
            previousTime = currentTime
        }
    }
    
    func removeBilboAndObstacles() {
        bilbo.removeFromParent()
        self.enumerateChildNodes(withName: "Obstacle") { node, error in
            node.removeFromParent()
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "Obstacle" && contact.bodyB.node?.name == "Bilbo" {
            contact.bodyA.node?.removeFromParent()
            removeBilboAndObstacles()
            score.resetPoints()
            buildBilbo()
            animateBilbo()
        } else if contact.bodyB.node?.name == "Obstacle" && contact.bodyA.node?.name == "Bilbo" {
            contact.bodyB.node?.removeFromParent()
            removeBilboAndObstacles()
            score.resetPoints()
            buildBilbo()
            animateBilbo()
        }
    }
}
