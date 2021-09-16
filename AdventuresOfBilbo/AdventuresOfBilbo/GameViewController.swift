//
//  GameViewController.swift
//  AdventuresOfBilbo
//
//  Created by Marina De Pazzi on 10/09/21.
//

import UIKit
import SpriteKit
import GameplayKit
import ARKit

class GameViewController: UIViewController, ARSessionDelegate {
    
    var session:ARSession!
    var scene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let screenSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            scene = GameScene(size: screenSize)
            // let scene = CatAnimation(size: view.bounds.size)
            // scene.scaleMode = .resizeFill
            
            scene.scaleMode = .resizeFill
            
            // Present the scene
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = false
            
            session = ARSession()
            session.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard ARFaceTrackingConfiguration.isSupported else {print("iPhone X or superior is required to run the app"); return}
        
        let configuration = ARFaceTrackingConfiguration()
        
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
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
    
    
    // MARK: ARSession Delegate
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        if let faceAnchor = anchors.first as? ARFaceAnchor {
            update(withFaceAnchor: faceAnchor)
        }
    }
    
    
    func update(withFaceAnchor faceAnchor: ARFaceAnchor) {
        var bledShapes:[ARFaceAnchor.BlendShapeLocation:Any] = faceAnchor.blendShapes
        
        guard let browInnerUp = bledShapes[.browInnerUp] as? Float else {return}
        print(browInnerUp)
        
        if browInnerUp > 0.70 {
            scene.updatePlayer()
        }
    }
}
