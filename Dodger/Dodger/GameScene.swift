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
    
    let manager = CMMotionManager()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */

        //Character Setup
        let character = SKSpriteNode(imageNamed: "locationIndicator")
        character.position = CGPoint(x: CGRectGetMidX(self.frame)/2, y: CGRectGetMidY(self.frame))
        character.xScale = 2
        character.yScale = 2
        
        self.addChild(character)
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
