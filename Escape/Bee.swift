//
//  Bee.swift
//  Escape
//
//  Created by Bj Ray on 8/21/15.
//  Copyright (c) 2015 Bj Ray. All rights reserved.
//

import SpriteKit

class Bee:SKSpriteNode, GameSprite {
    var textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "bee.atlas")
    var flyAnimation = SKAction()
    
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 28, height: 24)) {
        parentNode.addChild(self)
        
        createAnimations()
        
        self.size = size
        self.position = position
        self.runAction(flyAnimation)
        
        //add a physics body the shape of a circle roughly the same size as the bee
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        self.physicsBody?.affectedByGravity = false
    }
    
    func createAnimations() {
        let flyFrames:[SKTexture] = [textureAtlas.textureNamed("bee.png"), textureAtlas.textureNamed("bee_fly.png")]
        
        let flyAction = SKAction.animateWithTextures(flyFrames, timePerFrame: 0.14)
        flyAnimation = SKAction.repeatActionForever(flyAction)
        
    }
    
    func onTap() {
        // not yet implemented...
    }
}
