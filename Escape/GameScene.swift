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
    let initialPlayerPosition = CGPoint(x: 150, y: 250)
    let encounterManager = EncounterManager()
    let powerUpStar = Star()
    var screenCenterY = CGFloat()
    var playerProgress = CGFloat()
    var nextEncounterSpawnPosition = CGFloat(150)
    
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
        self.addChild(world)
        
        screenCenterY = self.size.height / 2
        
        encounterManager.addEncountersToWorld(self.world)
        
        let groundPosition = CGPoint(x: -self.size.width, y: 30)
        let groundSize = CGSize(width: self.size.width * 3, height: 0)
        ground.spawn(world, position: groundPosition, size: groundSize)
        player.spawn(world, position: initialPlayerPosition)
        powerUpStar.spawn(world, position: CGPoint(x: -2000, y: -2000))
        
        
        // Adjust the gravity - he must be on Mars
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
    }
    
    override func didSimulatePhysics() {
        var worldYPos:CGFloat = 0
        
        // Zoom the world as penguin flies higher
        if player.position.y > screenCenterY {
            let percentOfMaxHeight = (player.position.y - screenCenterY) / (player.maxHeight - screenCenterY)
            let scaleSubtraction = (percentOfMaxHeight > 1 ? 1 : percentOfMaxHeight * 0.6)
            let newScale = 1 - scaleSubtraction
            world.yScale = newScale
            world.xScale = newScale
            
            // The player is above half of world so adjust screen to follow
            worldYPos = -(player.position.y * world.yScale - (self.size.height / 2))
        }
        
        let worldXPos = -(player.position.x * world.xScale - (self.size.width / 3))
        
        world.position = CGPoint(x: worldXPos, y: worldYPos)
        
        // Keep track of how far the player has flown
        playerProgress = player.position.x - initialPlayerPosition.x
        
        // Check to see if ground should jump forward
        ground.checkForReposition(playerProgress)
        
        // Check to see if we should set a new encounter
        if player.position.x > nextEncounterSpawnPosition {
            encounterManager.placeNextEncounter(nextEncounterSpawnPosition)
            nextEncounterSpawnPosition += 1400
            
            // Each encounter has a 10% chance to spawn a star
            let starRoll = Int(arc4random_uniform(10))
            if starRoll == 0 {
                if abs(player.position.x - powerUpStar.position.x) > 1200 {
                    // Only move the star if it is offscreen
                    let randomYPos = CGFloat(arc4random_uniform(400))
                    powerUpStar.position = CGPoint(x: nextEncounterSpawnPosition, y: randomYPos)
                    powerUpStar.physicsBody?.angularVelocity = 0
                    powerUpStar.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                }
            }
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            let nodeTouched = nodeAtPoint(location)
            if let gameSprint = nodeTouched as? GameSprite {
                gameSprint.onTap()
            }
        }
        
        player.startFlapping()
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        player.stopFlapping()
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        player.stopFlapping()
    }
    
    override func update(currentTime: NSTimeInterval) {
        player.update()
    }
}
