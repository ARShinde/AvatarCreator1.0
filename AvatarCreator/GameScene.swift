//
//  GameScene.swift
//  AvatarCreator
//
//  Created by Abhishek Shinde on 14/02/17.
//  Copyright © 2017 Abhishek Shinde. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var faceNode:SKSpriteNode!
    private var scrollArea:SKSpriteNode!
    private var optionBar:SKSpriteNode!
    
    private var hairNode:SKSpriteNode!
    private var eyeNode:SKSpriteNode!
    private var mustacheNode:SKSpriteNode!
    private var clothsNode:SKSpriteNode!
    private var backgroundNode:SKSpriteNode!

    private var selectedTab:CGFloat = 1
    private var scrollToPage:SKAction!
    
    override func sceneDidLoad() {
        self.initUI()
        
    }
    
    func initUI(){
        
        self.faceNode = self.childNode(withName: "//FACEBOX") as? SKSpriteNode
        self.scrollArea = self.childNode(withName: "//SCROLLAREA") as? SKSpriteNode
        self.optionBar = self.childNode(withName: "//OPTIONSBAR") as? SKSpriteNode
        
        self.hairNode = self.faceNode.childNode(withName: "//HAIR") as? SKSpriteNode
        self.eyeNode = self.faceNode.childNode(withName: "//EYES") as? SKSpriteNode
        self.mustacheNode = self.faceNode.childNode(withName: "//MUSTACHE") as? SKSpriteNode
        self.clothsNode = self.faceNode.childNode(withName: "//SHIRT") as? SKSpriteNode
        self.backgroundNode = self.childNode(withName: "//BACKGROUND") as? SKSpriteNode

        self.eyeNode.alpha = 0.0
        self.mustacheNode.alpha = 0.0

     }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        if let _ = touchedNode.name{
            handleInteractionsOnNode(node: touchedNode)
        }
    }
    
    
    private func handleInteractionsOnNode(node:SKNode){
    
        if let nodeWithName = node.name {
            switch (nodeWithName){
                case "HairsButton":
                    self.scrollToPage(pageName: "Page1")
                    break

                case "EyesButton":
                    self.scrollToPage(pageName: "Page2")
                    break

                case "BearedButton":
                    self.scrollToPage(pageName: "Page3")
                    break
                
                case "MustacheButton":
                    self.scrollToPage(pageName: "Page4")
                    break

                case "ClothsButton":
                    self.scrollToPage(pageName: "Page5")
                    break
                
                default:
                    self.defaultInteractionsForNode(node:node)
            }
        }
        
    }
    
    func defaultInteractionsForNode(node:SKNode){
        
        if let parentNode = node.parent,let parentNodeName = node.parent?.name,let nodeName = node.name{
        
            switch parentNodeName  {
                
                case "Page1":
                    //handle head interactions
                    parentNode.enumerateChildNodes(withName: nodeName, using: { (node, _) in
                        self.hairNode.texture = SKTexture(imageNamed: nodeName)
                    })
                    break
                
                case "Page2":
                    //handle eyewear interactions
                    parentNode.enumerateChildNodes(withName: nodeName, using: { (node, _) in
                        self.eyeNode.alpha = 1.0
                        self.eyeNode.texture = SKTexture(imageNamed: nodeName)
                    })
                    break
                
                case "Page3":
                    //handle background interactions
                    parentNode.enumerateChildNodes(withName: nodeName, using: { (node, _) in
                        self.backgroundNode.texture = SKTexture(imageNamed: nodeName)
                    })
                    break
                
                case "Page4":
                    //handle mustache interactions
                    parentNode.enumerateChildNodes(withName: nodeName, using: { (node, _) in
                        self.mustacheNode.alpha = 1.0
                        self.mustacheNode.texture = SKTexture(imageNamed: nodeName)
                    })
                    break
                
                case "Page5":
                    //handle cloths interactions
                    parentNode.enumerateChildNodes(withName: nodeName, using: { (node, _) in
                        self.clothsNode.texture = SKTexture(imageNamed: nodeName)
                    })
                    break
                
                default: break
            }
        }
    }
    
    func scrollToPage(pageName:String){
        
        let value:CGFloat = self.getChildIdFromParentNode(parentNode: self.scrollArea, childName: pageName)

        if value == 999{
         return
        }
        
        if value > self.selectedTab{
            
            if let scrollCoordinates = self.scrollArea{
                let coordinates = scrollCoordinates.frame.size.width
                self.scrollToPage = SKAction.moveBy(x: -(coordinates * (value-selectedTab)), y: 0, duration: 0.5)
            }
            self.scrollArea?.run(self.scrollToPage)
            self.selectedTab = value

        }else if value < self.selectedTab{

            if let scrollCoordinates = self.scrollArea{
                let coordinates = scrollCoordinates.frame.size.width
                self.scrollToPage = SKAction.moveBy(x: (coordinates * (selectedTab-value)), y: 0, duration: 0.5)
            }
            self.scrollArea?.run(self.scrollToPage)
            self.selectedTab = value
        }
    }
    
    
    private func getChildIdFromParentNode(parentNode:SKNode,childName:String)->CGFloat{
        var counter:CGFloat = 1
        
        if let parentNode:SKNode = parentNode as? SKNode , let childName:String = childName as? String{
            for node in parentNode.children{
                if(node.name == childName){
                    let substring = String(format: "%.0f", counter)
                    if childName.contains(substring) {
                            return counter
                    }
                }
                counter += 1
            }
        }
        return 999
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesMoved")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesEnded")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesCancelled")
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
    }
}
