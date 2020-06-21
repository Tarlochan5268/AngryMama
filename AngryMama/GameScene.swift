//
//  GameScene.swift
//  AngryMama
//
//  Created by Das Tarlochan Preet Singh on 2020-06-21.
//  Copyright © 2020 Tarlochan5268. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
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
  let catCollisionSound: SKAction = SKAction.playSoundFileNamed(
    "hearthit.mp3", waitForCompletion: false)
  let objectCollisionSound: SKAction = SKAction.playSoundFileNamed(
    "knifehit.mp3", waitForCompletion: false)
    let heartCollisionSound: SKAction = SKAction.playSoundFileNamed(
    "hearthit.mp3", waitForCompletion: false)
  var invincible = false
  let catMovePointsPerSec:CGFloat = 480.0
  var lives = 10
  var gameOver = false
  //let cameraNode = SKCameraNode()
  //let cameraMovePointsPerSec: CGFloat = 200.0

  
  
  
  
  override func didMove(to view: SKView) {

    playBackgroundMusic(filename: "BGMusicOption1.mp3")
  
      let background = SKSpriteNode(imageNamed: "KitchenGameBg1")
      background.anchorPoint = CGPoint.zero
    background.position = CGPoint.zero
      background.name = "KitchenGameBg1"
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

    //run(SKAction.repeatForever(SKAction.sequence([SKAction.run() { [weak self] in self?.spawnCat()},SKAction.wait(forDuration: 1.0)])))
    
    // debugDrawPlayableArea()
    
    //addChild(cameraNode)
    //camera = cameraNode
    //cameraNode.position = CGPoint(x: size.width/2, y: size.height/2)
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
  
    /*
    if let lastTouchLocation = lastTouchLocation {
      let diff = lastTouchLocation - boy.position
      if diff.length() <= boyMovePointsPerSec * CGFloat(dt) {
        boy.position = lastTouchLocation
        velocity = CGPoint.zero
        stopboyAnimation()
      } else {
      */
        move(sprite: boy, velocity: velocity)
        //rotate(sprite: boy, direction: velocity,
          //rotateRadiansPerSec: boyRotateRadiansPerSec)
      /*}
    }*/
  
    boundsCheckboy()
    // checkCollisions()
    moveTrain()
    //moveCamera()
    
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
    
    // cameraNode.position = boy.position
    
  }
  
  
  

  func boyHit(cat: SKSpriteNode) {
    cat.name = "train"
    cat.removeAllActions()
    cat.setScale(0.5)
    cat.zRotation = 0
    
    //let turnGreen = SKAction.colorize(with: SKColor.green, colorBlendFactor: 1.0, duration: 0.2)
    //cat.run(turnGreen)
    cat.isHidden = true
    
    run(catCollisionSound)
  }

  

  
  
  
  
  func moveTrain() {
  
    var trainCount = 0
    var targetPosition = boy.position
    
    enumerateChildNodes(withName: "train") { node, stop in
      trainCount += 1
      if !node.hasActions() {
        let actionDuration = 0.3
        let offset = targetPosition - node.position
        let direction = offset.normalized()
        let amountToMovePerSec = direction * self.catMovePointsPerSec
        let amountToMove = amountToMovePerSec * CGFloat(actionDuration)
        let moveAction = SKAction.moveBy(x: amountToMove.x, y: amountToMove.y, duration: actionDuration)
        node.run(moveAction)
      }
      targetPosition = node.position
    }
    
    if trainCount >= 15 && !gameOver {
      gameOver = true
      print("You win!")
      backgroundMusicPlayer.stop()
      
      // 1
      let gameOverScene = GameOver(size: size, won: true)
      gameOverScene.scaleMode = scaleMode
      // 2
      let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
      // 3
      view?.presentScene(gameOverScene, transition: reveal)
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
            if(heartcounter < 4)
            {
                spawnobjectheart(randomY: randomY)
                heartcounter+=1
                if(heartcounter == 4)
                {
                    heartcounter = 0
                    objcounter = 0
                }
            }
        }
        else
        {
            spawnobjectknife(randomY: randomY)
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
    
    
    func spawnCat() {
      // 1
      let cat = SKSpriteNode(imageNamed: "heartsmall-1")
      cat.name = "cat"
      cat.position = CGPoint(
        x: CGFloat.random(min: playableRect.minX,
                          max: playableRect.maxX),
        y: CGFloat.random(min: playableRect.minY,
                          max: playableRect.maxY))
      cat.zPosition = 50
        //cat.decreaseSize(1)
        //cat.setScale(0)
      addChild(cat)
      // 2
      let appear = SKAction.scale(to: 1.0, duration: 0.5)

      cat.zRotation = -π / 16.0
      let leftWiggle = SKAction.rotate(byAngle: π/8.0, duration: 0.5)
      let rightWiggle = leftWiggle.reversed()
      let fullWiggle = SKAction.sequence([leftWiggle, rightWiggle])
      
      let scaleUp = SKAction.scale(by: 1.2, duration: 0.25)
      let scaleDown = scaleUp.reversed()
      let fullScale = SKAction.sequence(
        [scaleUp, scaleDown, scaleUp, scaleDown])
      let group = SKAction.group([fullScale, fullWiggle])
      let groupWait = SKAction.repeat(group, count: 10)
      
      let disappear = SKAction.scale(to: 0, duration: 0.5)
      let removeFromParent = SKAction.removeFromParent()
      let actions = [appear, groupWait, disappear, removeFromParent]
      cat.run(SKAction.sequence(actions))
    }
    
    func checkCollisions() {
      var hitCats: [SKSpriteNode] = []
      enumerateChildNodes(withName: "cat") { node, _ in
        let cat = node as! SKSpriteNode
        if cat.frame.intersects(self.boy.frame) {
          hitCats.append(cat)
        }
      }
      
      for cat in hitCats {
        boyHit(cat: cat)
      }
      
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
      //loseCats()
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
      
      //loseCats()
      lives -= 1
    }
    
    override func didEvaluateActions() {
      checkCollisions()
    }
    
    /*
    func moveCamera() {
      let backgroundVelocity =
        CGPoint(x: cameraMovePointsPerSec, y: 0)
      let amountToMove = backgroundVelocity * CGFloat(dt)
      cameraNode.position += amountToMove
      
      enumerateChildNodes(withName: "background") { node, _ in
        let background = node as! SKSpriteNode
        if background.position.x + background.size.width <
            self.cameraRect.origin.x {
          background.position = CGPoint(
            x: background.position.x + background.size.width*2,
            y: background.position.y)
        }
      }
      
    }
 */
    /*
    var cameraRect : CGRect {
      let x = cameraNode.position.x - size.width/2
          + (size.width - playableRect.width)/2
      let y = cameraNode.position.y - size.height/2
          + (size.height - playableRect.height)/2
      return CGRect(
        x: x,
        y: y,
        width: playableRect.width,
        height: playableRect.height)
    }
 */
    
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
