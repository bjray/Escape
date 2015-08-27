//
//  EncounterManager.swift
//  Escape
//
//  Created by B.J. Ray on 8/26/15.
//  Copyright (c) 2015 Bj Ray. All rights reserved.
//

import SpriteKit

class EncounterManager {
    let encounterNames:[String] = ["EncounterBats", "EncounterBees", "EncounterCoins"]
    var currentEncounterIndex:Int?
    var previousEncounterIndex:Int?
    
    //each encounter is an sknode - store in an array
    var encounters:[SKNode] = []
    
    init() {
        //loop through names
        for encounterFileName in encounterNames {
            //create a new node for each encounter
            let encounter = SKNode()
            
            //load encounter into an SKScene
            if let encounterScene = SKScene(fileNamed: encounterFileName) {
                
                //loop through each placeholder node in the file and create game objects
                for placeholder in encounterScene.children {
                    
                    //ensure placeholder is of type SKNode
                    if let node = placeholder as? SKNode {
                        
                        switch node.name! {
                        case "Bat":
                            let bat = Bat()
                            bat.spawn(encounter, position: node.position)
                        case "Bee":
                            let bee = Bee()
                            bee.spawn(encounter, position: node.position)
                        case "Blade":
                            let blade = Blade()
                            blade.spawn(encounter, position: node.position)
                            
                        case "Ghost":
                            let ghost = Ghost()
                            ghost.spawn(encounter, position: node.position)
                        case "MadFly":
                            let madFly = MadFly()
                            madFly.spawn(encounter, position: node.position)
                        case "GoldCoin":
                            let coin = Coin()
                            coin.spawn(encounter, position: node.position)
                            coin.turnToGold()
                        case "BronzeCoin":
                            let coin = Coin()
                            coin.spawn(encounter, position: node.position)
                        default:
                            println("Name error \(node.name)")
                        }
                    }
                }
            }
            // add populated encounter node to array
            encounters.append(encounter)
            
            // Save initial sprite locations for this encounter
            saveSpritePosition(encounter)
        }
    }
    
    
    //game scene will call this function to add encounters to our world
    func addEncountersToWorld(world:SKNode) {
        for index in 0 ... encounters.count-1 {
            //spawn encounters behind the action with increasing height so they dont collide (?)
            encounters[index].position = CGPoint(x: -2000, y: index*1000)
            world.addChild(encounters[index])
        }
    }
    
    //store initial location of all sprites in an encounter
    func saveSpritePosition(node:SKNode) {
        for sprite in node.children {
            if let spriteNode = sprite as? SKSpriteNode {
                let initialPosition = NSValue(CGPoint: sprite.position)
                spriteNode.userData = ["initialPosition" : initialPosition]
                
                //save initial positions for this node's children as well
                saveSpritePosition(spriteNode)
            }
        }
    }
    
    // Reset all children nodes to original position
    func resetSpritePosition(node:SKNode) {
        for sprite in node.children {
            if let spriteNode = sprite as? SKSpriteNode {
                
                // Remove angular and/or linear velocity
                spriteNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                spriteNode.physicsBody?.angularVelocity = 0
                
                // Reset rotation
                spriteNode.zRotation = 0
                
                if let initialPosition = spriteNode.userData?.valueForKey("initialPosition") as? NSValue {
                    // Reset position
                    spriteNode.position = initialPosition.CGPointValue()
                }
                
                // Reset initial positions for this node's children as well
                resetSpritePosition(spriteNode)
            }
        }
    }
    
    func placeNextEncounter(currentXPos:CGFloat) {
        // count the encounters in a random-ready type
        let encounterCount = UInt32(encounters.count)
        
        // Requires a min of 3 encounters, so exit if not present
        if encounterCount < 3 { return }
        
        // Pick an encounter that is not currently on screen
        var nextEncounterIndex:Int?
        var trulyNew:Bool?
        
        while trulyNew == false || trulyNew == nil {
            // Pick random encounter
            nextEncounterIndex = Int(arc4random_uniform(encounterCount))
            
            // Assert that this is a new encounter
            trulyNew = true
            
            // Test if it is the current encounter
            if let currentIndex = currentEncounterIndex {
                if (nextEncounterIndex == currentIndex) {
                    trulyNew = false
                }
            }
            
            // Test if directly previous encounter
            if let previousIndex = previousEncounterIndex {
                if (nextEncounterIndex == previousIndex) {
                    trulyNew = false
                }
            }
        }
        
        // Keep track of current encounter
        previousEncounterIndex = currentEncounterIndex
        currentEncounterIndex = nextEncounterIndex
        
        // Reset the new encounter and position ahead of player...
        let encounter = encounters[currentEncounterIndex!]
        encounter.position = CGPoint(x: currentXPos + 1000, y: 0)
        resetSpritePosition(encounter)
    }
}
