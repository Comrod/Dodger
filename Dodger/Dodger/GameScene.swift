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
    
    var difficulty = 0.5
    
    //Device Attitude Vars
    var attitudeX:CGFloat = 0.0
    var attitudeY: CGFloat = 0.0
    
    //Projectile Locations
    var startX = CGFloat()
    var startY = CGFloat()
    var endX = CGFloat()
    var endY = CGFloat()
    
    
    
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
                var moveCharacter = SKAction.moveBy(CGVectorMake(-self.attitudeX*10, -self.attitudeY*10), duration: 0.1)
                self.character.runAction(moveCharacter)
            })
        }
        
        //Add Projectiles
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addProjectile),
                SKAction.waitForDuration(difficulty)
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

    //Does all the fun calculations for projectile flight
    func projectileFlightCalc() {//-> (startX: CGFloat, startY: CGFloat, endX: CGFloat, endY: CGFloat) {
        let projectile = SKSpriteNode(imageNamed: "locationIndicator")
        projectile.xScale = 2
        projectile.yScale = 2
        
        //var projectileSpeed = NSTimeInterval(randRange(1, upper: 3))
        
        
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
        
        let actionMove = SKAction.moveTo(CGPointMake(size.width + projectile.size.width, endY), duration: 3)
        //let actionMove = SKAction.moveTo(CGPointMake(endX, endY), duration: 3)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        
        //return (startX, startY, endX, endY)
    }
    
    func addProjectile() {
        let projectile = SKSpriteNode(imageNamed: "locationIndicator")
        projectile.xScale = 2
        projectile.yScale = 2
        
        var projectileSpeed = NSTimeInterval(randRange(1, upper: 3))

        /*//Do Calculations
        projectileFlightCalc()
        
        print("Position startx:")
        //print(projectileFlightCalc().startX)
        
        //projectile.position = CGPointMake(projectileFlightCalc().startX, projectileFlightCalc().startY)
        print("Start position:")
        print(projectile.position)
        
        //let actionMove = SKAction.moveTo(CGPointMake(projectileFlightCalc().endX, projectileFlightCalc().endY), duration: projectileSpeed)
        
        
        let actionMoveDone = SKAction.removeFromParent()
        //projectile.runAction(actionMove)
        print("Final position (hopefully):")
        print(projectile.position)
        projectile.runAction((actionMoveDone))*/
        
        //projectile.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        
        let lowerX = Int(projectile.size.width)
        let upperX = Int(size.width)
        let actualX = CGFloat(randRange(lowerX, upper: upperX))
        
        let lowerY = Int(projectile.size.height)
        let upperY = Int(size.height)
        let actualY = CGFloat(randRange(lowerY, upper: upperY))
        
        var whichSide = Int(arc4random_uniform(UInt32(4)))
        
        //Right Side
        if (whichSide == 0) {
            print("Right Side")
            projectile.position = CGPointMake(size.width + projectile.size.width, actualY)
            
            addChild(projectile)
            
            let actualDur:NSTimeInterval = projectileSpeed
            let actionMove = SKAction.moveTo(CGPointMake(-projectile.size.width, actualY), duration: actualDur)
            let actionMoveDone = SKAction.removeFromParent()
            projectile.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        }
        //Top Side
        else if (whichSide == 1) {
            print("Top Side")
            projectile.position = CGPointMake(actualX, size.height + projectile.size.height)
            
            addChild(projectile)
            
            let actualDur:NSTimeInterval = projectileSpeed
            let actionMove = SKAction.moveTo(CGPointMake(actualX, -projectile.size.height), duration: actualDur)
            let actionMoveDone = SKAction.removeFromParent()
            projectile.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        }
        //Left Side
        else if (whichSide == 2) {
            print("Left Side")
            projectile.position = CGPointMake(-projectile.size.width, actualY)
            
            addChild(projectile)
            
            let actualDur:NSTimeInterval = projectileSpeed
            let actionMove = SKAction.moveTo(CGPointMake(size.width + projectile.size.width, CGFloat(actualY)), duration: actualDur)
            let actionMoveDone = SKAction.removeFromParent()
            projectile.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        }
        //Bottom Side
        else if (whichSide == 3) {
            print("Bottom Side")
            projectile.position = CGPointMake(actualX, -projectile.size.height)
            
            addChild(projectile)
            
            let actualDur:NSTimeInterval = projectileSpeed
            let actionMove = SKAction.moveTo(CGPointMake(actualX, size.height + projectile.size.height), duration: actualDur)
            let actionMoveDone = SKAction.removeFromParent()
            projectile.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        }
        
    }
    
    func randRange (lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
}
