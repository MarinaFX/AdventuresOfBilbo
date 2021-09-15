//
//  Score.swift
//  AdventuresOfBilbo
//
//  Created by João Gabriel Biazus de Quevedo on 15/09/21.
//

import SpriteKit
//MARK:- Score Class

class HudNode : SKNode {
  private let scoreKey = "RAINCAT_HIGHSCORE"
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
    scoreNode.position = CGPoint(x: -350, y: 150)
    scoreNode.zPosition = 5

    addChild(scoreNode)
  }
}
