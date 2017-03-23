//
//  welcome.swift
//  SpaceInvaders
//
//  Created by Levesque Frederic on 3/22/17.
//  Copyright © 2017 Levesque Frederic. All rights reserved.
//

import SpriteKit
import GameplayKit

class welcome: SKScene{
    
    override func didMove(to view: SKView){
        
        let button = SKSpriteNode(color: SKColor.green, size: CGSize(width: 100, height: 44))
        //put it on the center of scene
        button.position = CGPoint(x: size.width * 0.1, y: size.height * 0.1)
        button.name = "welcomeScene"
        button.size = CGSize(width: button.size.width * 0.8, height: button.size.height * 0.8)
        button.isHidden = false
        
        addChild(button)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let location = touches.first?.location(in:self){
            let touchedNode = atPoint(location)
            
            if touchedNode.name == "welcomeScene"
            {
                let transition = SKTransition.flipVertical(withDuration: 2.0)
                let nextScene = GameScene(size: (view?.frame.size)!)
                nextScene.scaleMode = SKSceneScaleMode.aspectFill
                
                self.scene?.view?.presentScene(nextScene, transition: transition)
                
                
                print("hit")
            }
        }
    }
    
}
