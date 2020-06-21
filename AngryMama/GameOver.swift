//
//  GameOverScene.swift
//
//  Created by Das Tarlochan Preet Singh on 2020-06-12.
//  Copyright © 2020 Tarlochan5268. All rights reserved.
//
import Foundation
import SpriteKit
class GameOver: SKScene {
 let won:Bool
let scoresLabel = SKLabelNode(fontNamed: "Chalkduster")

init(size: CGSize, won: Bool) {
 self.won = won
 super.init(size: size)
 }

 required init(coder aDecoder: NSCoder) {
 fatalError("init(coder:) has not been implemented")
 }
    
    override func didMove(to view: SKView)
    {
        var background: SKSpriteNode
        if (won) {
                background = SKSpriteNode(imageNamed: "gameWin-1")
                background.anchorPoint = CGPoint.zero
                background.position = CGPoint.zero
                background.size = size
                run(SKAction.playSoundFileNamed("win.wav",
                waitForCompletion: false))
        }
        else {
                background = SKSpriteNode(imageNamed: "gameLose-1")
                background.anchorPoint = CGPoint.zero
                background.position = CGPoint.zero
                background.size = size
                run(SKAction.playSoundFileNamed("lose.wav",
                waitForCompletion: false))
                }

                
                 let wait = SKAction.wait(forDuration: 3.0)
                 let block = SKAction.run
                 {
                     let myScene = GameScene(size: self.size)
                     myScene.scaleMode = self.scaleMode
                     let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                     self.view?.presentScene(myScene, transition: reveal)
                }
                self.run(SKAction.sequence([wait, block]))
        
                if(won)
                {
                    scoresLabel.text = "You Won the Game"
                }
                else
                {
                    scoresLabel.text = "You Lost the Game"
                }
                self.addChild(background)
                scoresLabel.fontColor = SKColor.red
                scoresLabel.fontSize = 60
                scoresLabel.zPosition = 150
                scoresLabel.horizontalAlignmentMode = .center
                scoresLabel.verticalAlignmentMode = .center
                scoresLabel.position = CGPoint(x: 1000, y: 150)
                self.addChild(scoresLabel)
    }
    
    
}
