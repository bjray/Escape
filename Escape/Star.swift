//
//  Star.swift
//  Escape
//
//  Created by B.J. Ray on 8/25/15.
//  Copyright (c) 2015 Bj Ray. All rights reserved.
//

import SpriteKit

class Star:SKSpriteNode, GameSprite {
    var textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "goods.atlas")
    var pulseAnimation = SKAction()
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 40, height: 38)) {
        parentNode.addChild(self)
        createAmnimations()
        self.size = size
        self.position = position
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        
        //star texture is only 1 frame so set here
        self.texture = textureAtlas.textureNamed("power-up-star.png")
        self.runAction(pulseAnimation)
    }
    
    func onTap() {
        //place holder
    }
    
    func createAmnimations() {
        // Scale star smaller and fade slightly...
        let pulseOutGroup = SKAction.group([
            SKAction.fadeAlphaTo(0.85, duration: 0.8),
            SKAction.scaleTo(0.6, duration: 0.8),
            SKAction.rotateByAngle(-0.3, duration: 0.8)])
        
        
        //push the star big and fade back in...
        let pulseInGroup = SKAction.group([
            SKAction.fadeAlphaTo(1, duration: 1.5),
            SKAction.scaleTo(1, duration: 1.5),
            SKAction.rotateByAngle(3.5, duration: 1.5)
            ])
        
        
        // Combine into a sequence action
        let pulseSequence = SKAction.sequence([pulseOutGroup, pulseInGroup])
        
        // loop pulsing animation
        pulseAnimation = SKAction.repeatActionForever(pulseAnimation)
    }
}
