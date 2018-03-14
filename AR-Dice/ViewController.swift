//
//  ViewController.swift
//  AR-Dice
//
//  Created by Ejaz Merchant on 3/13/18.
//  Copyright © 2018 Ejaz Merchant. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Set the view's delegate
        sceneView.delegate = self
        
//        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
//
//        let material = SCNMaterial()
//        material.diffuse.contents = UIColor.red
//
//        cube.materials = [material]
//
//        let node = SCNNode()
//
//        node.position = SCNVector3Make(0, 0.1, -0.5)
//
//        node.geometry = cube
//
//        sceneView.scene.rootNode.addChildNode(node)
        
//        sceneView.autoenablesDefaultLighting = true
//
//        // Create a new scene
//        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
//
//        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
//
//        diceNode.position = SCNVector3Make(0, 0, -0.1)
//
//        sceneView.scene.rootNode.addChildNode(diceNode)
//
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let hitResults = results.first {
                
                let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
        
                if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
                    
                    diceNode.position = SCNVector3Make(
                        hitResults.worldTransform.columns.3.x,
                        hitResults.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                        hitResults.worldTransform.columns.3.z
                    )
                    
                    sceneView.scene.rootNode.addChildNode(diceNode)
        
                }
                
            }

        }
        
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if anchor is ARPlaneAnchor {
            let placeAnchor = anchor as! ARPlaneAnchor
            
            let plane = SCNPlane(width: CGFloat(placeAnchor.extent.x), height: CGFloat(placeAnchor.extent.z))
            
            let planeNode = SCNNode()
            
            planeNode.position = SCNVector3Make(placeAnchor.center.x, 0, placeAnchor.center.z)
            
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            let gridMaterial = SCNMaterial()
            
            gridMaterial.diffuse.contents = UIImage(named: "art/scnassets/grid.png")
            
            plane.materials = [gridMaterial]
            
            planeNode.geometry = plane
            
            node.addChildNode(planeNode)
            
        } else {
            return
        }
        
    }

}






