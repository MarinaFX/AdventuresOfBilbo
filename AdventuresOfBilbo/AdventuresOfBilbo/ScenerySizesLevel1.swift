//
//  ScenerySizesLevel1.swift
//  AdventuresOfBilbo
//
//  Created by Natália Brocca dos Santos on 14/09/21.
//

import Foundation
import SpriteKit

enum ScenerySizesLevel1 {
    case floor
    case midFloor
    case ceiling
    case startingWall
    
    var size: CGSize {
        switch self {
        case .floor:
            return CGSize(width: ((UIScreen.main.bounds.width) * 2), height: 20)
        case .midFloor:
            return CGSize(width: ((UIScreen.main.bounds.width) + ((UIScreen.main.bounds.width) * 0.3)), height: 20)
        case .ceiling:
            return CGSize(width: ((UIScreen.main.bounds.width) * 2) + ((UIScreen.main.bounds.width) * 0.4), height: 20)
        case .startingWall:
            return CGSize (width: 20, height: ((UIScreen.main.bounds.height) * 0.9))
        }
    }
}
