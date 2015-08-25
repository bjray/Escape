//
//  GameSprite.swift
//  Escape
//
//  Created by Bj Ray on 8/21/15.
//  Copyright (c) 2015 Bj Ray. All rights reserved.
//

import SpriteKit

protocol GameSprite {
    var textureAtlas: SKTextureAtlas {get set}
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize)
    func onTap()
}
