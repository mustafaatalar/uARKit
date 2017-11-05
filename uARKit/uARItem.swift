//
//  uARItem.swift
//  framework-test3
//
//  Created by Mustafa Atalar on 25.10.2017.
//  Copyright © 2017 Mustafa Atalar. All rights reserved.
//

import ARKit

struct coordinate {
    public var top : Float
    public var right : Float
    public var front : Float
}

struct gpsCoordinate {
    public var lat : Float
    public var lon : Float
    public var alt : Float
}

enum ItemType{
    case image
    case label
    case video
}

enum PositionType{
    case coordinate
    //case coordinate_relative
    //case coordinate_compass
    case facing_me
    case gps
    case hitTest
    case detected_plane
}

class uARItem {
    var itemId: Int? = 0
    var type: ItemType? = nil
    var positionType: PositionType = .facing_me
    var position=coordinate(top: 0.0, right: 0.0, front: 1.0)
    var gpsPosition=gpsCoordinate(lat: 0.0, lon: 0.0, alt: 0.0)
    var hitPoint: CGPoint = CGPoint(x: 0.5, y: 0.5)
    var planeNumber = 1
    var placedPlaneCount = 0
    var itemObject: SKNode? = nil
    var lightingFactor: Float = 0.0
    var anchorID: UUID
    var isShown: Bool = false
    
    public func setPosition(top: Float, right: Float, front: Float){
        position.front=front
        position.right=right
        position.top=top
    }
    
    init(itemId: Int, type: ItemType, position: coordinate, positionType: PositionType, itemObject: SKNode){
        self.itemId = itemId
        self.type = type
        self.position = position
        self.itemObject = itemObject
        self.anchorID = UUID()
        self.positionType = positionType
    }
}

