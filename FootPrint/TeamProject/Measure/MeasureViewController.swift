//
//  MeasureViewController.swift
//  TeamProject
//
//  Created by 홍화형 on 2021/01/19.
//

import Foundation
import UIKit
import SceneKit
import ARKit

class MeasureViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var scnView: ARSCNView!
    @IBOutlet var footLength: UILabel!
    @IBOutlet var footWidth: UILabel!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var resizeLengthButton: UIButton!
    @IBOutlet var resizeWidthButton: UIButton!
    var measureCount = 0
//    var length: Double = 0.0
//    var width: Double = 0.0
    let model = SizeClassification()
    
    var nodes: [SCNNode] = []
    let nodeColor: UIColor = .black
    let nodeRadius: CGFloat = 0.005
    var startNode: SCNNode?
    var distance: Double?
    var lineNode: SCNNode?
    
    func setupScene() {
        let scene = SCNScene()
        
        self.scnView.delegate = self
        self.scnView.showsStatistics = false
        self.scnView.automaticallyUpdatesLighting = true
        self.scnView.debugOptions = [ARSCNDebugOptions.showFeaturePoints] // 노란 점
        self.scnView.scene = scene
    }

    func setupARSession() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        scnView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(tapGesture)
        saveButton.layer.cornerRadius = 10
        resizeLengthButton.layer.cornerRadius = 10
        resizeWidthButton.layer.cornerRadius = 10
        print("load")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        setupARSession()
        setupScene()
        renderer(scnView, updateAtTime: 1)
        firstSetInWillAppear()
        print("appear")
    }
    @IBAction func goToHome(_ sender: UIButton) {
        //추천사이즈 들어가야함
        if left {
            if footSize.length! < leftFootSize.length! {
                footSize.length = leftFootSize.length
            }
            if footSize.width! < leftFootSize.width! {
                footSize.width = leftFootSize.width
            }
            getSize(foot: footSize)
            if let footData = try? PropertyListEncoder().encode(footSize) {
                defaults.set(footData, forKey: "FootData")
            }
            if let leftFootData = try? PropertyListEncoder().encode(leftFootSize) {
                defaults.set(leftFootData, forKey: "LeftFootData")
            }
            performSegue(withIdentifier: "unwindVC", sender: footSize)
        } else {
            if footSize.length! < rightFootSize.length! {
                footSize.length = rightFootSize.length
            }
            if footSize.width! < rightFootSize.width! {
                footSize.width = rightFootSize.width
            }
            getSize(foot: footSize)
            if let footData = try? PropertyListEncoder().encode(footSize) {
                defaults.set(footData, forKey: "FootData")
            }
            if let rightFootData = try? PropertyListEncoder().encode(rightFootSize) {
                defaults.set(rightFootData, forKey: "RightFootData")
            }
            performSegue(withIdentifier: "unwindVC", sender: footSize)
        }
        footLength.text = "길 이 :"
        footWidth.text = "발 볼 :"
    }
    func getSize(foot:FootSize ) {
        guard let size = try? model.prediction(Length: foot.length!, Width: foot.width!) else { return }
        footSize.recommendSize = Int(size.Size)
    }
    @IBAction func resizeLengthButtonTap(_ sender: Any) {
        measureCount = 0
        footLength.text = "길 이 :"
        resizeLengthButton.isHidden = true
        resizeLengthButton.isEnabled = false
    }
    @IBAction func resizeWidthButtonTap(_ sender: Any) {
        measureCount = 1
        footWidth.text = "발 볼 :"
        resizeWidthButton.isHidden = true
        resizeWidthButton.isEnabled = false
    }
    
// MARK: GESTURE HANDLERS
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        var tapPoint = scnView.center
        tapPoint.y -= 120
        let hitTestResults = scnView.hitTest(tapPoint, types: .featurePoint)
        
        if let result = hitTestResults.first {
            if nodes.count == 2 {
                cleanAllNodes()
            }

            let position = SCNVector3.positionFrom(matrix: result.worldTransform)
            let sphere = SCNSphere(color: self.nodeColor, radius: self.nodeRadius)
            let node = SCNNode(geometry: sphere)
//            let position = SCNVector3.positionFrom(matrix: result.worldTransform)
//            let sphere = SCNSphere(color: self.nodeColor, radius: self.nodeRadius)
//            let node = SCNNode(geometry: sphere)
            
            node.position = position
            
            scnView.scene.rootNode.addChildNode(node)
            //Get the Last Node from the list
            let lastNode = nodes.last
            //Add the Sphere to the list.
            nodes.append(node)
            //Setting our starting point for drawing a line in real time
            self.startNode = nodes.last
            
            if lastNode != nil {
                //If there is 2 nodes or more
                if nodes.count >= 2 {
                    //Create a node line between the nodes
                    let measureLine = LineNode(from: (lastNode?.position)!, to: (startNode?.position)!, lineColor: self.nodeColor)
                    measureLine.name = "measureLine"
                    //Add the Node to the scene.
                    scnView.scene.rootNode.addChildNode(measureLine)
                }
                self.distance = Double(lastNode!.position.distance(to: node.position)) * 1000
                let doubleDistance = String(format: "%.1f mm", self.distance!)
                if left {
                    if measureCount == 0 {
                        leftFootSize.length = (doubleDistance as NSString).doubleValue
                        footLength.text = "길 이 : "+doubleDistance
                        measureCount += 1
                        resizeLengthButton.isHidden = false
                        resizeLengthButton.isEnabled = true
                    }else if measureCount == 1 {
                        leftFootSize.width = (doubleDistance as NSString).doubleValue
                        footWidth.text = "발 볼 : "+doubleDistance
                        saveButton.isHidden = false
                        saveButton.isEnabled = true
                        resizeWidthButton.isHidden = false
                        resizeWidthButton.isEnabled = true
                        measureCount = 0
                    }
                } else {
                    if measureCount == 0 {
                        rightFootSize.length = (doubleDistance as NSString).doubleValue
                        footLength.text = "길 이 : "+doubleDistance
                        measureCount += 1
                        resizeLengthButton.isHidden = false
                        resizeLengthButton.isEnabled = true
                    } else if measureCount == 1 {
                        rightFootSize.width = (doubleDistance as NSString).doubleValue
                        footWidth.text = "발 볼 : "+doubleDistance
                        saveButton.isHidden = false
                        saveButton.isEnabled = true
                        resizeWidthButton.isHidden = false
                        resizeWidthButton.isEnabled = true
                        measureCount = 0
                    }
                }
            }
        }
    }
    
    func firstSetInWillAppear() {
        saveButton.isHidden = true
        saveButton.isEnabled = false
        resizeLengthButton.isHidden = true
        resizeLengthButton.isEnabled = false
        resizeWidthButton.isHidden = true
        resizeWidthButton.isEnabled = false
    }
    
    func cleanAllNodes() {
        if nodes.count > 0 {
            for node in nodes {
                node.removeFromParentNode()
            }
            for node in scnView.scene.rootNode.childNodes {
                if node.name == "measureLine" {
                    node.removeFromParentNode()
                }
            }
            nodes = []
        }
    }
    func doHitTestOnExistingPlanes() -> SCNVector3? {
        // hit-test of view's center with existing-planes
        var tapPoints = scnView.center // 따라 움직이는 라인 만드는거
        tapPoints.y -= 120
        let results = scnView.hitTest(tapPoints, types: .featurePoint)
        // check if result is available
        if let result = results.first {
            // get vector from transform
            let hitPos = SCNVector3.positionFrom(matrix: result.worldTransform)
            return hitPos
        }
        return nil
    }
        
// renderer callback method
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        if nodes.count == 2 {
            self.startNode =  nil
            self.lineNode?.removeFromParentNode()
        }
        
        DispatchQueue.main.async {
            // get current hit position
            // and check if start-node is available
            guard let currentPosition = self.doHitTestOnExistingPlanes(),
                let start = self.startNode else {
                    return
            }
            // line-node
            self.lineNode?.removeFromParentNode()
            self.lineNode = LineNode(from: start.position, to: currentPosition, lineColor: .red)
            self.lineNode?.name = "lineInRealTime"
            self.scnView.scene.rootNode.addChildNode(self.lineNode!)
        }
    }
}
