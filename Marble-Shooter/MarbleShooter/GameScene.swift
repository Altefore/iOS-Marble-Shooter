//
//  GameScene.swift
//  iOSProject2016
//
//  Created by Jonathan Light on 10/25/16.
//  Copyright © 2016 Jonathan Light. All rights reserved.
//

import SpriteKit
import GameplayKit


let BallCategoryName = "ball"

class GameScene: SKScene {
    
    var level: Level!
    
    let TileWidth: CGFloat = 37.0
    let TileHeight: CGFloat = 40.0
    
    let gameLayer = SKNode()
    let ballsLayer = SKNode()
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.94, y: 0.905)
        
        // Put an image on the background. Because the scene's anchorPoint is
        // (0.5, 0.5), the background image will always be centered on the screen.
        //let background = SKSpriteNode(imageNamed: "Background")
        //background.size = size
        //addChild(background)
        
        // Add a new node that is the container for all other layers on the playing
        // field. This gameLayer is also centered in the screen.
        addChild(gameLayer)
        
        let layerPosition = CGPoint(
            x: -TileWidth * CGFloat(NumColumns),// / 2,
            y: -TileHeight * CGFloat(NumRows))   // / 2)
        
        // The tiles layer represents the shape of the level. It contains a sprite
        // node for each square that is filled in.
        //tilesLayer.position = layerPosition
        //gameLayer.addChild(tilesLayer)
        
        // This layer holds the ball sprites. The positions of these sprites
        // are relative to the ballsLayer's bottom-left corner.
        ballsLayer.position = layerPosition
        gameLayer.addChild(ballsLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSprites(for balls: Set<Ball>) {
        for ball in balls {
            let sprite = SKSpriteNode(imageNamed: ball.ballType.spriteName)
            sprite.size = CGSize(width: TileWidth, height: TileHeight)
            sprite.position = pointFor(column: ball.column, row: ball.row)
            ballsLayer.addChild(sprite)
            ball.sprite = sprite
        }
    }
    
    func pointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*TileWidth + TileWidth, ///2,
            y: CGFloat(row)*TileHeight + TileHeight)// /2)
    }
    
    override func didMove(to view: SKView) {
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
