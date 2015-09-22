//
//  Background.swift
//  Escape
//
//  Created by B.J. Ray on 9/22/15.
//  Copyright © 2015 Bj Ray. All rights reserved.
//

import SpriteKit

class Background: SKSpriteNode {
    // movementMultiplier to control how fast background moves
    // 0: no adjustment, stands still
    // 1: no adjustment, regular speed
    var movementMultiplier = CGFloat(0)
    
    // justAdjustment will store how many points in x position will jump forward
    var jumpAdjustment = CGFloat(0)
    
    // background node sizes
    let backgroundSize = CGSize(width: 1000, height: 1000)
    
    func spawn(parentNode:SKNode, imageName:String, zPosition:CGFloat, moveMulti:CGFloat) {
        // Position from bottom left
        self.anchorPoint = CGPointZero
        
        // Start backgrounds at the top of ground...
        self.position = CGPoint(x: 0, y: 30)
        
        // control backgrounds with z-pos
        self.zPosition = zPosition
        
        self.movementMultiplier = moveMulti
        parentNode.addChild(self)
        
        // Build 3 child node textures looping from -1 to 1 to cover in front and behind of player
        for i in -1...1 {
            let newBGNode = SKSpriteNode(imageNamed: imageName)
            newBGNode.size = backgroundSize
            
            // Position nodes by lower left corner...
            newBGNode.anchorPoint = CGPointZero
            newBGNode.position = CGPoint(x: i * Int(backgroundSize.width), y: 0)
            self.addChild(newBGNode)
        }
        
    }
    
    // We will call updatePos every frame to reposition the background
    func updatePosition(playerProgress:CGFloat) {
        // Calc pos adjustment after loops and paralax multiplier
        let adjustedPosition = jumpAdjustment + playerProgress * (1 - movementMultiplier)
        
        // Check if we need to jump background forward
        if playerProgress - adjustedPosition > backgroundSize.width {
            jumpAdjustment += backgroundSize.width
        }
        
        // Adjust the background forward as the world moves back so the background appears slower
        self.position.x = adjustedPosition
    }
}
