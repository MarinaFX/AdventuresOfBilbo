//
//  GameScene.swift
//  AdventuresOfBilbo
//
//  Created by Marina De Pazzi on 10/09/21.
//

import SpriteKit
import GameplayKit

//MARK: - GameScene Class

class GameScene: SKScene {
    
    //MARK: GameScene Nodes
    private var bilbo = SKSpriteNode()
    private var bilboWalkingFrames: [SKTexture] = []
    
    private var floor: SKShapeNode = SKShapeNode()
    private var background: SKSpriteNode = SKSpriteNode()
    
    //MARK: GameScene Variables
    let upMove = SKSpriteNode(imageNamed: "upMove")
    let leftMove = SKSpriteNode (imageNamed: "leftMove")
    let rightMove = SKSpriteNode (imageNamed: "rightMove")
    
    //private var previousTime: TimeInterval?
    
    //MARK: Flags
    private var backgroundsCount = 0
    
    //MARK: GameScene Init
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        buildBilbo()
        animateBilbo()
        createScenery()
        setSceneryPhysics()
        createControls()
        createBackground(idealPosX: 0)
    }
    
    func createControls() {
        upMove.name = "upButton"
        upMove.position = CGPoint(x: 330, y: -130)
        upMove.size = CGSize (width: 70, height: 70)
        upMove.zPosition = 5
        addChild(upMove)
        
        leftMove.name = "leftMove"
        leftMove.position = CGPoint(x: -330, y: -130)
        leftMove.size = CGSize (width: 70, height: 70)
        leftMove.zPosition = 5
        addChild(leftMove)
        
        rightMove.name = "rightMove"
        rightMove.position = CGPoint(x: -220, y: -130)
        rightMove.size = CGSize (width: 70, height: 70)
        rightMove.zPosition = 5
        addChild(rightMove)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches) {
            let location = touch.location(in: self)
            
            if upMove.contains(location){
                let moveUp = SKAction.move(by: CGVector(dx: 0.0, dy: 40.0), duration: 0.6)
                let moveDown = SKAction.move(by: CGVector(dx: 0.0, dy: -40.0), duration: 0.6)
                let sequence = SKAction.sequence([moveUp,moveDown])
                
                bilbo.run(sequence)
            } else if rightMove.contains(location){
                let moveUp = SKAction.move(by: CGVector(dx: 10, dy: 0), duration: 0.6)
                let sequence = SKAction.sequence([moveUp])
                
                bilbo.run(sequence)
            } else if leftMove.contains(location){
                let moveUp = SKAction.move(by: CGVector(dx: -10, dy: 0), duration: 0.6)
                let sequence = SKAction.sequence([moveUp])
                
                bilbo.run(sequence)
            }
        }
    }
    //MARK:- GameScene Buttons Actions
    
    @objc func yMove() {
        let moveUp = SKAction.move(by: CGVector(dx: 0.0, dy: 40.0), duration: 0.6)
        let moveDown = SKAction.move(by: CGVector(dx: 0.0, dy: -40.0), duration: 0.6)
        let sequence = SKAction.sequence([moveUp,moveDown])
        
        bilbo.run(sequence)
    }
    func xMove(moveBy: CGFloat, forTheKey: String) {
        let rightAction = SKAction.moveBy(x: moveBy, y: 0, duration: 1)
        let repeatForEver = SKAction.repeatForever(rightAction)
        let seq = SKAction.sequence([rightAction, repeatForEver])
        
        //run the action on your ship
        bilbo.run(seq, withKey: forTheKey)
    }

    //MARK: GameScene Functions
    
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
        bilbo.position = CGPoint(x: 0, y: 0)
        bilbo.zPosition = 3
        bilbo.size = CGSize(width: ((scene?.size.width)! * 0.6), height: ((scene?.size.height)! * 0.6))
        
        //settings cat physics body
        for i in 1...numImages {
            let bilboPhysicsBody = SKPhysicsBody(texture: bilboWalkingFrames[i - 1], size: bilbo.size)
            bilboPhysicsBody.isDynamic = true
            bilboPhysicsBody.affectedByGravity = true
            self.bilbo.physicsBody = bilboPhysicsBody
        }
        
        addChild(bilbo)
    }
    
    func animateBilbo() {
        bilbo.run(SKAction.repeatForever(
                    SKAction.animate(with: bilboWalkingFrames,
                                     timePerFrame: 0.1,
                                     resize: false,
                                     restore: true)),
                  withKey:"walkingInPlaceCat")
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
    
    func animateBackground() {
        self.enumerateChildNodes(withName: "Background") { node, error in
            node.position.x -= 2
            if node.position.x + node.frame.width/2 < ((self.scene?.frame.width ?? 0)/2) + 2 && self.backgroundsCount < 2 {
                if let sceneSize = self.scene?.frame.size {
                    self.createBackground(idealPosX: sceneSize.width)
                }
            }
            else if node.position.x + node.frame.width/2 < -(self.scene?.frame.width ?? 0)/2 {
                node.removeFromParent()
                self.backgroundsCount -= 1
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        animateBackground()
    }
}
