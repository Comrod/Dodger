//
//  GameScene.swift
//  Dodger
//
//  Created by Cormac Chester on 5/4/16.
//  Copyright (c) 2016 Extreme Images. All rights reserved.
//

import SpriteKit
import CoreMotion

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Character : UInt32 = 0b1       // 1
    static let Projectile: UInt32 = 0b10      // 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var character = SKSpriteNode()
    var motionManager = CMMotionManager()
    
    var difficulty = 0.2
    
    //Device Attitude Vars
    var attitudeX:CGFloat = 0.0
    var attitudeY: CGFloat = 0.0
    
    //Projectile Locations
    var startX = CGFloat()
    var startY = CGFloat()
    var endX = CGFloat()
    var endY = CGFloat()
    
    //Score
    var scoreTimer:NSTimer!
    var timeForScoreMili:Int = 0
    var scoreLabel = SKLabelNode()
    var scoreLabelString:String!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */

        
        //Score
        timeForScoreMili = 0
        scoreTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(GameScene.scoreIncrement), userInfo: nil, repeats: true)
        scoreLabel = SKLabelNode(fontNamed: "ArialMT")
        scoreLabel.text = "0.0"
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame)/4, CGRectGetMidY(self.frame)/(2/3))
        scoreLabel.fontSize = 30
        scoreLabel.color = SKColor.blackColor()
        self.addChild(scoreLabel)
        
        //Character Setup
        character = SKSpriteNode(imageNamed: "locationIndicator")
        character.position = CGPointMake(CGRectGetMidX(self.frame)/2, CGRectGetMidY(self.frame))
        character.xScale = 4
        character.yScale = 4
        
        character.physicsBody = SKPhysicsBody(circleOfRadius: character.size.height/2)
        character.physicsBody?.dynamic = true
        character.physicsBody?.categoryBitMask = PhysicsCategory.Character //What category the projectile belongs to
        character.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile //What category it interacts with
        character.physicsBody?.collisionBitMask = PhysicsCategory.None //What category bounces off of it
        
        self.addChild(character)
        
        //Physics World
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        //Character Motion
        if motionManager.deviceMotionAvailable {
            motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: { (deviceMotionData, error) in
                if (error != nil) {
                    print("\(error)")
                }
                
                self.getAttitudeData(self.motionManager.deviceMotion!.attitude)
                var moveCharacter = SKAction.moveBy(CGVectorMake(-self.attitudeX*10, -self.attitudeY*10), duration: 0.1)
                self.character.runAction(moveCharacter)
            })
        }
        
        //Add Projectiles
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(projectileFlightCalc), SKAction.waitForDuration(difficulty)])), withKey: "projectileAction")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        //for touch in touches { }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
    
    func scoreIncrement() {
        timeForScoreMili += 1
        var miliForLabel = timeForScoreMili % 100
        var seconds = (timeForScoreMili/100) % 60
        var minutes = (timeForScoreMili/100) / 60
        
        scoreLabelString = String(format: "%02d.%02d.%02d", minutes, seconds, miliForLabel)
        
        scoreLabel.text = scoreLabelString
    }
    
    func getAttitudeData(attitude:CMAttitude) {
        attitudeX = CGFloat(attitude.pitch)
        attitudeY = CGFloat(attitude.roll)
    }

    //Add Projectiles
    func projectileFlightCalc() {
        let projectile = SKSpriteNode(imageNamed: "projectile")
        projectile.xScale = 2
        projectile.yScale = 2
        
        var projectileSpeed = NSTimeInterval(randRange(2, upper: 5))
        
        
        let lowerX = Int(projectile.size.width)
        let upperX = Int(size.width)
        let randX = CGFloat(randRange(lowerX, upper: upperX))
        
        let lowerY = Int(projectile.size.height)
        let upperY = Int(size.height)
        let randY = CGFloat(randRange(lowerY, upper: upperY))
        

        var whichSide = Int(arc4random_uniform(UInt32(4)))
        
        //Top
        if whichSide == 0 {
            
            //Starting Coordinates
            startX = randX
            startY = size.height + projectile.size.height
            
            //Ending Coordinates
            endX = randX //will change later so flight path is diagonal
            endY = -projectile.size.height
            print("top")
        }
        //Right
        else if whichSide == 1 {
            
            startX = size.width + projectile.size.width
            startY = randY
            
            endX = -projectile.size.width
            endY = randY //will change later so flight path is diagonal
            print("right")
        }
        //Bottom
        else if whichSide == 2 {
            
            startX = randX
            startY = -projectile.size.height
            
            endX = randX //will change later so flight path is diagonal
            endY = size.height + projectile.size.height
            print("bottom")
        }
        //Left
        else if whichSide == 3 {
            
            startX = -projectile.size.width
            startY = randY
            
            endX = size.width + projectile.size.width
            endY = randY //will change later so flight path is diagonal
            print("left")
        }
        
        print("endx1")
        print(endX)
        
        projectile.position = CGPointMake(startX, startY)
        print("Start position:")
        print(projectile.position)
        
        addChild(projectile)
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.height/2)
        projectile.physicsBody?.dynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile //What category the projectile belongs to
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Character //What category it interacts with
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None //What category bounces off of it
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        let actionMove = SKAction.moveTo(CGPointMake(size.width + projectile.size.width, endY), duration: projectileSpeed)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.runAction(SKAction.sequence([actionMove, actionMoveDone]))

    }
    
    //Called when the player is hit by a projectile
    func playerHitByProjectile(projectile:SKSpriteNode, character:SKSpriteNode) {
        print("Hit")
        projectile.removeFromParent()
        character.removeFromParent()
        self.removeAllChildren()
        self.removeActionForKey("projectileAction")
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        //Checks to see if 2 physics bodies collided
        if ((firstBody.categoryBitMask & PhysicsCategory.Character != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {
            playerHitByProjectile(firstBody.node as! SKSpriteNode, character: secondBody.node as! SKSpriteNode)
        }
        
    }
    
    func randRange (lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
}
