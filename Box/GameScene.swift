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

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var restartButton : SKLabelNode!
    private var spinnyNode : SKShapeNode?
    let boxPro = SKSpriteNode(color: .red,
                              size: CGSize(width: 240, height: 60))
    let claw = SKSpriteNode(color: .white,
                           size: CGSize(width: 240, height: 30))
    
    var makingBox = false
    var touchButton = false
    var currentBox : SKSpriteNode?
    
//    let box = SKSpriteNode(color: .red,
//                              size: CGSize(width: 50, height: 50))
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        print(frame.size)
        print(self.frame.size)
        print(view.frame.size)
        borderBody.friction = 1
        borderBody.restitution = 0
        self.physicsBody = borderBody
        
        let bottomRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        addChild(bottom)
        
        bottom.physicsBody!.categoryBitMask = BottomCategory
        initGame()
    }
    
    func initGame(){
        self.removeAllChildren()
        self.removeAllActions()
        restartButton = SKLabelNode()
        restartButton.position = CGPoint(x: view!.frame.size.width - restartButton.frame.size.width, y: (self.frame.height-self.size.height)/2)
        restartButton.horizontalAlignmentMode = .center
        restartButton.fontColor = .white
        restartButton.fontSize = 50
        restartButton.text = "Restart"
        self.addChild(restartButton!)
        
        self.claw.position = CGPoint(x:-(view!.frame.width-60),y:(self.frame.height-self.claw.size.height)/2)
        self.claw.zPosition = 1
        self.claw.physicsBody = SKPhysicsBody(rectangleOf:self.claw.frame.size)
        self.claw.physicsBody?.affectedByGravity = false
        self.claw.physicsBody?.isDynamic = true
        self.claw.physicsBody?.allowsRotation = false
        self.claw.physicsBody?.linearDamping = 0
//        self.claw.physicsBody?.velocity = CGVector(dx:0.0,dy:0.0)
        self.addChild(self.claw)
        self.claw.removeAllChildren()
        self.claw.removeAllActions()
        clawMove(currentNode: self.claw)
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
//        box.physicsBody?.pinned = true
//        box.run(moveNodeUp,withKey: "boxMoving")
        self.currentBox = box
//        print(self.currentBox)
        self.claw.addChild(box)
//        let joint = SKPhysicsJointPin.joint(withBodyA: self.claw.physicsBody!,
//                                            bodyB: box.physicsBody!,
//                                            anchor: CGPoint(x: self.claw.frame.midX, y: self.claw.frame.midY))
//        physicsWorld.add(joint)
        self.makingBox = false
//        clawMove()
        print(box.position)
    }
    
    func clawMove(currentNode:SKSpriteNode){
        let moveLeft = SKAction.moveBy(x: -((view!.frame.width*2)-60),y: 0.0,duration: 1.5)
        let moveRight = SKAction.moveBy(x: (view!.frame.width*2)-60,y: 0.0,duration: 1.5)

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
        self.makingBox = true
        self.currentBox!.physicsBody?.categoryBitMask = BoxCategory
        self.currentBox!.physicsBody?.contactTestBitMask = BottomCategory
        self.currentBox!.position = CGPoint(x:self.claw.position.x,y:self.claw.position.y-20)
        self.currentBox!.removeAllActions()
        self.currentBox!.physicsBody?.affectedByGravity = true
        self.currentBox!.physicsBody?.allowsRotation = true
        self.currentBox!.removeFromParent()
        self.addChild(self.currentBox!)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) {
            self.createBox()
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("happend")
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        print(contact.bodyA.categoryBitMask)
        print(contact.bodyB.categoryBitMask)
        // 2
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        // 3
        if firstBody.categoryBitMask == BottomCategory && secondBody.categoryBitMask == BoxCategory {
            print("Hit bottom. First contact has been made.")
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
            print("FUcku ")
            print(self.touchButton)
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
