//
//  GameViewController.swift
//  AvatarCreator
//
//  Created by Abhishek Shinde on 14/02/17.
//  Copyright © 2017 Abhishek Shinde. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import Photos

class GameViewController: UIViewController {

    @IBOutlet weak var gameView: UIView!
    var scene:GKScene!
    @IBOutlet weak var refreshUI: UIBarButtonItem!
    @IBOutlet weak var saveAvatar: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        
    }

    func initUI(){
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            self.scene = scene
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.gameView as! SKView? {
                    view.presentScene(sceneNode)
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
    }
    
    @IBAction func saveAvatarClicked(_ sender: Any) {
        
        
        
        if let scene = GKScene(fileNamed: "GameScene") {
            
            self.scene = scene
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                if let backgroundNode = sceneNode.childNode(withName: "BACKGROUND"){
                    print(backgroundNode.frame)
                    
                    
                    self.getScreenshot(scene: sceneNode,captureSize:backgroundNode.frame, completion: { (texture) in
                        
                        print("got texture \(texture)")
                        let image = UIImage(cgImage: texture.cgImage())

                        
                        PHPhotoLibrary.shared().performChanges({ 
                            PHAssetChangeRequest.creationRequestForAsset(from: image)
                            
                        }, completionHandler: { (success, error) in
                            if success{
                                print("saved successfully")
                             //   self.imageView.image = image
                            }
                        })
                    })
                }
                
            }
        }
        
    
    }
    
    
    @IBAction func refreshUIClicked(_ sender: Any) {
        
        let alertControllerStyle = UIAlertControllerStyle.alert
        let alertAction1 = UIAlertAction(title: "RESET", style: .default) { (action) in
            self.initUI()
        }
        
        let alertAction2 = UIAlertAction(title: "CANCEL", style: .cancel) { (action) in}
        
        let alert = UIAlertController(title: "Reset Avatar", message: "Are you sure you want to Reset Avatar?", preferredStyle: alertControllerStyle)
        alert.addAction(alertAction1)
        alert.addAction(alertAction2)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func getScreenshot(scene: SKScene,captureSize:CGRect, duration:TimeInterval = 0.0001, completion:((_ txt:SKTexture) -> Void)?) {
       
        
            print(captureSize)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                //create snapshot of the blurView
                let window = UIApplication.shared.delegate!.window!!
                
                //capture the entire window into an image
                UIGraphicsBeginImageContextWithOptions(CGSize(width: window.bounds.size.width, height: captureSize.height), false, UIScreen.main.scale)
                window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
                
                let windowImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                //now position the image x/y away from the top-left corner to get the portion we want
                UIGraphicsBeginImageContext(CGSize(width: captureSize.width, height: captureSize.height))
                windowImage?.draw(at: CGPoint(x: -captureSize.origin.x/2, y: -captureSize.origin.y))
                
                let croppedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext();

                completion!(SKTexture(image: croppedImage))

        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }
}
