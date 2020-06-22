//
//  GameScene.swift
//  AngryMama
//
//  Created by Das Tarlochan Preet Singh on 2020-06-21.
//  Copyright © 2020 Tarlochan5268. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene2: SKScene {
    let scoresLabel = SKLabelNode(fontNamed: "Chalkduster")
  var healthbar = SKSpriteNode(imageNamed: "HM10-1")
  let boy = SKSpriteNode(imageNamed: "BoyRun1")
    var objcounter = 0
    var heartcounter = 0
    var scoreCount = 0;
    var mama = SKSpriteNode(imageNamed: "GirlMeele5")
  var lastUpdateTime: TimeInterval = 0
  var dt: TimeInterval = 0
  let boyMovePointsPerSec: CGFloat = 480.0
  var velocity = CGPoint.zero
  let playableRect: CGRect
  var lastTouchLocation: CGPoint?
  let boyRotateRadiansPerSec:CGFloat = 4.0 * π
  let boyAnimation: SKAction
    let mamaAnimation: SKAction
  let objectCollisionSound: SKAction = SKAction.playSoundFileNamed(
    "knifehit.mp3", waitForCompletion: false)
    let heartCollisionSound: SKAction = SKAction.playSoundFileNamed(
    "hearthit.mp3", waitForCompletion: false)
  var invincible = false
  var lives = 10
  var gameOver = false
  //let cameraNode = SKCameraNode()
  //let cameraMovePointsPerSec: CGFloat = 200.0

  
  
  
  
  override func didMove(to view: SKView) {

    playBackgroundMusic(filename: "BGMusicOption2.mp3")
  
      let background = SKSpriteNode(imageNamed: "CampGameBg1-1")
      background.anchorPoint = CGPoint.zero
    background.position = CGPoint.zero
      background.name = "CampGameBg1-1"
    background.size = CGSize(width: 2048, height: 1536)
      background.zPosition = -1
      addChild(background)
    
    boy.position = CGPoint(x: 200, y: 400)
    boy.zPosition = 100
    boy.setScale(0.5)
    addChild(boy)
    // boy.run(SKAction.repeatForever(boyAnimation))
    spawnHealthBar(imageNamed: "HM10-1")
    run(SKAction.repeatForever(
      SKAction.sequence([SKAction.run() { [weak self] in
                      self?.spawnMama()
                    },
                    SKAction.wait(forDuration: 2.0)])))
    scoresLabel.text = "Score : \(scoreCount)"
    scoresLabel.fontColor = SKColor.red
    scoresLabel.fontSize = 100
    scoresLabel.zPosition = 150
    scoresLabel.horizontalAlignmentMode = .left
    scoresLabel.verticalAlignmentMode = .bottom
    scoresLabel.position = CGPoint(
        x: playableRect.maxX - 750,
        y: playableRect.maxY - 40)
    self.addChild(scoresLabel)
  }
  
    func healthBarRespawn()
    {
        if(lives == 9){
               spawnHealthBar(imageNamed: "HM9-1")}
           else if(lives == 8){spawnHealthBar(imageNamed: "HM8-1")}
           else if(lives == 7){spawnHealthBar(imageNamed: "HM7-1")}
           else if(lives == 6){spawnHealthBar(imageNamed: "HM6-1")}
           else if(lives == 5){spawnHealthBar(imageNamed: "HM5-1")}
           else if(lives == 4){spawnHealthBar(imageNamed: "HM4-1")}
           else if(lives == 3){spawnHealthBar(imageNamed: "HM3-1")}
           else if(lives == 2){spawnHealthBar(imageNamed: "HM2-1")}
           else if(lives == 1){spawnHealthBar(imageNamed: "HM1-1")}
           else if(lives == 0){spawnHealthBar(imageNamed: "HM0-1")}
           
    }
  override func update(_ currentTime: TimeInterval) {
    
   
    scoresLabel.text = "Score : \(scoreCount)"
    healthBarRespawn()
    
    
    if lastUpdateTime > 0 {
      dt = currentTime - lastUpdateTime
    } else {
      dt = 0
    }
    lastUpdateTime = currentTime
  
        move(sprite: boy, velocity: velocity)
  
    boundsCheckboy()
    
    if lives <= 0 && !gameOver {
      gameOver = true
      print("You lose!")
      backgroundMusicPlayer.stop()
      
      // 1
      let gameOverScene = GameOver(size: size, won: false)
      gameOverScene.scaleMode = scaleMode
      // 2
      let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
      // 3
      view?.presentScene(gameOverScene, transition: reveal)
    }
    if lives > 0 && !gameOver && scoreCount == 15 {
      gameOver = true
      print("You Go to Level 3!")
      backgroundMusicPlayer.stop()
      let gameScene3 = GameSceneInstruction(size:CGSize(width: 2048, height: 1536),levelwon: 2)
      
        //let skView = self.view!// SpriteKit makes no guarantee as to the order in which a node draws its child nodes that share the same zPosition.
      gameScene3.scaleMode = .aspectFill
      view?.presentScene(gameScene3)
        
    }
    
  }
  
    // Change later
    
    override init(size: CGSize) {
      let maxAspectRatio:CGFloat = 16.0/9.0
      let playableHeight = size.width / maxAspectRatio
      let playableMargin = (size.height-playableHeight)/2.0
      playableRect = CGRect(x: 0, y: playableMargin,
                            width: size.width,
                            height: playableHeight)
      
      // 1
      var textures:[SKTexture] = []
      // 2
      for i in 1...15 {
        textures.append(SKTexture(imageNamed: "BoyRun\(i)"))
      }
      // 3
        textures.append(textures[13])
        textures.append(textures[12])
        textures.append(textures[11])
        textures.append(textures[10])
        textures.append(textures[9])
        textures.append(textures[8])
        textures.append(textures[7])
        textures.append(textures[6])
        textures.append(textures[5])
        textures.append(textures[4])
        textures.append(textures[3])
      textures.append(textures[2])
      textures.append(textures[1])
      // 4
      boyAnimation = SKAction.animate(with: textures,
        timePerFrame: 0.1)
        
        // 1
        let texturesMama:[SKTexture] = [SKTexture(imageNamed: "GirlMeele5"),SKTexture(imageNamed: "GirlMeele4"),SKTexture(imageNamed: "GirlMeele3")]
        mamaAnimation = SKAction.animate(with: texturesMama,timePerFrame: 0.2)
    
      super.init(size: size)
    }

    required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    func move(sprite: SKSpriteNode, velocity: CGPoint) {
      let amountToMove = CGPoint(x: velocity.x * CGFloat(dt),
                                 y: velocity.y * CGFloat(dt))
      sprite.position += amountToMove
    }
    
    func moveboyToward(location: CGPoint) {
      startboyAnimation()
        let loc = CGPoint(x: 0, y: location.y)
        let offset = loc - CGPoint(x: 0, y: boy.position.y) //up down movement
      let direction = offset.normalized()
      velocity = direction * boyMovePointsPerSec
    }
    
    func sceneTouched(touchLocation:CGPoint) {
      lastTouchLocation = touchLocation
      moveboyToward(location: touchLocation)
    }

    override func touchesBegan(_ touches: Set<UITouch>,
        with event: UIEvent?) {
      guard let touch = touches.first else {
        return
      }
      let touchLocation = touch.location(in: self)
      sceneTouched(touchLocation: touchLocation)
    }

    override func touchesMoved(_ touches: Set<UITouch>,
        with event: UIEvent?) {
      guard let touch = touches.first else {
        return
      }
      let touchLocation = touch.location(in: self)
      sceneTouched(touchLocation: touchLocation)
    }
    
    
    func boundsCheckboy() {
      let bottomLeft = CGPoint(x: playableRect.minX, y: playableRect.minY)
      let topRight = CGPoint(x: playableRect.maxX, y: playableRect.maxY)
        let topLeft = CGPoint(x: playableRect.minX, y: playableRect.maxY - 60)
      
      if boy.position.x <= bottomLeft.x {
        boy.position.x = bottomLeft.x
        velocity.x = abs(velocity.x)
      }
      if boy.position.x >= topRight.x {
        boy.position.x = topRight.x
        velocity.x = -velocity.x
      }
      if boy.position.y <= bottomLeft.y {
        boy.position.y = bottomLeft.y
        velocity.y = -velocity.y
      }
      if boy.position.y >= topRight.y {
        boy.position.y = topRight.y
        velocity.y = -velocity.y
      }
        if boy.position.y >= topLeft.y {
          boy.position.y = topLeft.y
          velocity.y = -velocity.y
        }
    }
    /*
    func rotate(sprite: SKSpriteNode, direction: CGPoint, rotateRadiansPerSec: CGFloat) {
      let shortest = shortestAngleBetween(angle1: sprite.zRotation, angle2: velocity.angle)
      let amountToRotate = min(rotateRadiansPerSec * CGFloat(dt), abs(shortest))
      sprite.zRotation += shortest.sign() * amountToRotate
    }
 */
    
    
    
    func startboyAnimation() {
      if boy.action(forKey: "animation") == nil {
        boy.run(
          SKAction.repeatForever(boyAnimation),
          withKey: "animation")
      }
    }

    func stopboyAnimation() {
      boy.removeAction(forKey: "animation")
    }
    
    func startmamaAnimation() {
      if mama.action(forKey: "animation") == nil {
        mama.run(
          SKAction.repeatForever(mamaAnimation),
          withKey: "animation")
      }
    }

    func stopmamaAnimation() {
      mama.removeAction(forKey: "animation")
    }
    
    func spawnobject(randomY: CGFloat) {
        var object = SKSpriteNode(imageNamed: "knife-1")
        if(objcounter == 1)
        {
            object = SKSpriteNode(imageNamed: "fork-1")
        }
        else if(objcounter == 2)
        {
            object = SKSpriteNode(imageNamed: "pan2-2")
        }
        else if(objcounter == 3)
        {
            object = SKSpriteNode(imageNamed: "spoon-1")
        }
        else
        {
            object = SKSpriteNode(imageNamed: "knife-1")
        }
        
        //let object = SKSpriteNode(imageNamed: "knife-1")
      object.position = CGPoint(
        x: playableRect.maxX + object.size.width/2,
        y: randomY)
      object.zPosition = 50
      object.name = "object"
        object.setScale(0.5)
      addChild(object)
      
      let actionMove =
        SKAction.moveBy(x: -(size.width + object.size.width), y: 0, duration: 3.0)
      let actionRemove = SKAction.removeFromParent()
      object.run(SKAction.sequence([actionMove, actionRemove]))
    }
    
    func spawnobjectknife(randomY: CGFloat) {
      let object = SKSpriteNode(imageNamed: "knife-1")
      object.position = CGPoint(
        x: playableRect.maxX + object.size.width/2,
        y: randomY)
      object.zPosition = 50
      object.name = "object"
        object.setScale(0.5)
      addChild(object)
      
      let actionMove =
        SKAction.moveBy(x: -(size.width + object.size.width), y: 0, duration: 3.0)
      let actionRemove = SKAction.removeFromParent()
      object.run(SKAction.sequence([actionMove, actionRemove]))
    }
    
    func spawnobjectheart(randomY: CGFloat) {
      let object = SKSpriteNode(imageNamed: "heartsmall")
      object.position = CGPoint(
        x: playableRect.maxX + object.size.width/2,
        y: randomY)
      object.zPosition = 50
      object.name = "heart"
        object.setScale(0.5)
      addChild(object)
      
      let actionMove =
        SKAction.moveBy(x: -(size.width + object.size.width), y: 0, duration: 3.0)
      let actionRemove = SKAction.removeFromParent()
      object.run(SKAction.sequence([actionMove, actionRemove]))
    }
    
    func spawnMama() {
      //let mama = SKSpriteNode(imageNamed: "GirlMeele1")
        mama.removeFromParent()
        mama = SKSpriteNode(imageNamed: "GirlMeele5")
        mama.setScale(0.5)
        var randomY = CGFloat.random(min: playableRect.minY + mama.size.height/2,max: playableRect.maxY - mama.size.height/2)
      mama.position = CGPoint(
        x: playableRect.maxX - 100 ,
        y: randomY)
      mama.zPosition = 50
      mama.name = "mama"
      addChild(mama)
      
      let actionMove = SKAction.moveBy(x: 0, y: 0, duration: 2.0)
      let actionRemove = SKAction.removeFromParent()
      mama.run(SKAction.sequence([actionMove, actionRemove]))
     startmamaAnimation()
        if(objcounter == 5)
        {
            if(heartcounter < 2)
            {
                spawnobjectheart(randomY: randomY)
                heartcounter+=1
                if(heartcounter == 2)
                {
                    heartcounter = 0
                    objcounter = 0
                }
            }
        }
        else
        {
            spawnobject(randomY: randomY)
            objcounter+=1
        }
        
    //spawnobjectknife(randomY: randomY)
    }
    
    
    func spawnHealthBar(imageNamed : String) {
        healthbar.removeFromParent()
      healthbar = SKSpriteNode(imageNamed: imageNamed)
        healthbar.position = CGPoint(x: playableRect.minX + 650, y: playableRect.maxY-5)
      healthbar.zPosition = 50
      healthbar.name = "healthbar"
      addChild(healthbar)
    }
    
    
    func checkCollisions() {
      
      if invincible {
        return
      }
     
      var hitEnemies: [SKSpriteNode] = []
      enumerateChildNodes(withName: "object") { node, _ in
        let object = node as! SKSpriteNode
        if node.frame.insetBy(dx: 5, dy: 5).intersects(
          self.boy.frame) {
          hitEnemies.append(object)
        }
      }
        
      for object in hitEnemies {
        boyHit(object: object)
      }
        
        var hitHearts: [SKSpriteNode] = []
        enumerateChildNodes(withName: "heart") { node, _ in
          let object = node as! SKSpriteNode
          if node.frame.insetBy(dx: 5, dy: 5).intersects(
            self.boy.frame) {
            hitHearts.append(object)
          }
        }
          
        for object in hitHearts {
          boyHit(heart: object)
        }
    }
    func boyHit(heart: SKSpriteNode) {
        heart.removeFromParent()
      run(heartCollisionSound)
      scoreCount+=1
        print("scorecount : \(scoreCount)")
    }
    
    func boyHit(object: SKSpriteNode) {
      invincible = true
      let blinkTimes = 10.0
      let duration = 3.0
      let blinkAction = SKAction.customAction(withDuration: duration) { node, elapsedTime in
        let slice = duration / blinkTimes
        let remainder = Double(elapsedTime).truncatingRemainder(
          dividingBy: slice)
        node.isHidden = remainder > slice / 2
      }
      let setHidden = SKAction.run() { [weak self] in
        self?.boy.isHidden = false
        self?.invincible = false
      }
      boy.run(SKAction.sequence([blinkAction, setHidden]))
      
      run(objectCollisionSound)
      
      lives -= 1
    }
    
    override func didEvaluateActions() {
      checkCollisions()
    }
    
    func debugDrawPlayableArea() {
      let shape = SKShapeNode()
      let path = CGMutablePath()
      path.addRect(playableRect)
      shape.path = path
      shape.strokeColor = SKColor.red
      shape.lineWidth = 4.0
      addChild(shape)
    }
}
