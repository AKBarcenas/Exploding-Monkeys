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

class GameScene: SKScene, SKPhysicsContactDelegate {
    // Stores all off the building nodes that are being used.
    var buildings = [BuildingNode]()
    // The view controller handling the game scene.
    weak var viewController: GameViewController!
    
    // The sprite representing player 1.
    var player1: SKSpriteNode!
    // The sprite representing player 2.
    var player2: SKSpriteNode!
    // The sprite representing a banana.
    var banana: SKSpriteNode!
    
    // The current player that is in control.
    var currentPlayer = 1
    
    /*
     * Function Name: didMoveToView
     * Parameters: view - the view being moved to.
     * Purpose: This method sets up the visual environment for the game.
     * Return Value: None
     */
    
    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
        
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        
        createBuildings()
        createPlayers()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

    }
   
    /*
     * Function Name: update
     * Parameters: currentTime - the current system time.
     * Purpose: This method removes any bananas that are out of view.
     * Return Value: None
     */
    
    override func update(currentTime: CFTimeInterval) {
        if banana != nil {
            if banana.position.y < -1000 {
                banana.removeFromParent()
                banana = nil
                
                changePlayer()
            }
        }
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
    
    /*
     * Function Name: launch
     * Parameters: angle - the angle of the launch.
     *   velocity - the velocity of the launch.
     * Purpose: This method launches a banana based on the angle and velocity decribing the
     *   launch of the banana. The monkey launching the banana is also animated during the launch.
     * Return Value: None
     */
    
    func launch(angle angle: Int, velocity: Int) {
        // 1
        let speed = Double(velocity) / 10.0
        
        // 2
        let radians = deg2rad(angle)
        
        // 3
        if banana != nil {
            banana.removeFromParent()
            banana = nil
        }
        
        banana = SKSpriteNode(imageNamed: "banana")
        banana.name = "banana"
        banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width / 2)
        banana.physicsBody!.categoryBitMask = CollisionTypes.Banana.rawValue
        banana.physicsBody!.collisionBitMask = CollisionTypes.Building.rawValue | CollisionTypes.Player.rawValue
        banana.physicsBody!.contactTestBitMask = CollisionTypes.Building.rawValue | CollisionTypes.Player.rawValue
        banana.physicsBody!.usesPreciseCollisionDetection = true
        addChild(banana)
        
        if currentPlayer == 1 {
            // 4
            banana.position = CGPoint(x: player1.position.x - 30, y: player1.position.y + 40)
            banana.physicsBody!.angularVelocity = -20
            
            // 5
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player1Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.waitForDuration(0.15)
            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
            player1.runAction(sequence)
            
            // 6
            let impulse = CGVector(dx: cos(radians) * speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
        }
        
        else {
            // 7
            banana.position = CGPoint(x: player2.position.x + 30, y: player2.position.y + 40)
            banana.physicsBody!.angularVelocity = 20
            
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player2Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.waitForDuration(0.15)
            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
            player2.runAction(sequence)
            
            let impulse = CGVector(dx: cos(radians) * -speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
        }
    }
    
    /*
     * Function Name: createPlayers
     * Parameters: None
     * Purpose: This method creates the player nodes and changes their physics bodies.
     *   These nodes are then placed in the scene.
     * Return Value: None
     */
    
    func createPlayers() {
        player1 = SKSpriteNode(imageNamed: "player")
        player1.name = "player1"
        player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width / 2)
        player1.physicsBody!.categoryBitMask = CollisionTypes.Player.rawValue
        player1.physicsBody!.collisionBitMask = CollisionTypes.Banana.rawValue
        player1.physicsBody!.contactTestBitMask = CollisionTypes.Banana.rawValue
        player1.physicsBody!.dynamic = false
        
        let player1Building = buildings[1]
        player1.position = CGPoint(x: player1Building.position.x, y: player1Building.position.y + ((player1Building.size.height + player1.size.height) / 2))
        addChild(player1)
        
        player2 = SKSpriteNode(imageNamed: "player")
        player2.name = "player2"
        player2.physicsBody = SKPhysicsBody(circleOfRadius: player2.size.width / 2)
        player2.physicsBody!.categoryBitMask = CollisionTypes.Player.rawValue
        player2.physicsBody!.collisionBitMask = CollisionTypes.Banana.rawValue
        player2.physicsBody!.contactTestBitMask = CollisionTypes.Banana.rawValue
        player2.physicsBody!.dynamic = false
        
        let player2Building = buildings[buildings.count - 2]
        player2.position = CGPoint(x: player2Building.position.x, y: player2Building.position.y + ((player2Building.size.height + player2.size.height) / 2))
        addChild(player2)
    }
    
    /*
     * Function Name: deg2rad
     * Parameters: degrees - the degree amount we want to convert.
     * Purpose: This method converts some amount of degrees into radians.
     *   These nodes are then placed in the scene.
     * Return Value: None
     */
    
    func deg2rad(degrees: Int) -> Double {
        return Double(degrees) * M_PI / 180.0
    }
    
    /*
     * Function Name: didBeginContact
     * Parameters: contact - the contact that occurred.
     * Purpose: This method determines what two objects came into contact and responds
     *   accordingly to what objects came into contact.
     * Return Value: None
     */
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        
        else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if let firstNode = firstBody.node {
            if let secondNode = secondBody.node {
                if firstNode.name == "banana" && secondNode.name == "building" {
                    bananaHitBuilding(secondNode as! BuildingNode, atPoint: contact.contactPoint)
                }
                
                if firstNode.name == "banana" && secondNode.name == "player1" {
                    destroyPlayer(player1)
                }
                
                if firstNode.name == "banana" && secondNode.name == "player2" {
                    destroyPlayer(player2)
                }
            }
        }
    }
    
    /*
     * Function Name: destroyPlayer
     * Parameters: player - the player that was destroyed.
     * Purpose: This method animates the destruction of a player and transitions to a new
     *   game scene after a delay.
     * Return Value: None
     */
    
    func destroyPlayer(player: SKSpriteNode) {
        let explosion = SKEmitterNode(fileNamed: "hitPlayer")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        banana?.removeFromParent()
        
        RunAfterDelay(2) { [unowned self] in
            let newGame = GameScene(size: self.size)
            newGame.viewController = self.viewController
            self.viewController.currentGame = newGame
            
            self.changePlayer()
            newGame.currentPlayer = self.currentPlayer
            
            let transition = SKTransition.doorwayWithDuration(1.5)
            self.view?.presentScene(newGame, transition: transition)
            
        }
    }
    
    /*
     * Function Name: changePlayer
     * Parameters: None
     * Purpose: This method changes the player that is currently in control.
     * Return Value: None
     */
    
    func changePlayer() {
        if currentPlayer == 1 {
            currentPlayer = 2
        }
        
        else {
            currentPlayer = 1
        }
        
        viewController.activatePlayerNumber(currentPlayer)
    }
    
    /*
     * Function Name: bananaHitBuilding
     * Parameters: building - the building that was hit.
     *   contactPoint - the point where the building was hit.
     * Purpose: This method creates an animation where the building was hit and changes
     *   the player control.
     * Return Value: None
     */
    
    func bananaHitBuilding(building: BuildingNode, atPoint contactPoint: CGPoint) {
        let buildingLocation = convertPoint(contactPoint, toNode: building)
        building.hitAtPoint(buildingLocation)
        
        let explosion = SKEmitterNode(fileNamed: "hitBuilding")!
        explosion.position = contactPoint
        addChild(explosion)
        
        banana.name = ""
        banana?.removeFromParent()
        banana = nil
        
        changePlayer()
    }
}
