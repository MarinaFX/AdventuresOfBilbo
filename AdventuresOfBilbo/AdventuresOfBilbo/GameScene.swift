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
    private var background: SKSpriteNode = SKSpriteNode()
    
    var touchUP = SKSpriteNode()
    private var score = HudNode()
    
    //MARK: GameScene Variables
    private var backgroundsCount = 0
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
