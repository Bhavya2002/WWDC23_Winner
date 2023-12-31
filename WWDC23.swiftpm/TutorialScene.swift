//
//  TutorialScene.swift
//  Find3
//
//  Created by Bhavya Bhatia
//

import SpriteKit

/// Subclass of GameScene used in tutorial. Overrides animation for valid group selection.
class TutorialScene: GameScene {
    
    /// Perform animation when user selects a valid group
    override func animateValidGroup(_ group: PictureGroup, completion: @escaping () -> ()) {
        
        let expandAction = SKAction.run {
            group.pictureA.runTutorialValidGroupAction()
            group.pictureB.runTutorialValidGroupAction()
            group.pictureC.runTutorialValidGroupAction()
        }
        
        run(SKAction.sequence([expandAction, SKAction.wait(forDuration: 1.0)]), completion: completion)
    }
    
}
