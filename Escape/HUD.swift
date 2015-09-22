//
//  HUD.swift
//  Escape
//
//  Created by B.J. Ray on 9/22/15.
//  Copyright © 2015 Bj Ray. All rights reserved.
//

import SpriteKit

class HUD: SKNode {
    var textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "hud.atlas")
    var heartNodes:[SKSpriteNode] = []
    let coinCountText = SKLabelNode(text: "000000")
    
    func createHudNodes(screenSize:CGSize) {
        // -- Create the coin counter --
        let coinTextureAtlas:SKTextureAtlas = SKTextureAtlas(named: "goods.atlas")
        let coinIcon = SKSpriteNode(texture: coinTextureAtlas.textureNamed("coin-bronze.png"))
        
        // size and position coin
        let coinYPos = screenSize.height - 23
        coinIcon.size = CGSize(width: 26, height: 26)
        coinIcon.position = CGPoint(x: 23, y: coinYPos)
        
        // config coin label
        coinCountText.fontName = "AvenirNext-HeavyItalic"
        coinCountText.position = CGPoint(x: 41, y: coinYPos)
        
        // align text relative to node's position
        coinCountText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        coinCountText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        
        // add the text and coin icons to HUD
        self.addChild(coinCountText)
        self.addChild(coinIcon)
        
        //create three hearts as life monitor
        for var index = 0; index < 3; ++index {
            let newHeartNode = SKSpriteNode(texture: textureAtlas.textureNamed("heart-full.png"))
            newHeartNode.size = CGSize(width: 64, height: 40)
            
            let xPos = CGFloat(index * 60 + 33)
            let yPos = screenSize.height - 66
            newHeartNode.position = CGPoint(x: xPos, y: yPos)
            
            // keep track of nodes in array prop
            heartNodes.append(newHeartNode)
            self.addChild(newHeartNode)
        }
    }
    
    func setCoinCountDisplay(newCoinCount:Int) {
        // We can use nsnumberformater class to padd leading 0's
        let formatter = NSNumberFormatter()
        formatter.minimumIntegerDigits = 6
        if let coinStr = formatter.stringFromNumber(newCoinCount) {
            coinCountText.text = coinStr
        }
    }
    
    func setHealthDisplay(newHealth:Int) {
        // create fade action to fade out lost heart
        let fadeAction = SKAction.fadeAlphaTo(0.2, duration: 0.3)
        
        // loop through each heart and update status...
        for var index = 0; index < heartNodes.count; ++index {
            if index < newHealth {
                heartNodes[index].alpha = 1
            } else {
                heartNodes[index].runAction(fadeAction)
            }
        }
    }
}
