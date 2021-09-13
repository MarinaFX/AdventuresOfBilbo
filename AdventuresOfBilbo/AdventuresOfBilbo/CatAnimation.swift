//
//  GameScene.swift
//  AdventuresOfBilbo
//
//  Created by Marina De Pazzi on 10/09/21.
//

import SpriteKit
import GameplayKit


class CatAnimation: SKScene {
    
    private var cat = SKSpriteNode()
    private var catWalkingFrames: [SKTexture] = []
    
    override func didMove(to view: SKView) {
        backgroundColor = .blue
        buildCat()
        animateCat()
    }
    
    func buildCat() {
        let catAnimatedAtlas = SKTextureAtlas(named: "CatMovement")
        var walkFrames: [SKTexture] = []
        
        let numImages = catAnimatedAtlas.textureNames.count
        for i in 1...numImages {
            let catTextureName = "gato_\(i)"
            walkFrames.append(catAnimatedAtlas.textureNamed(catTextureName))
        }
        catWalkingFrames = walkFrames
        
        let firstFrameTexture = catWalkingFrames[0]
        cat = SKSpriteNode(texture: firstFrameTexture)
        cat.position = CGPoint(x: self.size.width, y: self.size.height)
        addChild(cat)
    }
    func animateCat() {
        cat.run(SKAction.repeatForever(
                    SKAction.animate(with: catWalkingFrames,
                                     timePerFrame: 0.1,
                                     resize: false,
                                     restore: true)),
                withKey:"walkingInPlaceCat")
    }
}


