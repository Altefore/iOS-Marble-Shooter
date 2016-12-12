//
//  GameScene.swift
//  iOSProject2016
//
//  Created by Jonathan Light on 10/25/16.
//  Copyright © 2016 Jonathan Light. All rights reserved.
//

import SpriteKit
import GameplayKit


/* TODO:
 create game states,
 boolean for ball being shot,
 create queue for random balls
 Change the points and positions to fit frame
 
*/

/*NOTES
 Offset for Y position increment = 51
 
 
 */

var tapQueue = [Int]()

let offsets = [-1, 0, 1]
var chain = [Ball]()

let RedBallCategoryName = "redBall"
let GreenBallCategoryName = "greenBall"
let YellowBallCategoryName = "yellowBall"
let OrangeBallCategoryName = "orangeBall"
let BlueBallCategoryName = "blueBall"
let CyanBallCategoryName = "tealBall"
let PurpleBallCategoryName = "purpleBall"
let CannonCategoryName = "cannon"
let GameMessageCategoryName = "gameMessage"
let ScoreLabelCategoryName = "label"
let PauseButtonCategoryName = "pauseButton"

let ShootingCatagoryName = "marble"
let StasisCatagoryName = "stasisMarble"

var marbleCounter = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    //might need to delete this.
    fileprivate var balls = Matrix<Ball>(rows: NumRows, columns: NumColumns)
    
    var level: Level!
    
    var ballToBeShot: Ball!
    let shootingPosition = CGPoint(x: 0.0, y: -440.0)
    
    let TileWidth: CGFloat = 37.0
    let TileHeight: CGFloat = 40.0
    
    
    let gameLayer = SKNode()
    let ballsLayer = SKNode()
    
//Jons Code
    
    //Contact  CategoryMasks
    let ShootingBallCategory: UInt32 = 0x1 << 0
    let StasisCategory      : UInt32 = 0x1 << 1
    let FallingCategory     : UInt32 = 0x1 << 2
    let HoleBottomCategory  : UInt32 = 0x1 << 3
    let BottomCategory      : UInt32 = 0x1 << 4
    let CeilingCategory     : UInt32 = 0x1 << 5
    
    let marbleWidth = SKSpriteNode(imageNamed: "redBall").size.width
    
    let yOffset = CGFloat(51.0)
    let xOffset = CGFloat(30.0)
     
    let marbleCatagoryNameList = [RedBallCategoryName,GreenBallCategoryName, YellowBallCategoryName,
     OrangeBallCategoryName, BlueBallCategoryName, CyanBallCategoryName, PurpleBallCategoryName]
     
    var gamePaused = false
    var readyToShoot = true
 
//Jons Code End
    
//    
//    override init(size: CGSize) {
//        super.init(size: size)
//        
//        anchorPoint = CGPoint(x: 0.94, y: 0.905)
//        
//        // Put an image on the background. Because the scene's anchorPoint is
//        // (0.5, 0.5), the background image will always be centered on the screen.
//        //let background = SKSpriteNode(imageNamed: "Background")
//        //background.size = size
//        //addChild(background)
//        self.scene?.backgroundColor = SKColor.white
//        // Add a new node that is the container for all other layers on the playing
//        // field. This gameLayer is also centered in the screen.
//        addChild(gameLayer)
//        
//        let layerPosition = CGPoint(
//            x: -TileWidth * CGFloat(NumColumns),// / 2,
//            y: -TileHeight * CGFloat(NumRows))   // / 2)
//        
//        // The tiles layer represents the shape of the level. It contains a sprite
//        // node for each square that is filled in.
//        //tilesLayer.position = layerPosition
//        //gameLayer.addChild(tilesLayer)
//        
//        // This layer holds the ball sprites. The positions of these sprites
//        // are relative to the ballsLayer's bottom-left corner.
//        ballsLayer.position = layerPosition
//        
//        gameLayer.addChild(ballsLayer)


/* Not sure we need this
        let cannonSprite = SKSpriteNode(imageNamed: "cannonSprite.png")
        cannonSprite.size = CGSize(width: 180, height: 185)
        cannonSprite.position = CGPoint(x:-165, y:-550.0)
        cannonSprite.zPosition = 2
        gameLayer.addChild(cannonSprite)

*/
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
//Jons Code Begin
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        print("FRAME MAX X = \(frame.maxY)")
        
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: frame)
        borderBody.friction = 0
        borderBody.restitution = 1
        self.physicsBody = borderBody
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        //
        //ball.physicsBody!.contactTestBitMask = BottomCategory
        
        
        
        //addChild(marble)
        
        let leftRect = CGRect(x: -345, y: -613.5, width: 1, height: 1227)
        let left = SKNode()
        left.physicsBody = SKPhysicsBody(edgeLoopFrom: leftRect)
        addChild(left)
        //        let bottomRect = CGRect(x: frame.minX, y: frame.minY, width: frame.size.width, height: 1)
        //        let bottom = SKNode()
        //        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        //        addChild(bottom)
        //
        //        let ceilingRect = CGRect(x: frame.minX, y: frame.maxY, width: frame.size.width, height: 1)
        //        let ceiling = SKNode()
        //        ceiling.physicsBody = SKPhysicsBody(edgeLoopFrom: ceilingRect)
        //        addChild(ceiling)
        //
        //bottom.physicsBody!.categoryBitMask = BottomCategory
        //        ceiling.physicsBody!.categoryBitMask = CeilingCategory
        //
        //        newmarble()
        //
        spawnMarbles()
        newGameClassic()
        
        
    }
    
    func newGameClassic(){
        newmarble()
    }
    
    func spawnMarbles(){
        let numberOfMarbles = NumRows * NumColumns
        
        //Should change this to fit the frame
        let spawnStartPosition: CGPoint = CGPoint(x: frame.minX + marbleWidth/2, y: frame.maxY - marbleWidth/2)
        let startPositionX = spawnStartPosition.x//CGFloat(-315.0)
        let startPositionY = spawnStartPosition.y//CGFloat(583.5)
        //var row = -1
        var offset: Bool
        var i = -1
        //NumRow and NumColumns come from Level.swift
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                i += 1
                //let rand = getRandomNumber(number: 7)
                var ballType = BallType.random()
                if(row % 2 == 0){
                    offset = false
                }
                else {
                    offset = true
                }
                let ball = Ball( row: row, column: column, offset: offset, ballType: ballType, position: spawnStartPosition)
                ball.sprite = SKSpriteNode(imageNamed: ball.ballType.spriteName)
                let marble = ball.sprite
                balls[row, column] = ball
                //let marble = SKSpriteNode(imageNamed: marbleCatagoryNameList[rand] + ".png")
                marble?.position = pointFor(row: ball.row, col: ball.column)
                
                print("Grid Position(row,col) = \(gridFor(point:(marble?.position)!, offset: ball.offset ))")

                ball.position = (marble?.position)!
                marble?.physicsBody = SKPhysicsBody(circleOfRadius: marbleWidth/2)
                marble?.physicsBody!.allowsRotation = false
                marble?.physicsBody!.friction = 0.0
                marble?.physicsBody!.affectedByGravity = true
                marble?.physicsBody!.isDynamic = false
                marble?.name = StasisCatagoryName
                marble?.physicsBody!.categoryBitMask = StasisCategory
                marble?.physicsBody!.contactTestBitMask = ShootingBallCategory
                marble?.zPosition = 2
                addChild(marble!)
                
            }
        }
        print("Grid: \(balls)")
        print("Ball[1,1] offset = \(balls[1,1]?.offset)")
    }
    
    func newmarble(){
        
        let rand = getRandomNumber(number: 7)
        
        let marble = SKSpriteNode(imageNamed: marbleCatagoryNameList[rand] + ".png")
        marble.position = shootingPosition
        print("Marble Texture = \(marble.texture)")
        marble.physicsBody = SKPhysicsBody(circleOfRadius: marbleWidth/2, center: marble.position)
        //        marble.physicsBody!.contactTestBitMask = StasisCategory
        //        marble.physicsBody!.contactTestBitMask = CeilingCategory
        
        marble.zPosition = 2
        
        marble.physicsBody!.categoryBitMask = ShootingBallCategory
        
        
        marble.physicsBody!.allowsRotation = false
        marble.physicsBody!.friction = 0.0
        marble.physicsBody!.affectedByGravity = true
        marble.physicsBody!.isDynamic = false
        marble.name = ShootingCatagoryName//marbleCatagoryNameList[rand]
        marble.physicsBody!.categoryBitMask = ShootingBallCategory
        marble.zPosition = 2
        //marble.physicsBody!.applyForce(CGVector(dx: 0.0, dy: 10.0))
        addChild(marble)
        readyToShoot = true
        
    }
    
    func shootMarble(atPoint pos : CGPoint){
        if readyToShoot {
            if let marble = childNode(withName: ShootingCatagoryName) as! SKSpriteNode?{
                marble.physicsBody = SKPhysicsBody(circleOfRadius: marbleWidth/2)
                marble.physicsBody!.categoryBitMask = ShootingBallCategory
                marble.physicsBody!.friction = 0
                marble.physicsBody!.restitution = 1
                marble.physicsBody!.linearDamping = 0
                marble.physicsBody!.angularDamping = 0
                marble.physicsBody!.usesPreciseCollisionDetection = true
                let x = (pos.x)
                let y = (pos.y) - shootingPosition.y
                let hypotenus = sqrt(x*x + y*y)
                //Default Speed 150.0
                let xVector = (x/hypotenus)*100.0
                let yVector = (y/hypotenus)*100.0
                if yVector > 0 {
                    marble.physicsBody!.applyImpulse(CGVector(dx: xVector, dy: yVector))
                    readyToShoot = false
                }
            }
        }
        else {
            if let node = childNode(withName: ShootingCatagoryName) as! SKSpriteNode?{
                node.removeFromParent()
            }
            newmarble()
        }
    }
    
    func freezemarble(freezePosition: CGPoint){
        
        if let marble = childNode(withName: ShootingCatagoryName) as! SKSpriteNode?{
            //            let newStasisMarble = childNode(withName: StasisCatagoryName) as! SKSpriteNode
            //            newStasisMarble.texture = marble.texture
            //            newStasisMarble.physicsBody = SKPhysicsBody(circleOfRadius: marbleWidth/2)
            
            let newPosition : CGPoint = fitMarbleToGrid(contactPoint: freezePosition)
            
            print("Shooting Marble Position = \(marble.position)")
            marble.position = newPosition
            print("New Position = \(marble.position)")
            
            marble.physicsBody = SKPhysicsBody(circleOfRadius: marbleWidth/2)
            marble.physicsBody!.allowsRotation = false
            marble.physicsBody!.friction = 0.0
            marble.physicsBody!.affectedByGravity = true
            marble.physicsBody!.isDynamic = false
            
            marble.name = StasisCatagoryName
            marble.physicsBody!.categoryBitMask = StasisCategory
            marble.physicsBody!.contactTestBitMask = ShootingBallCategory
            
            //doDFS(balls, marble.row, marble.column, marble)
            //print("MARBLE TEXTURE: \(marble.texture?.description.components(separatedBy: "'")[1].components(separatedBy: ".")[0])")
            //print("Shooting Marble Location = \(marble.position)")
            
        }
        
    }
    
    func pointFor(row: Int, col:Int) ->CGPoint {
        if (row % 2 == 0){
            return CGPoint(x: -315.0 + (60 * CGFloat(col)), y: 583.5 - (51 * CGFloat(row)))
        }
        return CGPoint(x: -285.0 + (60 * CGFloat(col)), y: 583.5 - (51 * CGFloat(row)))
    }
    
    func gridFor(point: CGPoint, offset: Bool) -> (row: Int, column: Int){
        var column = point.x.rounded()
        var row = point.y.rounded()
        if(offset){
            column = column + 315
            column = column/xOffset
        }
        else{
            column = column + 345
            column = column/xOffset
        }
        row = row - 613.5
        row = -(row/yOffset)
        
        column = column + 1
        column = column / 2
        
        return (Int(row), Int(column))
    }
    
    func fitMarbleToGrid(contactPoint: CGPoint) -> CGPoint {
        let spawnStartPosition: CGPoint = CGPoint(x: frame.minX + marbleWidth, y: frame.maxY - marbleWidth)
        var newPosition : CGPoint = contactPoint
       
        //makes the math easier
        var yPos = contactPoint.y - frame.maxY
        var xPos = contactPoint.x + frame.maxX
        print("yPosition before = \(yPos)")
        //calculate closest yPos
        
        yPos = (floor((yPos + marbleWidth)/yOffset) - 1)*yOffset - marbleWidth/2
        print("yPosition after = \(yPos)")
        yPos += frame.maxY
        newPosition.y = yPos
        //print("Full x = \(xPos)")
        //calculate closest xPos
        //TODO: use the yposition to determine offset rows
        //print("xPosition before = \(xPos.remainder(dividingBy: marbleWidth))")
        
        if ((xPos.remainder(dividingBy: marbleWidth))  <= 30){
            xPos -= xOffset
        }
        else {
            xPos += xOffset

        }
        //print("xPosition after = \(xPos.remainder(dividingBy: marbleWidth))")

        xPos -= frame.maxX
        newPosition.x = xPos
        
        return newPosition
        
    }
    
    func breakMarble(node: SKNode) {
        
        //if gameState.currentState is Playing {
        //self.score += 10
        //let particles = SKEmitterNode(fileNamed: "BrokenPlatform")!
        //particles.position = node.position
        //particles.zPosition = 3
        //addChild(particles)
        //particles.run(SKAction.sequence([SKAction.wait(forDuration: 1.0),
        //SKAction.removeFromParent()]))
        //}
        node.removeFromParent()
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        // 2
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        // 3
        if firstBody.categoryBitMask == ShootingBallCategory && secondBody.categoryBitMask == BottomCategory {
            print("Hit ceiling. First contact has been made.")
        }
        if firstBody.categoryBitMask == ShootingBallCategory && secondBody.categoryBitMask == StasisCategory {
            print("Hit marble secondBody \(secondBody.node!.position)")
            //print("Hit marble firstBody \(firstBody.node!.position)")
            freezemarble(freezePosition: secondBody.node!.position)
            
        }
        else {
            print("first body: \(firstBody)")
            print("secondBody : \(secondBody)")
        }
    }
    
    
    
    func getRandomNumber(number: UInt32) -> Int{
        let rand = Int(arc4random_uniform(number))
        return rand
    }
    
    func neighborExists(matrix: Matrix<Ball>, row: Int, col: Int, ball: Ball) -> Bool {
    
        if( (row >= 0) && (row < matrix.rows) && (col >= 0) && (col < matrix.columns) ){
            //check the color of the ball and compare it
            if( matrix[row, col]?.ballType == ball.ballType ){
                return true
            }
        }
        return false

    }
    
    //check chains length then loop through if larger than 2 and delete all Balls in matrix that are in the chain.
    func doDFS(matrix: Matrix<Ball>, row: Int, col: Int, ball: Ball){
    
        for i in 0..<offsets.count {
            let xOff = offsets[i]
            for j in 0..<offsets.count {
                let yOff = offsets[j]
                
                //don't count itself as its own neighbor as well as top-left & bottom-left
                if( (xOff == 0 && yOff == 0) || (xOff == 1 && yOff == -1) || (xOff == -1 && yOff == -1) ){
                    continue
                }
                if(neighborExists(matrix: matrix, row: i+yOff, col: j+xOff, ball: ball)){
                    chain.append(matrix[i+yOff, j+xOff]!)
                    doDFS(matrix: matrix, row: i+yOff, col: j+xOff, ball: ball)
                }
            }
        }
    }
        
    func touchDown(atPoint pos : CGPoint) {
        //                if let n = self.spinnyNode?.copy() as! SKShapeNode? {
        //                    n.position = pos
        //                    n.strokeColor = SKColor.green
        //                    self.addChild(n)
        //                }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        //        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
        //            n.position = pos
        //            n.strokeColor = SKColor.blue
        //            self.addChild(n)
        //        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        //this creates a new node and we dont want that. we want to use the existing marbleNode
        shootMarble(atPoint: pos)
        
        
        //        if waitingToShoot {
        //            //let marble = self.childNode(withName: ShootingCatagoryName) as! SKSpriteNode
        //            let marble = self.childNode(withName: "redBall") as! SKSpriteNode
        //
        //            marble.physicsBody = SKPhysicsBody(circleOfRadius: marbleWidth/2, center: marble.position)
        //            marble.physicsBody!.categoryBitMask = ShootingBallCategory
        //
        //
        //            marble.physicsBody!.allowsRotation = false
        //            marble.physicsBody!.friction = 0.0
        //            marble.physicsBody!.affectedByGravity = false
        //            //marble.physicsBody!.isDynamic = false
        //            let x = (pos.x)
        //            let y = (pos.y) - shootingPosition.y
        //            let hypotenus = sqrt(x*x + y*y)
        //            let xVector = (x/hypotenus)*150.0
        //            let yVector = (y/hypotenus)*150.0
        //            marble.physicsBody!.applyImpulse(CGVector(dx: xVector, dy: yVector))
        //            //marble.position = pos
        ////            marble.physicsBody!.velocity.dx = xVector
        ////            marble.physicsBody!.velocity.dy = yVector
        //            print("Shooting Marble Color: \(marble.texture)")
        //        }
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        if let label = self.label {
        //            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        //        }
        //
        //        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        if let body = physicsWorld.body(at: touchLocation) {
            if body.node!.name == PauseButtonCategoryName {
                print("PauseButtonTouched")
                gamePaused = true
            }
        }
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}


//Jons Code End
    


/*
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
}*/
