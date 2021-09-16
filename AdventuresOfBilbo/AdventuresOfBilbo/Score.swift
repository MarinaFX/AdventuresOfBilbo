//
//  Score.swift
//  AdventuresOfBilbo
//
//  Created by João Gabriel Biazus de Quevedo on 15/09/21.
//

import SpriteKit
//MARK:- Score Class

class HudNode : SKNode {
    private let scoreKey = "RUNCAT_HIGHSCORE"
    private let scoreNode = SKLabelNode(fontNamed: "PixelDigivolve")
    private(set) var score : Int = 0
    private var highScore : Int = 0
    private var showingHighScore = false
    
    //Setup hud here
    public func setup(size: CGSize) {
        let defaults = UserDefaults.standard
        
        highScore = defaults.integer(forKey: scoreKey)
        
        scoreNode.text = "\(score)"
        scoreNode.fontSize = 40
        scoreNode.position = CGPoint(x: 0, y: 140)
        scoreNode.zPosition = 5
        
        addChild(scoreNode)
    }
    func addPoint() {
        score += 1
        
        updateScoreboard()
        
        if score > highScore {
            
            let defaults = UserDefaults.standard
            
            defaults.set(score, forKey: scoreKey)
            
            if !showingHighScore {
                showingHighScore = true
                
                scoreNode.run(SKAction.scale(to: 1.5, duration: 0.25))
            }
        }
    }
    
    public func resetPoints() {
        score = 0
        
        updateScoreboard()
        
        if showingHighScore {
            showingHighScore = false
            
            scoreNode.run(SKAction.scale(to: 1.0, duration: 0.25))
            scoreNode.fontColor = SKColor.white
            
        }
    }
    
    private func updateScoreboard() {
        scoreNode.text = "\(score)"
    }
}

