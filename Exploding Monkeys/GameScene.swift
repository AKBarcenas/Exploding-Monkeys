//
//  GameScene.swift
//  Exploding Monkeys
//
//  Created by Alex on 7/8/16.
//  Copyright (c) 2016 Alex Barcenas. All rights reserved.
//

import SpriteKit

enum CollisionTypes: UInt32 {
    case Banana = 1
    case Building = 2
    case Player = 4
}

class GameScene: SKScene {
    // Stores all off the building nodes that are being used.
    var buildings = [BuildingNode]()
    // The view controller handling the game scene.
    weak var viewController: GameViewController!
    
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        
        createBuildings()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    /*
     * Function Name: createBuildings
     * Parameters: None
     * Purpose: This method creates buildings of random size to display.
     * Return Value: None
     */
    
    func createBuildings() {
        var currentX: CGFloat = -15
        
        while currentX < 1024 {
            let size = CGSize(width: RandomInt(min: 2, max: 4) * 40, height: RandomInt(min: 300, max: 600))
            currentX += size.width + 2
            
            let building = BuildingNode(color: UIColor.redColor(), size: size)
            building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
            building.setup()
            addChild(building)
            
            buildings.append(building)
        }
    }
    
    func launch(angle angle: Int, velocity: Int) {
    }
}
