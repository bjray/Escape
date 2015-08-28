//
//  Bat.swift
//  Escape
//
//  Created by B.J. Ray on 8/25/15.
//  Copyright (c) 2015 Bj Ray. All rights reserved.
//

import SpriteKit

class Bat:SKSpriteNode, GameSprite {
    var textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "enemies.atlas")
    var flyAnimation = SKAction()
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 44, height: 24)) {
        parentNode.addChild(self)
        
        createAnimations()
        
        self.size = size
        self.position = position
        self.runAction(flyAnimation)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
        self.physicsBody?.collisionBitMask = ~PhysicsCategory.damagedPenguin.rawValue
        
    }
    
    func onTap() {
        // not implemented
    }
    
    func createAnimations() {
        let flyFrames:[SKTexture] = [
            textureAtlas.textureNamed("bat-fly-1.png"),
            textureAtlas.textureNamed("bat-fly-2.png"),
            textureAtlas.textureNamed("bat-fly-3.png"),
            textureAtlas.textureNamed("bat-fly-4.png")]
        
        let flyAction = SKAction.animateWithTextures(flyFrames, timePerFrame: 0.06)
        flyAnimation = SKAction.repeatActionForever(flyAction)
    }
}
