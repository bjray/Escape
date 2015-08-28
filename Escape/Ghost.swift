//
//  Ghost.swift
//  Escape
//
//  Created by B.J. Ray on 8/25/15.
//  Copyright (c) 2015 Bj Ray. All rights reserved.
//

import SpriteKit

class Ghost:SKSpriteNode, GameSprite {
    var textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "enemies.atlas")
    var fadeAnimation = SKAction()
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 30, height: 44)) {
        parentNode.addChild(self)
        
        createAnimations()
        
        self.size = size
        self.position = position
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
        self.physicsBody?.collisionBitMask = ~PhysicsCategory.damagedPenguin.rawValue
        
        self.texture = textureAtlas.textureNamed("ghost-frown.png")
        self.runAction(fadeAnimation)
        self.alpha = 0.8
    }
    
    func onTap() {
        // not implemented
    }
    
    func createAnimations() {
        // Fade ghost out action group
        
        let fadeOutGroup = SKAction.group([
            SKAction.fadeAlphaTo(0.3, duration: 2),
            SKAction.scaleTo(0.8, duration: 2),
            SKAction.colorizeWithColor(UIColor.greenColor(), colorBlendFactor: 0.8, duration: 2)
            ])
        
        let fadeInGroup = SKAction.group([
            SKAction.fadeAlphaTo(0.8, duration: 2),
            SKAction.scaleTo(1, duration: 2),
            SKAction.colorizeWithColor(UIColor.lightGrayColor(), colorBlendFactor: 0.8, duration: 2)
            ])
        
        // Sequence the actions
        let fadeSequence = SKAction.sequence([fadeOutGroup, fadeInGroup])
        
        fadeAnimation = SKAction.repeatActionForever(fadeSequence)
    }
}
