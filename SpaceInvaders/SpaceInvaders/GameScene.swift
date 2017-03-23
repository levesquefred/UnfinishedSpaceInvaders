//
//  GameScene.swift
//  SpaceInvaders
//
//  Created by Levesque Frederic on 3/8/17.
//  Copyright © 2017 Levesque Frederic. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    enum InvaderMovementDirection {
        case right
        case left
        case downThenRight
        case downThenLeft
        case none
    }
    
    enum InvaderType{
        case a
        case b
        case c
        
        static var size: CGSize {
            return CGSize(width: 24, height: 12)
        }
        
        static var name: String{
            return "invader"
        }
    }
    
    
    let kInvaderRowCount = 6
    let kInvaderColumn = 6
    let kInvaderGridSpacing = CGSize(width: 12, height: 12)
    
    let kShipSize = CGSize(width: 30, height: 16)
    let kShipName = "ship"
    
    let kScoreHudName = "scoreHud"
    let kHealthHud = "healthHud"
    
    var contenCreated = false
    
    func createContent(){
        
        setupInvaders()
        setupShip()
        setupHud()
        //and so forth
        
    }
    
    func setupShip(){
        let ship = makeShip()
        ship.position = CGPoint(x: size.width / 2.0, y: kShipSize.height / 2.0)
        addChild(ship)
    }
    
    func makeShip() -> SKNode {
        let ship = SKSpriteNode(color: SKColor.green, size: kShipSize)
        ship.name = kShipName
        
        //1
        ship.physicsBody = SKPhysicsBody(rectangleOf: ship.frame.size)
        //2
        ship.physicsBody!.isDynamic = true
        //3
        ship.physicsBody!.affectedByGravity = false
        //4
        ship.physicsBody!.mass = 0.02
        
        return ship
    }
    
    func setupHud(){
        //1
        let scoreLabel = SKLabelNode(fontNamed: "Courier")
        scoreLabel.name = kScoreHudName
        scoreLabel.fontSize = 25
        //2
        scoreLabel.fontColor = SKColor.green
        //depending on the number you put in "%04u" you can change the mount of zeros for score
        scoreLabel.text = String(format: "Score: %04u",0)
        //3
        scoreLabel.position = CGPoint(
            x: frame.size.width / 2,
            y: size.height - (40 + scoreLabel.frame.size.height/2)
        )
        //add this for scoreLbael to show up
        addChild(scoreLabel)
    }
    
    override func didMove(to view: SKView) {
        
        if (!self.contenCreated){
            createContent()
            self.contenCreated = true;
        }
    }
        
        func makeInvader(ofType invaderType: InvaderType) -> SKNode {
            
            var invaderColor:SKColor
            
            switch(invaderType){
            case .a:
                invaderColor = SKColor.red
            case .b:
                invaderColor = SKColor.green
            case .c:
                invaderColor = SKColor.blue
            }
            
            
            let invader = SKSpriteNode(color: invaderColor, size: InvaderType.size)
            invader.name = InvaderType.name
            return invader
        }
    
    func setupInvaders(){
        
        let baseOrigin = CGPoint(x: size.width/3, y: size.height/2)
        
        for row in 0..<kInvaderRowCount {
            
            var invaderType: InvaderType
            
            if row % 3 == 0 {
                invaderType = .a}
            else if row % 3 == 1{
                invaderType = .b
            }
            else{
                invaderType = .c
            }
                
            let invaderPositionY = CGFloat(row) * (InvaderType.size.height * 2) + baseOrigin.y
            var invaderPosition = CGPoint(x: baseOrigin.x, y: invaderPositionY)
            
            for _ in 1..<kInvaderRowCount{
                print(invaderType)
                
                let invader = makeInvader(ofType: invaderType)
                invader.position = invaderPosition
                print(invaderPosition)
                addChild(invader)
                //invaderPosition = CGPoint(x: invaderPosition.x + invaderType.size.width + kInvaderGridSpacing.width, y: invaderPositionY)
                invaderPosition = CGPoint(x: invaderPosition.x + InvaderType.size.width + kInvaderGridSpacing.width, y: invaderPositionY)
            }
        }
        
        }
    
//    func touchDown(atPoint pos : CGPoint) {
//        
//    }
//    
//    func touchMoved(toPoint pos : CGPoint) {
//        
//    }
//    
//    func touchUp(atPoint pos : CGPoint) {
//        
//    }
//    
//    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        
//    }
//    
//     func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//     
//    }
//    
//    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//       
//    }
//    
//     func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//      
//    }
    
    
   override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    moveInvaders(forUpdate: currentTime)
    processUserTaps(forUpdate: currentTime)
   }
    
    //1 
    var invaderMovementDirection: InvaderMovementDirection = .right
    //2
    var timeOfLastMove: CFTimeInterval = 0.0
    //3
    let timePerMove: CFTimeInterval = 1.0

    func moveInvaders(forUpdate currentTime: CFTimeInterval){
        //1
        if ((currentTime - timeOfLastMove) < timePerMove){
            print("thinking")
            return
        }
        determineInvaderMovementDirection()
        
        //2 
        enumerateChildNodes(withName: InvaderType.name) {node, stop in
            switch self.invaderMovementDirection{
            case .right:
                node.position = CGPoint(x: node.position.x + 10, y: node.position.y)
            case .left:
                node.position = CGPoint(x: node.position.x - 10, y: node.position.y)
            case .downThenLeft, .downThenRight:
                node.position = CGPoint(x: node.position.x, y: node.position.y - 10)
            case .none:
                break
            }
            
        }
        print("Do Work")
        self.timeOfLastMove = currentTime
    }
    
    func determineInvaderMovementDirection() {
        //1
        var proposedMovementDirection: InvaderMovementDirection = invaderMovementDirection
        
        //2
        enumerateChildNodes(withName: InvaderType.name) {node, stop in
            switch self.invaderMovementDirection{
            case .right:
                //3
                    if (node.frame.maxX >= node.scene!.size.width - 1.0){
                        proposedMovementDirection = .downThenLeft
                        stop.pointee = true
                }
            case .left:
                //4
                if (node.frame.minX <= 1.0) {
                    proposedMovementDirection = .downThenRight
                    stop.pointee = true
                }
            case .downThenLeft:
                proposedMovementDirection = .left
                stop.pointee = true
            case .downThenRight:
                proposedMovementDirection = .right
                stop.pointee = true
            default:
                break
            }
    }
        //7
        if (proposedMovementDirection != invaderMovementDirection){
            invaderMovementDirection = proposedMovementDirection
        }
    
}
    enum BulletType{
        case shipFired
        case invaderFired
    }
    
    
    func fireShipBullets(){
        
        if let ship = childNode(withName: kShipName){
        
        let bullet = makeBullet(ofType: .shipFired)
            
        bullet.position = CGPoint(x: ship.position.x, y: ship.position.y + ship.frame.size.height - bullet.frame.size.height / 2)
            
        let bulletDestination = CGPoint(x: ship.position.x, y: frame.size.height + bullet.frame.size.height / 2)
            
        fireBullet(bullet: bullet, toDestination: bulletDestination, withDuration: 1.0, andSoundFileName: "ShipBullet.wav")
            
        }
    
    }
    
    var tapQueue = [Int]()
    var contactQueue = [SKPhysicsContact]()
    
    func processUserTaps(forUpdate currentTime: CFTimeInterval){
        
        for tapCount in tapQueue{
            
            if tapCount == 1{
                //2
                fireShipBullets()
            }
            tapQueue.remove(at: 0)
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if(touch.tapCount == 1){
                tapQueue.append(1)
            }
        }
    }
    
    func didBegin(contact: SKPhysicsContact){
        contactQueue.append(contact)
    }
    
    func fireBullet(bullet: SKNode, toDestination destination: CGPoint, withDuration duration: CFTimeInterval, andSoundFileName soundName: String)
    {
        let bulletAction = SKAction.sequence([
            SKAction.move(to: destination, duration: duration),
            SKAction.wait(forDuration: 3.0 / 60.0),
            SKAction.removeFromParent()])
        
        let soundAction = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)
        
        bullet.run(SKAction.group([bulletAction, soundAction]))
        
        addChild(bullet)
    }
    
    let kShipFiredBulletName = "shipFiredBullet"
    let kShipFiredBulletCategory: UInt32 = 0x1 << 1
    let kInvaderCategory: UInt32 = 0x1 << 0
    let kBulletSize = CGSize(width: 4, height: 8)
    
    func makeBullet(ofType bulletType: BulletType) -> SKNode {
        var bullet : SKNode
        
        switch bulletType{
        case .shipFired:
            bullet = SKSpriteNode(color: SKColor.green, size: kBulletSize)
            bullet.name = kShipFiredBulletName
            
            bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.frame.size)
            bullet.physicsBody!.isDynamic = true
            bullet.physicsBody!.affectedByGravity = false
            bullet.physicsBody!.categoryBitMask = kShipFiredBulletCategory
            bullet.physicsBody!.collisionBitMask = 0x0
        case .invaderFired:
            bullet = SKSpriteNode(color: SKColor.magenta, size: kBulletSize)
            break
        }
        
        return bullet
    }
    
}



