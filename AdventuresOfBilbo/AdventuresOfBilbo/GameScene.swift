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
    private var bilbo: SKSpriteNode = SKSpriteNode()
    private var bilboWalkingFrames: [SKTexture] = []
    
    private var floor: SKShapeNode = SKShapeNode()
    private var wall: SKShapeNode = SKShapeNode()
    private var midFloor: SKShapeNode = SKShapeNode()
    private var ceiling: SKShapeNode = SKShapeNode()
    
    var touchUP = SKSpriteNode()
    private var score = HudNode()
    
    //MARK: GameScene Variables
    private var floorSize: CGSize = CGSize(width: 0, height: 0)
//    private var cam: SKCameraNode = SKCameraNode()
    
    //MARK: GameScene Init
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
//        self.camera = cam
        self.backgroundColor = .brown
        floorSize = CGSize(width: (scene?.size.width)!, height: 20)
        
        buildBilbo()
        animateBilbo()
        createScenery()
        setSceneryPhysics()
        score.setup(size: size)
        addChild(score)
//        createControls()
        
//        self.addChild(cam)
    }
    
//    func createControls(){
//        upMove.name = "upButton"
//        upMove.position = CGPoint(x: ((scene?.size.width)! * 0.40), y: -((scene?.size.height)! * 0.3))
//        upMove.size = CGSize (width: 70, height: 70)
//        upMove.zPosition = 3
//
//        leftMove.name = "leftMove"
//        leftMove.position = CGPoint(x: -((scene?.size.width)! * 0.39), y: -((scene?.size.height)! * 0.3))
//        leftMove.size = CGSize (width: 70, height: 70)
//        leftMove.zPosition = 3
//
//        rightMove.name = "rightMove"
//        rightMove.position = CGPoint(x: -((scene?.size.width)! * 0.29), y: -((scene?.size.height)! * 0.3))
//        rightMove.size = CGSize (width: 70, height: 70)
//        rightMove.zPosition = 3
//
//        cam.addChild(upMove)
//        cam.addChild(leftMove)
//        cam.addChild(rightMove)
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
                if ((touch.tapCount) <= 2) {
                    bilbo.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 140.0))
                }
            }
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
        bilbo.position = CGPoint(x: -200, y: 0)
        bilbo.zPosition = 3
        bilbo.size = CGSize(width: ((scene?.size.width)! * 0.20), height: ((scene?.size.height)! * 0.25))
        
        //settings cat physics body
        for i in 1...numImages {
            let bilboPhysicsBody = SKPhysicsBody(texture: bilboWalkingFrames[i - 1], size: bilbo.size)
            bilboPhysicsBody.isDynamic = true
            bilboPhysicsBody.affectedByGravity = true
            bilboPhysicsBody.allowsRotation = false
            self.bilbo.physicsBody = bilboPhysicsBody
        }
        
        addChild(bilbo)
    }
    
    func animateBilbo() {
        bilbo.run(SKAction.repeatForever(SKAction.animate(with: bilboWalkingFrames, timePerFrame: 0.1, resize: false, restore: true)), withKey:"walkingInPlaceCat")
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
//        if leftMoveIsPressed == true {
//            let moveUp = SKAction.move(by: CGVector(dx: -4, dy: 0), duration: 0.1)
//            let sequence = SKAction.sequence([moveUp])
//            bilbo.run(sequence)
//            }
//
//           if rightMoveIsPressed == true {
//            let moveUp = SKAction.move(by: CGVector(dx: 4, dy: 0), duration: 0.1)
//            let sequence = SKAction.sequence([moveUp])
//            bilbo.run(sequence)
//            }
//        self.camera?.position = bilbo.position
    }
}
