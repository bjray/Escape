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
}
