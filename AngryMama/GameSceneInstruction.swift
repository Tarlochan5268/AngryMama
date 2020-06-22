//
//  GameSceneInstruction.swift
//  AngryMama
//
//  Created by Das Tarlochan Preet Singh on 2020-06-21.
//  Copyright © 2020 Tarlochan5268. All rights reserved.
//

import Foundation
import SpriteKit
class GameSceneInstruction: SKScene {
 let levelwon:Int

    init(size: CGSize, levelwon: Int) {
 self.levelwon = levelwon
 super.init(size: size)
 }

 required init(coder aDecoder: NSCoder) {
 fatalError("init(coder:) has not been implemented")
 }
    
    override func didMove(to view: SKView)
    {
        var background: SKSpriteNode = SKSpriteNode(imageNamed: "InstructionToLevel2-1")
        if (levelwon == 1) {
                background = SKSpriteNode(imageNamed: "InstructionToLevel2-1")
                background.anchorPoint = CGPoint.zero
                background.position = CGPoint.zero
                background.size = size
                run(SKAction.playSoundFileNamed("win.wav",waitForCompletion: false))
                let wait = SKAction.wait(forDuration: 3.0)
                 
                let block = SKAction.run
                 {
                     let myScene = GameScene2(size: self.size)
                     myScene.scaleMode = self.scaleMode
                     let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                     self.view?.presentScene(myScene, transition: reveal)
                }
                self.run(SKAction.sequence([wait, block]))
        }
        else if(levelwon == 2){
                background = SKSpriteNode(imageNamed: "InstructiontoLevel3-1")
                background.anchorPoint = CGPoint.zero
                background.position = CGPoint.zero
                background.size = size
                run(SKAction.playSoundFileNamed("win.wav",
                waitForCompletion: false))
                let wait = SKAction.wait(forDuration: 3.0)
                 
                let block = SKAction.run
                 {
                     let myScene = GameScene3(size: self.size)
                     myScene.scaleMode = self.scaleMode
                     let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                     self.view?.presentScene(myScene, transition: reveal)
                }
                self.run(SKAction.sequence([wait, block]))
                }

                self.addChild(background)
    }
}
