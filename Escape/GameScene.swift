//
//  GameScene.swift
//  Escape
//
//  Created by Bj Ray on 8/20/15.
//  Copyright (c) 2015 Bj Ray. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let world = SKNode()
    let ground = Ground()
    let player = Player()
    let initialPlayerPosition = CGPoint(x: 150, y: 250)
    let encounterManager = EncounterManager()
    let powerUpStar = Star()
    let hud = HUD()
    var screenCenterY = CGFloat()
    var playerProgress = CGFloat()
    var nextEncounterSpawnPosition = CGFloat(150)
    var coinsCollected = 0
    
    
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
        
        
        // Create HUD's child nodes and add to scene
        hud.createHudNodes(self.size)
        self.addChild(hud)
        
        // position hud above all others
        hud.zPosition = 50
        
        // Adjust the gravity - he must be on Mars
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        
        self.physicsWorld.contactDelegate = self
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in (touches ) {
            let location = touch.locationInNode(self)
            let nodeTouched = nodeAtPoint(location)
            if let gameSprint = nodeTouched as? GameSprite {
                gameSprint.onTap()
            }
        }
        
        player.startFlapping()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        player.stopFlapping()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        player.stopFlapping()
    }
    
    override func update(currentTime: NSTimeInterval) {
        player.update()
    }
    
    // MARK:
    // MARK: Contact Delegate Methods
    func didBeginContact(contact: SKPhysicsContact) {
        // Contact happens between a penguin and some object, but we dont know which one, so find a penguin
        let otherBody:SKPhysicsBody
        
        //combine 2 penguin masks into 1 using bitwise OR
        let penguinMask = PhysicsCategory.penguin.rawValue | PhysicsCategory.damagedPenguin.rawValue
        
        // use bitwise AND to find penguin - a positive value means first object is a penguin
        if (contact.bodyA.categoryBitMask & penguinMask) > 0 {
            otherBody = contact.bodyB
        } else {
            otherBody = contact.bodyA
        }
        
        switch otherBody.categoryBitMask {
        case PhysicsCategory.ground.rawValue:
            player.takeDamage()
            hud.setHealthDisplay(player.health)
        case PhysicsCategory.enemy.rawValue:
            player.takeDamage()
            hud.setHealthDisplay(player.health)
        case PhysicsCategory.coin.rawValue:
            if let coin = otherBody.node as? Coin {
                coin.collect()
                self.coinsCollected += coin.value
                hud.setCoinCountDisplay(self.coinsCollected)
            }
        case PhysicsCategory.powerup.rawValue:
            print("start power-up")
            player.starPower()
        default:
            print("contact with no game logic")
        }
        
    }
    
}

enum PhysicsCategory:UInt32 {
    case penguin = 1
    case damagedPenguin = 2
    case ground = 4
    case enemy = 8
    case coin = 16
    case powerup = 32
}
