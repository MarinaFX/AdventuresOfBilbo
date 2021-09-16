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
    
    //MARK: GameScene Variables
    private var backgroundsCount = 0
    private var originalBilboPosY: CGFloat = 0

    //MARK:- GameScene Init
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    
        buildBilbo()
        animateBilbo()
        createScenery()
        setSceneryPhysics()
        score.setup(size: size)
        addChild(score)
        createBackground(idealPosX: 0)
        startCount()
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
        
        //settings cat physics body
        for i in 1...numImages {
            let bilboPhysicsBody = SKPhysicsBody(texture: bilboWalkingFrames[i - 1], size: bilbo.size)
            bilboPhysicsBody.isDynamic = true
            bilboPhysicsBody.affectedByGravity = true
            bilboPhysicsBody.allowsRotation = false
            bilboPhysicsBody.restitution = 0.0
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
//    func generateRandomFloorObstacles() {
//        guard let sceneSize = scene?.size else { return }
//        let randomTime: [TimeInterval] = [0.22, 0.56, 0.65, 0.45, 0.5, 0.3, 0.]
//        
//    }
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
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        animateBackground()
    }
}
