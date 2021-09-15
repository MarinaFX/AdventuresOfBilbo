//
//  ScenerySizesLevel1.swift
//  AdventuresOfBilbo
//
//  Created by Natália Brocca dos Santos on 14/09/21.
//

import Foundation
import SpriteKit

enum SceneryObstacles: Int {
    case floorObstacle1 = 1
    case floorObstacle2 = 2
    case airObstacle = 3
    
    var imageObstacles: String {
        switch self {
        case .floorObstacle1:
            return "trunk"
        case .floorObstacle2:
            return "cucumber"
        case .airObstacle:
            return "lamp"
        }
    }
}
