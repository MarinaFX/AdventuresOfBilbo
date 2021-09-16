//
//  ScenerySizesLevel1.swift
//  AdventuresOfBilbo
//
//  Created by Natália Brocca dos Santos on 14/09/21.
//

import Foundation
import SpriteKit

enum SceneryObstacles: Int {
    case trunk = 0
    case cucumber = 1
    case lamp = 2
    
    var imageObstacles: String {
        switch self {
        case .trunk:
            return "trunk"
        case .cucumber:
            return "cucumber"
        case .lamp:
            return "lamp"
        }
    }
    
    var size: CGSize {
        switch self {
        case .trunk:
            return CGSize(width: 50, height: 90)
        case .cucumber:
            return CGSize(width: 70, height: 20)
        case .lamp:
            return CGSize(width: 63, height: 125)
        }
    }
    
    var positionType: PositionType {
        switch self {
        case .trunk:
            return .floor
        case .cucumber:
            return .floor
        case .lamp:
            return .air
        }
    }
}

enum PositionType {
    case air
    case floor
}
