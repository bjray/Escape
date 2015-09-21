//
//  Coin.swift
//  Escape
//
//  Created by B.J. Ray on 8/25/15.
//  Copyright (c) 2015 Bj Ray. All rights reserved.
//

import SpriteKit

class Coin:SKSpriteNode, GameSprite {
    var textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "goods.atlas")
    var value = 1
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 26, height: 26)) {
        parentNode.addChild(self)
        
        self.size = size
        self.position = position
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.coin.rawValue
        self.physicsBody?.collisionBitMask = 0
        
        self.texture = textureAtlas.textureNamed("coin-bronze.png")
    }
    
    func onTap() {
        // not implemented
    }
    
    func turnToGold() {
        self.texture = textureAtlas.textureNamed("coin-gold.png")
        self.value = 5
    }
    
    func collect() {
        // prevent further contact
        self.physicsBody?.categoryBitMask = 0
        
        // fade out, move up and scale up
        let collectAnimation = SKAction.group([
            SKAction.fadeAlphaTo(0, duration: 0.2),
            SKAction.scaleTo(1.5, duration: 0.2),
            SKAction.moveBy(CGVector(dx: 0, dy: 25), duration: 0.2)
            ])
        
        // after fading it out, move the coin out of the way, and reset it to initial values until the encounter system re-uses it
        let resetAfterCollected = SKAction.runBlock({
            self.position.y = 5000
            self.alpha = 1
            self.xScale = 1
            self.yScale = 1
            self.physicsBody?.categoryBitMask = PhysicsCategory.coin.rawValue
        })
        
        // Combine actions into a sequence
        let collectSequence = SKAction.sequence([collectAnimation, resetAfterCollected])
        
        self.runAction(collectSequence)
        
    }
}
