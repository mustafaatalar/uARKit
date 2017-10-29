//
//  uARItem.swift
//  framework-test3
//
//  Created by Mustafa Atalar on 25.10.2017.
//  Copyright © 2017 Mustafa Atalar. All rights reserved.
//

import Foundation
import ARKit

struct coordinate {
    public var top : Float
    public var right : Float
    public var front : Float
}

enum ItemType{
    case image
    case label
    case video
}

class uARItem {
    var itemId: Int? = 0
    var type: ItemType? = nil
    var position=coordinate(top: 0.0, right: 0.0, front: 1.0)
    var itemObject: SKNode? = nil
    var lightingFactor: Float = 0.0
    var anchorID: UUID
    
    init(itemId: Int, type: ItemType, position: coordinate, itemObject: SKNode, lightingFactor: Float){
        self.itemId = itemId
        self.type = type
        self.position = position
        self.itemObject = itemObject
        self.lightingFactor = lightingFactor
        self.anchorID = UUID()
    }
    
    public func setPosition(top: Float, right: Float, front: Float){
        position.front=front
        position.right=right
        position.top=top
    }
    
    
}

