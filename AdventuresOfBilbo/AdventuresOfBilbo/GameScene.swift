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
    
    private var floor = SKShapeNode()
    private var wall = SKShapeNode()
    private var midFloor = SKShapeNode()
    private var ceiling = SKShapeNode()
    
    //MARK: GameScene Variables
    private var floorSize = CGSize(width: 0, height: 0)
    
    //MARK: GameScene Init
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        floorSize = CGSize(width: (scene?.size.width)!, height: 20)
        
        createScenery()
        setSceneryPhysics()
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
