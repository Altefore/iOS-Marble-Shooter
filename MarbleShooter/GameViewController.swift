//
//  GameViewController.swift
//  iOSProject2016
//
//  Created by Jonathan Light on 10/25/16.
//  Copyright © 2016 Jonathan Light. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var scene: GameScene!
    var level: Level!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //JONS CODE
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                let transition = SKTransition.fade(withDuration: 3)
                // Present the scene
                view.presentScene(scene, transition: transition)
            }
            
            view.ignoresSiblingOrder = true
            //GOOD FOR VIEWING THE PHYZICZ
            //view.showsPhysics = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        //SAMS CODE
        /*
        
        // Configure the view.
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        // Load the level.
        level = Level(filename: "level2")
        scene.level = level
    
        //scene.addTiles()
        skView.presentScene(scene)
        
        beginGame()*/
    }
    
    func beginGame() {
        //shuffle()
    }
    
    func shuffle() {
        //let newBalls = level.shuffle()
       // scene.addSprites(for: newBalls)
    }
    
     /*func handleMatches() {
        let chains = level.removeMatches()
        
        /*scene.animateMatchedBalls(for: chains) {
            self.view.isUserInteractionEnabled = true
        }*/
    }*/

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
