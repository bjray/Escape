//
//  GameScene.swift
//  Escape
//
//  Created by Bj Ray on 8/20/15.
//  Copyright (c) 2015 Bj Ray. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let world = SKNode()
    let ground = Ground()
    let player = Player()
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
        self.addChild(world)
        
        
        let bee2 = Bee()
        let bee3 = Bee()
        let bee4 = Bee()
        
        bee2.spawn(world, position: CGPoint(x: 325, y: 325))
        bee3.spawn(world, position: CGPoint(x: 200, y: 325))
        bee4.spawn(world, position: CGPoint(x: 50, y: 200))
        
        let groundPosition = CGPoint(x: -self.size.width, y: 100)
        let groundSize = CGSize(width: self.size.width * 3, height: 0)
        ground.spawn(world, position: groundPosition, size: groundSize)
        
        player.spawn(world, position: CGPoint(x: 150, y: 250))
        
        bee2.physicsBody?.mass = 0.2
        bee2.physicsBody?.applyImpulse(CGVector(dx: -15, dy: 0))
        
    }
    
    override func didSimulatePhysics() {
        let worldXPos = -(player.position.x * world.xScale - (self.size.width / 2))
        let worldYPos = -(player.position.y * world.yScale - (self.size.height / 2))
        world.position = CGPoint(x: worldXPos, y: worldYPos)
    }
}
