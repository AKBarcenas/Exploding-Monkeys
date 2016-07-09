//
//  GameViewController.swift
//  Exploding Monkeys
//
//  Created by Alex on 7/8/16.
//  Copyright (c) 2016 Alex Barcenas. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    // The game scene handling the game.
    var currentGame: GameScene!

    // The slider manipulating the angle.
    @IBOutlet weak var angleSlider: UISlider!
    // The label displaying the angle.
    @IBOutlet weak var angleLabel: UILabel!
    // The slider manipulating the velocity.
    @IBOutlet weak var velocitySlider: UISlider!
    // The label displaying the velocity.
    @IBOutlet weak var velocityLabel: UILabel!
    // The button user for launching.
    @IBOutlet weak var launchButton: UIButton!
    // The label displaying the current player.
    @IBOutlet weak var playerNumber: UILabel!
    
    /*
     * Function Name: viewDidLoad
     * Parameters: None
     * Purpose: This method sets up the user interface.
     * Return Value: None
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        angleChanged(angleSlider)
        velocityChanged(velocitySlider)

        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
            
            currentGame = scene
            scene.viewController = self
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    /*
     * Function Name: angleChanged
     * Parameters: sender - the slider that called this method.
     * Purpose: This method changes the angle displayed as the angle slider moves.
     * Return Value: None
     */
    
    @IBAction func angleChanged(sender: AnyObject!) {
        angleLabel.text = "Angle: \(Int(angleSlider.value))°"
    }
    
    /*
     * Function Name: velocityChanged
     * Parameters: sender - the slider that called this method.
     * Purpose: This method changes the velocity displayed as the velocity slider moves.
     * Return Value: None
     */
    
    @IBAction func velocityChanged(sender: AnyObject!) {
        velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
    }
    
    /*
     * Function Name: launch
     * Parameters: sender - the button that called this method.
     * Purpose: This method prevents another launch from occurring while
     *   the current launch executes.
     * Return Value: None
     */
    
    @IBAction func launch(sender: AnyObject) {
        angleSlider.hidden = true
        angleLabel.hidden = true
        
        velocitySlider.hidden = true
        velocityLabel.hidden = true
        
        launchButton.hidden = true
        
        currentGame.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
    }
    
    /*
     * Function Name: activatePlayerNumber
     * Parameters: number - the number of the player now launching.
     * Purpose: This method changes the active player that is launching based on the number passed in.
     * Return Value: None
     */
    
    func activatePlayerNumber(number: Int) {
        if number == 1 {
            playerNumber.text = "<<< PLAYER ONE"
        }
        
        else {
            playerNumber.text = "PLAYER TWO >>>"
        }
        
        angleSlider.hidden = false
        angleLabel.hidden = false
        
        velocitySlider.hidden = false
        velocityLabel.hidden = false
        
        launchButton.hidden = false
    }
}
