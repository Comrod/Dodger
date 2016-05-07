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
        
        //Gyroscope
        /*if motionManager.gyroAvailable {
            //motionManager.startGyroUpdates()
            
            motionManager.startGyroUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler:
                {(gyroData, error) in
                    //self.motionManager.gyroData?.rotationRate
                    if (error != nil) {
                        print("\(error)")
                    }
                self.getRotationData(self.motionManager.gyroData!.rotationRate)
                //var moveCharacter = SKAction.applyForce(CGVectorMake(self.rotX*100, self.rotY*100), duration: 1)
                print(self.motionManager.gyroData!.rotationRate)
                var moveCharacter = SKAction.moveBy(CGVectorMake(-self.rotX*5, -self.rotY*5), duration: 1)
                self.character.runAction(moveCharacter)
                    
                
            })
        }*/
        
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
    
    /*func getRotationData(rotation:CMRotationRate) {
        
        //X-Axis
        rotX = CGFloat(rotation.x)
        
        //Y-Axis
        rotY = CGFloat(rotation.y)
        
    }*/
    
    
    /*func addProjectile() {
        let projectile = SKSpriteNode(imageNamed: "locationIndicator")
        
        let lowerX = CGRectZero.minX
        let upperX = size.width
        let actualX = Int(arc4random_uniform(UInt32(upperX - lowerX)) + UInt32(lowerX))
        
        let upperY = CGRectZero.minY
        let lowerY = size.height
        let actualY = Int(arc4random_uniform(UInt32(upperY - lowerY)) + UInt32(lowerY))
        
        projectile.position = CGPointMake(CGFloat(actualX), CGFloat(actualY))
        
        addChild(projectile)
        
        let actualDur = 3
        
    }*/
    
    
}
