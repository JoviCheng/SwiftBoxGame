//
//  GameScene.swift
//  Box
//
//  Created by JoviCheng on 2018/12/25.
//  Copyright © 2018年 JoviCheng. All rights reserved.
//

import SpriteKit
import GameplayKit

let BoxCategory   : UInt32 = 0x1 << 0
let BottomCategory : UInt32 = 0x1 << 1
let PreBoxCategory : UInt32 = 0x1 << 2

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var restartButton : SKLabelNode!
    private var ScoreText : SKLabelNode!
    private var LvText : SKLabelNode!
    private var spinnyNode : SKShapeNode?
    let boxPro = SKSpriteNode(color: .red,
                              size: CGSize(width: 240, height: 45))
    let claw = SKSpriteNode(color: .blue,
                           size: CGSize(width: 240, height: 30))
    
    var makingBox = false
    var touchButton = false
    var currentBox : SKSpriteNode?
    var tempBox : SKSpriteNode?
    var preBox: SKSpriteNode?
    var score : Int = 0
    var lv : Int = 1
    
//    let box = SKSpriteNode(color: .red,
//                              size: CGSize(width: 50, height: 50))
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
//        print(frame.size)
//        print(self.frame.size)
//        print(view.frame.size)
        borderBody.friction = 1
        borderBody.restitution = 0
//        borderBody.node?.name = "BorderBody"
        self.physicsBody = borderBody
        scene?.name = "SceneBorder"
        initGame()
    }
    
    func initGame(){
        self.removeAllChildren()
        self.removeAllActions()
        score = 0
        lv = 1
        let bottomRect = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: 5)
        //        let bottomRect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 5)
        print("bottomRect ",bottomRect)
        //        let bottom = SKNode()
        let bottom = SKSpriteNode()
        //        bottomRect.ciolor
//        bottom.position = CGPoint(x: 25, y: 25)
//        bottom.size = CGSize(width: self.frame.size.width, height: 5)
        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        bottom.physicsBody?.friction = 1
        bottom.physicsBody?.restitution = 0
        bottom.color = UIColor.white
        bottom.name = "FuckuBottom"
//        print(bottom)
        self.addChild(bottom)
        
        bottom.physicsBody!.categoryBitMask = BottomCategory
//        print("front",bottom.physicsBody!.categoryBitMask)
        
        restartButton = SKLabelNode()
        restartButton.position = CGPoint(x:(view!.frame.width-120),y:(self.frame.height-80)/2)
        restartButton.horizontalAlignmentMode = .center
        restartButton.fontColor = .white
        restartButton.zPosition = 999
        restartButton.fontSize = 50
        restartButton.text = "Restart"
        self.addChild(restartButton!)
        
        ScoreText = SKLabelNode()
        ScoreText.position = CGPoint(x:-(view!.frame.width-140),y:(self.frame.height-80)/2)
        ScoreText.zPosition = 999
        ScoreText.horizontalAlignmentMode = .center
        ScoreText.fontColor = .white
        ScoreText.fontSize = 50
        ScoreText.text = "\("Score:")\(score)\("/20")"
        self.addChild(ScoreText)
        
        LvText = SKLabelNode()
        LvText.position = CGPoint(x:-(view!.frame.width-60),y:(self.frame.height-180)/2)
        LvText.zPosition = 999
        LvText.horizontalAlignmentMode = .center
        LvText.fontColor = .white
        LvText.fontSize = 50
        LvText.text = "\("Lv:")\(lv)"
        self.addChild(LvText)
        
        self.claw.position = CGPoint(x:-(view!.frame.width-60),y:(self.frame.height-self.claw.size.height)/2)
        self.claw.zPosition = 1
        self.claw.physicsBody = SKPhysicsBody(rectangleOf:self.claw.frame.size)
        self.claw.physicsBody?.affectedByGravity = false
        self.claw.physicsBody?.isDynamic = true
        self.claw.physicsBody?.allowsRotation = false
        self.claw.physicsBody?.linearDamping = 0
        self.claw.name = "Claw"
//        self.claw.physicsBody?.velocity = CGVector(dx:0.0,dy:0.0)
        self.addChild(self.claw)
        self.claw.removeAllChildren()
        self.claw.removeAllActions()
        clawMove(currentNode: self.claw,currentLv: lv)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.createBox()
        }
        self.touchButton = false
    }
    
    func upLevel() {
        self.removeAllChildren()
        self.removeAllActions()
        score = 0
        lv += 1
        let bottomRect = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: 5)
        //        let bottomRect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 5)
        print("bottomRect ",bottomRect)
        //        let bottom = SKNode()
        let bottom = SKSpriteNode()
        //        bottomRect.ciolor
        //        bottom.position = CGPoint(x: 25, y: 25)
        //        bottom.size = CGSize(width: self.frame.size.width, height: 5)
        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        bottom.physicsBody?.friction = 1
        bottom.physicsBody?.restitution = 0
        bottom.color = UIColor.white
        bottom.name = "FuckuBottom"
        //        print(bottom)
        self.addChild(bottom)
        
        bottom.physicsBody!.categoryBitMask = BottomCategory
        //        print("front",bottom.physicsBody!.categoryBitMask)
        
        restartButton = SKLabelNode()
        restartButton.position = CGPoint(x:(view!.frame.width-120),y:(self.frame.height-80)/2)
        restartButton.horizontalAlignmentMode = .center
        restartButton.fontColor = .white
        restartButton.zPosition = 999
        restartButton.fontSize = 50
        restartButton.text = "Restart"
        self.addChild(restartButton!)
        
        ScoreText = SKLabelNode()
        ScoreText.position = CGPoint(x:-(view!.frame.width-140),y:(self.frame.height-80)/2)
        ScoreText.zPosition = 999
        ScoreText.horizontalAlignmentMode = .center
        ScoreText.fontColor = .white
        ScoreText.fontSize = 50
        ScoreText.text = "\("Score:")\(score)\("/20")"
        self.addChild(ScoreText)
        
        LvText = SKLabelNode()
        LvText.position = CGPoint(x:-(view!.frame.width-60),y:(self.frame.height-180)/2)
        LvText.zPosition = 999
        LvText.horizontalAlignmentMode = .center
        LvText.fontColor = .white
        LvText.fontSize = 50
        LvText.text = "\("Lv:")\(lv)"
        self.addChild(LvText)

        self.claw.position = CGPoint(x:-(view!.frame.width-60),y:(self.frame.height-self.claw.size.height)/2)
        self.claw.zPosition = 1
        self.claw.physicsBody = SKPhysicsBody(rectangleOf:self.claw.frame.size)
        self.claw.physicsBody?.affectedByGravity = false
        self.claw.physicsBody?.isDynamic = true
        self.claw.physicsBody?.allowsRotation = false
        self.claw.physicsBody?.linearDamping = 0
        self.claw.name = "Claw"
        //        self.claw.physicsBody?.velocity = CGVector(dx:0.0,dy:0.0)
        self.addChild(self.claw)
        self.claw.removeAllChildren()
        self.claw.removeAllActions()
        clawMove(currentNode: self.claw,currentLv: lv)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.createBox()
        }
        self.touchButton = false
    }
    
    func createBox(){
        let box = self.boxPro.copy() as! SKSpriteNode
//        box.position = CGPoint(x:makingPoint.x,y:makingPoint.y)
//        box.position = CGPoint(x:0,y:0)
//        box.position = CGPoint(x:200,y:200)
        box.zPosition = 5
        box.physicsBody = SKPhysicsBody(rectangleOf:box.size)
//        box.position = self.claw.position
        box.physicsBody?.affectedByGravity = false
        box.physicsBody?.allowsRotation = false
        box.physicsBody?.friction = 1
        box.physicsBody?.restitution = 0
        box.position.y -= 20
        self.tempBox = box
        self.claw.addChild(box)
        self.makingBox = false
//        clawMove()
//        print(box.position)
    }
    
    func clawMove(currentNode:SKSpriteNode,currentLv:Int){
        let moveLeft = SKAction.moveBy(x: -((view!.frame.width*2)-60),y: 0.0,duration: 1.5-(0.05*Double(currentLv) as Double))
        let moveRight = SKAction.moveBy(x: (view!.frame.width*2)-60,y: 0.0,duration: 1.5-(0.05*Double(currentLv) as Double))

//        let moveLeft = SKAction.moveBy(x: -50,y: 0.0,duration: 1.0)
//        let moveRight = SKAction.moveBy(x: 50,y: 0.0,duration: 1.0)
        let list = SKAction.sequence([moveRight,moveLeft])
        let repeatMoving = SKAction.repeatForever(list)
        currentNode.run(repeatMoving)
    }
    
    //点击屏幕出发的事件
    func touchDown(atPoint pos : CGPoint) {
        if(self.makingBox){
            return
        }
        if(self.touchButton){
            return
        }
//        self.touchButton = false
        self.currentBox = self.tempBox
        self.makingBox = true
        self.currentBox!.name = "CurrentBox"
        self.currentBox!.position = CGPoint(x:self.claw.position.x,y:self.claw.position.y-20)
        self.currentBox!.removeAllActions()
        self.currentBox!.physicsBody?.affectedByGravity = true
        self.currentBox!.physicsBody?.allowsRotation = true
        self.currentBox!.removeFromParent()
        self.addChild(self.currentBox!)
        self.currentBox!.physicsBody?.categoryBitMask = BoxCategory
        self.currentBox!.physicsBody?.contactTestBitMask = BottomCategory
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) {
            self.createBox()
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
//        print(contact.bodyA)
//        print(contact.bodyB)
        if (contact.bodyA.node?.name != "Claw" && contact.bodyB.node?.name != "Claw" && (contact.bodyA.node?.name != "SceneBorder" && contact.bodyB.node?.name != "SceneBorder")){
//            print(contact.bodyA)
//            print(contact.bodyB)
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        print("weee")
        if firstBody.categoryBitMask == BoxCategory && secondBody.categoryBitMask == BottomCategory {
            //碰到底面的情况
            if(score == 0){
                score += 1
                ScoreText.text = "\("Score:")\(score)\("/20")"
                print("first Hit")
                preBox = currentBox
                preBox!.physicsBody?.categoryBitMask = PreBoxCategory
                preBox?.name = "PreBox"
                preBox!.physicsBody?.contactTestBitMask = BoxCategory
            }
            else {
//                score = 0
                print("你输左啦，懵仔")
            }
        } else {
            score += 1
            ScoreText.text = "\("Score:")\(score)\("/20")"
            if(score == 20){
                upLevel()
            }
            else {
            preBox = currentBox
            preBox!.physicsBody?.categoryBitMask = PreBoxCategory
            preBox!.physicsBody?.contactTestBitMask = BoxCategory
            print("score",score)
            }
            }
    }
}
    
    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        if nodes(at: location).contains(restartButton){
            self.touchButton = true
//            print("FUcku ")
//            print(self.touchButton)
            self.removeAllChildren()
            //在这里我们等会尝试做一些动画效果...
//            if gameOver {
                initGame()
//            }
        }
        else {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
//        self.claw.position.y = (self.frame.height-self.claw.size.height)/2
    }
}
