//
//  GameScene.swift
//  Dodger
//
//  Created by Cormac Chester on 5/4/16.
//  Copyright (c) 2016 Extreme Images. All rights reserved.
//

import SpriteKit
import CoreMotion


class GameScene: SKScene {
    
    var character = SKSpriteNode()
    var motionManager = CMMotionManager()
    
    //For SKAction
    var destX:CGFloat = 0.0
    var destY:CGFloat = 0.0
    
    //Device Attitude Vars
    var attitudeX:CGFloat = 0.0
    var attitudeY: CGFloat = 0.0
    
    //Gyroscope Vars
    var rotX:CGFloat = 0.0
    var rotY:CGFloat = 0.0
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */

        //Character Setup
        character = SKSpriteNode(imageNamed: "locationIndicator")
        character.position = CGPointMake(CGRectGetMidX(self.frame)/2, CGRectGetMidY(self.frame))
        character.xScale = 4
        character.yScale = 4
        self.addChild(character)
        
        //Device Motion
        if motionManager.deviceMotionAvailable {
            motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: { (deviceMotionData, error) in
                if (error != nil) {
                    print("\(error)")
                }
                
                self.getAttitudeData(self.motionManager.deviceMotion!.attitude)
                print(self.motionManager.deviceMotion!.attitude)
                var moveCharacter = SKAction.moveBy(CGVectorMake(-self.attitudeX*10, -self.attitudeY*10), duration: 0.1)
                self.character.runAction(moveCharacter)
            })
        }
        
        //Add Projectiles
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addProjectile),
                SKAction.waitForDuration(1.0)
                ])
            ))
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
    
    func getAttitudeData(attitude:CMAttitude) {
        attitudeX = CGFloat(attitude.pitch)
        attitudeY = CGFloat(attitude.roll)
    }

    
    func addProjectile() {
        let projectile = SKSpriteNode(imageNamed: "locationIndicator")
        projectile.xScale = 2
        projectile.yScale = 2
        
        let lowerX = Int(projectile.size.width)
        let upperX = Int(size.width)
        let actualX = randRange(lowerX, upper: upperX)
        
        let lowerY = Int(projectile.size.height)
        let upperY = Int(size.height)
        let actualY = randRange(lowerY, upper: upperY)
        
        projectile.position = CGPointMake(size.width + projectile.size.width/2, CGFloat(actualY))
        
        addChild(projectile)
        
        let actualDur:NSTimeInterval = 3
        let actionMove = SKAction.moveTo(CGPointMake(-projectile.size.width/2, CGFloat(actualY)), duration: actualDur)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
    
    func randRange (lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
}
