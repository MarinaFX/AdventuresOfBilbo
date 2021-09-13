//
//  GameViewController.swift
//  AdventuresOfBilbo
//
//  Created by Marina De Pazzi on 10/09/21.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let screenSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            let scene = GameScene(size: screenSize)
            // let scene = CatAnimation(size: view.bounds.size)
            // scene.scaleMode = .resizeFill

            scene.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
}
