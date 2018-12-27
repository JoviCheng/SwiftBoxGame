//
//  GameViewController.swift
//  Box
//
//  Created by JoviCheng on 2018/12/25.
//  Copyright © 2018年 JoviCheng. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

   let scene = SKScene(fileNamed: "GameScene")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
//            if let scene = SKScene(fileNamed: "GameScene") {
//                // Set the scale mode to scale to fit the window
//                scene.scaleMode = .resizeFill
//
//                // Present the scene
//                view.presentScene(scene)
//            }

            // Set the scale mode to scale to fit the window
            self.scene?.scaleMode = .aspectFit
            self.scene?.backgroundColor = .black
            
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
