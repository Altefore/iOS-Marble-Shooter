//
//  GameScene.swift
//  iOSProject2016
//
//  Created by Jonathan Light on 10/25/16.
//  Copyright © 2016 Jonathan Light. All rights reserved.
//

import SpriteKit
import GameplayKit


var tapQueue = [Int]()


let ShootingBallCategory   : UInt32 = 0x1 << 0
let BallCategory           : UInt32 = 0x1 << 1

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var level: Level!
    
    var ballToBeShot: Ball!
    let shootingPosition = CGPoint(x: 0.0, y: -440.0)
    
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
        self.scene?.backgroundColor = SKColor.white
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

        let cannonSprite = SKSpriteNode(imageNamed: "cannonSprite.png")
        cannonSprite.size = CGSize(width: 180, height: 185)
        cannonSprite.position = CGPoint(x:-165, y:-550.0)
        cannonSprite.zPosition = 2
        gameLayer.addChild(cannonSprite)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSprites(for balls: Set<Ball>) {
        for ball in balls {
            let sprite = SKSpriteNode(imageNamed: ball.ballType.spriteName)

            sprite.size = CGSize(width: TileWidth, height: TileHeight)
            sprite.position = pointFor(column: ball.column, row: ball.row)
            sprite.physicsBody?.categoryBitMask = UInt32(0x1 << 2)
            sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width/2)
            sprite.physicsBody?.affectedByGravity = false
            sprite.physicsBody?.isDynamic = false
            
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
        var ballType = BallType.random()
        ballToBeShot = Ball(column: 99, row: 99, ballType: ballType)
        let ballToBeShotSprite = SKSpriteNode(imageNamed: ballToBeShot.ballType.spriteName)
        ballToBeShotSprite.size = CGSize(width: TileWidth, height: TileHeight)
        ballToBeShotSprite.position = CGPoint(x: -164, y:-513)
        
        ballToBeShot.sprite = ballToBeShotSprite

        ballToBeShot.sprite?.physicsBody = SKPhysicsBody(texture: (ballToBeShot.sprite?.texture!)!, size: (ballToBeShot.sprite?.texture!.size())!)
        ballToBeShot.sprite?.physicsBody?.usesPreciseCollisionDetection = true
        
        if(ballToBeShot.sprite?.physicsBody?.isResting)!{
            ballToBeShot.sprite?.physicsBody?.allowsRotation = false
        }
        ballToBeShot.sprite?.physicsBody?.categoryBitMask = UInt32(0x1 << 1)
        ballToBeShot.sprite?.physicsBody!.contactTestBitMask = UInt32(0x1 << 2)
        ballToBeShot.sprite?.physicsBody = SKPhysicsBody(circleOfRadius: (ballToBeShot.sprite?.size.width)!/2)
        ballToBeShot.sprite?.physicsBody?.affectedByGravity = false
        gameLayer.addChild(ballToBeShot.sprite!)
        
        createSceneContents()
    }

    func createSceneContents() {
        self.scaleMode = .aspectFit
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
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
        if let touch = touches.first {
            if (touch.tapCount == 1) {
                tapQueue.append(1)
            }
            // Get the position that was touched.
            let touchPosition = touch.location(in: self)
    
            let vector = CGVector(dx:touchPosition.x - (-164), dy:touchPosition.y - (-513))
            ballToBeShot.sprite?.physicsBody?.applyImpulse(vector)
            ballToBeShot.sprite?.physicsBody?.affectedByGravity = false
            
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
