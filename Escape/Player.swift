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
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 64, height: 64)) {
        parentNode.addChild(self)
        
        createAnimations()
        
        self.size = size
        self.position = position
        self.runAction(flyAnimation, withKey: "flapAnimation")
        
        // create phyics body based on one of the frames
        let textureBody = textureAtlas.textureNamed("pierre-flying-3.png")
        self.physicsBody = SKPhysicsBody(texture: textureBody, size: size)
        
        //quickly lose momentum with high linear dampening
        self.physicsBody?.linearDamping = 0.9
        self.physicsBody?.mass = 30
        
        //prevent from rotating
        self.physicsBody?.allowsRotation = false
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
        
    }
    
    func onTap() {
        // not yet implemented
    }
}
