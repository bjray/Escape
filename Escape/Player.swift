//
//  Player.swift
//  Escape
//
//  Created by Bj Ray on 8/21/15.
//  Copyright (c) 2015 Bj Ray. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode, GameSprite {

    var textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "pierre.atlas")
    var flyAnimation = SKAction()
    var soarAnimation = SKAction()
    var flapping = false                        // Flying or not?
    var xSpeed:CGFloat = 200
    let maxFlappingForce:CGFloat = 57000        // set max upward force
    let maxHeight:CGFloat = 1000                // Slow down when getting too high
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 64, height: 64)) {
        parentNode.addChild(self)
        
        createAnimations()
        
        self.size = size
        self.position = position
        self.runAction(soarAnimation, withKey: "soarAnimation")
        
        // create phyics body based on one of the frames
        let textureBody = textureAtlas.textureNamed("pierre-flying-3.png")
        self.physicsBody = SKPhysicsBody(texture: textureBody, size: size)
        
        //quickly lose momentum with high linear dampening
        self.physicsBody?.linearDamping = 0.9
        self.physicsBody?.mass = 30
        
        //prevent from rotating
        self.physicsBody?.allowsRotation = false
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.penguin.rawValue
        self.physicsBody?.contactTestBitMask =
            PhysicsCategory.enemy.rawValue |
            PhysicsCategory.coin.rawValue |
            PhysicsCategory.ground.rawValue |
            PhysicsCategory.powerup.rawValue
        
        
    }
    
    func createAnimations() {
        let rotateUpAction = SKAction.rotateByAngle(0, duration: 0.475)
        rotateUpAction.timingMode = .EaseOut
        
        let rotateDownAction = SKAction.rotateToAngle(-1, duration: 0.8)
        rotateDownAction.timingMode = .EaseIn
        
        //create flying animation...
        let flyingFrames:[SKTexture] = [textureAtlas.textureNamed("pierre-flying-1.png"),
            textureAtlas.textureNamed("pierre-flying-2.png"),
            textureAtlas.textureNamed("pierre-flying-3.png"),
            textureAtlas.textureNamed("pierre-flying-4.png"),
            textureAtlas.textureNamed("pierre-flying-3.png"),
            textureAtlas.textureNamed("pierre-flying-2.png")]
        
        let flyAction = SKAction.animateWithTextures(flyingFrames, timePerFrame: 0.03)
        
        flyAnimation = SKAction.group([SKAction.repeatActionForever(flyAction), rotateUpAction])
        
        //create soaring animation...
        let soarFrames:[SKTexture] = [textureAtlas.textureNamed("pierre-flying-1.png")]
        let soarAction = SKAction.animateWithTextures(soarFrames, timePerFrame: 1)
        
        soarAnimation = SKAction.group([SKAction.repeatActionForever(soarAction), rotateDownAction])
        
    }
    
    func update() {
        if self.flapping {
            var forceToApply = maxFlappingForce
            
            if position.y > 600 {
                let percentOfMaxHeight = position.y / maxHeight
                let flappingForceSubtraction = percentOfMaxHeight * maxFlappingForce
                forceToApply -= flappingForceSubtraction
            }
            
            self.physicsBody?.applyForce(CGVector(dx: 0, dy: forceToApply))
            
            //limit top speed as he climbs to prevent player from overshooting max height
            if self.physicsBody?.velocity.dy > 300 {
                self.physicsBody?.velocity.dy = 300
            }
            
            self.physicsBody?.velocity.dx = xSpeed
        }
    }
    
    func onTap() {
        // not yet implemented
    }
    
    
    // Begin flapping
    func startFlapping() {
        self.removeActionForKey("soarAnimation")
        self.runAction(flyAnimation, withKey: "flapAnimation")
        self.flapping = true
    }
    
    // Stopflapping
    func stopFlapping() {
        self.removeActionForKey("flapAction")
        self.runAction(soarAnimation, withKey: "soarAnimation")
        self.flapping = false
    }
    
}
