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
    
    private var floor = SKShapeNode()
    private var wall = SKShapeNode()
    private var midFloor = SKShapeNode()
    private var ceiling = SKShapeNode()
    
    //MARK: GameScene Variables
    private var floorSize = CGSize(width: 0, height: 0)
    
    let upMove = SKSpriteNode(imageNamed: "upMove")
    let leftMove = SKSpriteNode (imageNamed: "leftMove")
    let rightMove = SKSpriteNode (imageNamed: "rightMove")

    
    //MARK: GameScene Init
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        floorSize = CGSize(width: (scene?.size.width)!, height: 20)
        
        buildBilbo()
        animateBilbo()
        createScenery()
        setSceneryPhysics()
        createControls()

        
    }
    func createControls(){
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
        for touch in (touches ){
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
    
    @objc func yMove(){
        let moveUp = SKAction.move(by: CGVector(dx: 0.0, dy: 40.0), duration: 0.6)
        let moveDown = SKAction.move(by: CGVector(dx: 0.0, dy: -40.0), duration: 0.6)
        let sequence = SKAction.sequence([moveUp,moveDown])
        
        bilbo.run(sequence)
    }
    func xMove (moveBy: CGFloat, forTheKey: String) {
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
        
        let wallPhysicsBody = SKPhysicsBody(rectangleOf: self.wall.frame.size)
        wallPhysicsBody.isDynamic = false
        self.wall.physicsBody = wallPhysicsBody
        
        let midFloorPhysicsBody = SKPhysicsBody(rectangleOf: self.midFloor.frame.size)
        midFloorPhysicsBody.isDynamic = false
        self.midFloor.physicsBody = midFloorPhysicsBody
        
        let ceilingPhysicsBody = SKPhysicsBody(rectangleOf: self.ceiling.frame.size)
        ceilingPhysicsBody.isDynamic = false
        self.ceiling.physicsBody = ceilingPhysicsBody
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
    
    func createScenery(){
        //creating floor
        let floor = SKShapeNode(rectOf: floorSize)
        floor.name = "floor"
        floor.fillColor = .blue
        floor.strokeColor = .blue
        
        let floorPos = CGPoint(x: 0, y: -((scene?.size.height)! * 0.35))
        floor.position = floorPos
        floor.zPosition = 3
        
        self.floor = floor
        
        //create left starting wall
        let wall = SKShapeNode(rectOf: CGSize(width: 20, height: -((scene?.size.height)! * 0.7)))
        wall.name = "wall"
        wall.fillColor = .orange
        wall.strokeColor = .orange
        
        let wallPos = CGPoint(x: -((scene?.size.width)! * 0.4), y: 0)
        wall.position = wallPos
        wall.zPosition = 2
        
        self.wall = wall
        
        //creating mid floor
        let midFloor = SKShapeNode(rectOf: floorSize)
        midFloor.name = "midFloor"
        midFloor.fillColor = .blue
        midFloor.strokeColor = .blue
        
        let midFloorPos = CGPoint(x: ((scene?.size.width)! * 0.9), y: 0)
        midFloor.position = midFloorPos
        midFloor.zPosition = 3
        
        self.midFloor = midFloor
        
        //creating ceiling
        let ceiling = SKShapeNode(rectOf: floorSize)
        ceiling.name = "ceiling"
        ceiling.fillColor = .blue
        ceiling.strokeColor = .blue
        
        let ceilingPos = CGPoint(x: 0, y: ((scene?.size.height)! * 0.35))
        ceiling.position = ceilingPos
        ceiling.zPosition = 3
        
        self.ceiling = ceiling
        
        addChild(self.floor)
        addChild(self.wall)
        addChild(self.midFloor)
        addChild(self.ceiling)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
