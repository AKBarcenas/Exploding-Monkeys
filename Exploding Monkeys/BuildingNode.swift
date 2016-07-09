//
//  BuildingNode.swift
//  Exploding Monkeys
//
//  Created by Alex on 7/8/16.
//  Copyright © 2016 Alex Barcenas. All rights reserved.
//

import SpriteKit
import UIKit
import GameplayKit

class BuildingNode: SKSpriteNode {
    // The current image that is being used.
    var currentImage: UIImage!
    
    /*
     * Function Name: setup
     * Parameters: None
     * Purpose: This method creates a bulding node using the size constraints of the node.
     * Return Value: None
     */
    
    func setup() {
        name = "building"
        
        currentImage = drawBuilding(size)
        texture = SKTexture(image: currentImage)
        
        configurePhysics()
    }
    
    /*
     * Function Name: configurePhysics
     * Parameters: None
     * Purpose: This method configures the physics properties of the building node.
     * Return Value: None
     */
    
    func configurePhysics() {
        physicsBody = SKPhysicsBody(texture: texture!, size: size)
        physicsBody!.dynamic = false
        physicsBody!.categoryBitMask = CollisionTypes.Building.rawValue
        physicsBody!.contactTestBitMask = CollisionTypes.Banana.rawValue
    }
    
    /*
     * Function Name: drawBuilding
     * Parameters: size - the size of the context we are drawing in.
     * Purpose: This method chooses random colors for windows and walls for a building and
     *   draws it into the context to create an image.
     * Return Value: UIImage
     */
    
    func drawBuilding(size: CGSize) -> UIImage {
        // 1
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        // 2
        let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        var color: UIColor
        
        switch GKRandomSource.sharedRandom().nextIntWithUpperBound(3) {
        case 0:
            color = UIColor(hue: 0.502, saturation: 0.98, brightness: 0.67, alpha: 1)
        case 1:
            color = UIColor(hue: 0.999, saturation: 0.99, brightness: 0.67, alpha: 1)
        default:
            color = UIColor(hue: 0, saturation: 0, brightness: 0.67, alpha: 1)
        }
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextAddRect(context, rectangle)
        CGContextDrawPath(context, .Fill)
        
        // 3
        let lightOnColor = UIColor(hue: 0.190, saturation: 0.67, brightness: 0.99, alpha: 1)
        let lightOffColor = UIColor(hue: 0, saturation: 0, brightness: 0.34, alpha: 1)
        
        for row in 10.stride(to: Int(size.height - 10), by: 40) {
            for col in 10.stride(to: Int(size.width - 10), by: 40) {
                if RandomInt(min: 0, max: 1) == 0 {
                    CGContextSetFillColorWithColor(context, lightOnColor.CGColor)
                } else {
                    CGContextSetFillColorWithColor(context, lightOffColor.CGColor)
                }
                
                CGContextFillRect(context, CGRect(x: col, y: row, width: 15, height: 20))
            }
        }
        
        // 4
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img
    }
}
