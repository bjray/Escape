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
    var flapping = false                        // Flying or not?
    var invulnerable = false
    var damaged = false
    var forwardVelocity:CGFloat = 200
    var health:Int = 3
    var flyAnimation = SKAction()
    var soarAnimation = SKAction()
    var damageAnimation = SKAction()
    var dieAnimation = SKAction()
    
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
            PhysicsCategory.ground.rawValue |
            PhysicsCategory.powerup.rawValue |
            PhysicsCategory.coin.rawValue
        
        
    }
    
    func createAnimations() {
        let rotateUpAction = SKAction.rotateToAngle(0, duration: 0.475)
        rotateUpAction.timingMode = .EaseOut
        
        let rotateDownAction = SKAction.rotateToAngle(-1, duration: 0.8)
        rotateDownAction.timingMode = .EaseIn
        
        //create flying animation...
        let flyingFrames:[SKTexture] = [
            textureAtlas.textureNamed("pierre-flying-1.png"),
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

        let damageStart = SKAction.runBlock{
            self.physicsBody?.categoryBitMask = PhysicsCategory.damagedPenguin.rawValue
            
            //use bitwise NOT to remove enemies from collision
            self.physicsBody?.collisionBitMask = ~PhysicsCategory.enemy.rawValue
        }
        
        //create an opacity pulse
        let slowFade = SKAction.sequence([
            SKAction.fadeAlphaTo(0.3, duration: 0.35),
            SKAction.fadeAlphaTo(0.7, duration: 0.35)
            ])

        let fastFade = SKAction.sequence([
            SKAction.fadeAlphaTo(0.3, duration: 0.2),
            SKAction.fadeAlphaTo(0.7, duration: 0.2)
            ])
        let fadeInAndOut = SKAction.sequence([
            SKAction.repeatAction(slowFade, count: 2),
            SKAction.repeatAction(fastFade, count: 5),
            SKAction.fadeAlphaTo(1, duration: 0.15)
            ])
        
        // return penguin back to normal
        let damageEnd =     SKAction.runBlock {
            self.physicsBody?.categoryBitMask = PhysicsCategory.penguin.rawValue
            
            // collide with everything again...
            self.physicsBody?.collisionBitMask = 0xFFFFFFFF
            // turn of newly damaged flag
            self.damaged = false
        }
        
        // store the whole sequence in damage property
        self.damageAnimation = SKAction.sequence([
            damageStart,
            fadeInAndOut,
            damageEnd
            ])
        
        let startDie = SKAction.runBlock {
            // add x-eyes
            self.texture = self.textureAtlas.textureNamed("pierre-dead.png")
            
            // suspend motion
            self.physicsBody?.affectedByGravity = false
            
            // Stop any motion
            self.physicsBody?.velocity = CGVector(dx: 0, dy:0)
            
            // Make penguin pass through everything except ground
            self.physicsBody?.collisionBitMask = PhysicsCategory.ground.rawValue
        }
        
        let endDie = SKAction.runBlock {
            // turn gravity back on
            self.physicsBody?.affectedByGravity = true
        }
        
        self.dieAnimation = SKAction.sequence([
            startDie,
            SKAction.scaleTo(1.3, duration: 0.5),
            SKAction.waitForDuration(0.5),
            SKAction.rotateToAngle(3, duration: 1.5),
            SKAction.waitForDuration(0.5),
            endDie])
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
            
            self.physicsBody?.velocity.dx = forwardVelocity
        }
    }
    
    func onTap() {
        // not yet implemented
    }
    
    
    // Begin flapping
    func startFlapping() {
        if self.health <= 0 { return }
        
        self.removeActionForKey("soarAnimation")
        self.runAction(flyAnimation, withKey: "flapAnimation")
        self.flapping = true
    }
    
    // Stopflapping
    func stopFlapping() {
        if self.health <= 0 { return }
        
        self.removeActionForKey("flapAction")
        self.runAction(soarAnimation, withKey: "soarAnimation")
        self.flapping = false
    }
    
    func die() {
        // make sure player is fully visible
        self.alpha = 1
        
        // remove all animations
        self.removeAllActions()
        
        // run the die animation
        self.runAction(self.dieAnimation)
        
        // Prevent any further upward movement
        self.flapping = false
        self.forwardVelocity = 0
        
        print("You done died!", terminator: "")
    }
    
    func takeDamage() {
        if self.invulnerable || self.damaged { return }
        self.damaged = true
        self.health--
        
        if self.health == 0 {
            die()
        } else {
            self.runAction(self.damageAnimation)
        }
    }
    
    func starPower() {
        // remove any existing star power animation
        self.removeActionForKey("starPower")
        
        // grant forward speed
        self.forwardVelocity = 400
        
        // make player invulnerable
        self.invulnerable = true
        
        // create sequence to scale the player larger for 8 seconds
        let starSequence = SKAction.sequence([
            SKAction.scaleTo(1.5, duration: 0.3),
            SKAction.waitForDuration(8),
            SKAction.scaleTo(1, duration: 1),
            SKAction.runBlock({
                self.forwardVelocity = 200
                self.invulnerable = false
            })
        ])
        
        self.runAction(starSequence, withKey: "starPower")
    }
}
