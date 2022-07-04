//
//  AugmentedRealityVC.swift
//  ARSneakers
//
//  Created by Ahmad Qureshi on 19/05/22.
//

import UIKit
import SceneKit
import ARKit

class AugmentedRealityVC: UIViewController , ARSCNViewDelegate {
    
    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var companyIcon: UIImageView!
    @IBOutlet weak var modelName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var favButton: UIButton!
    var productIndex = Int()
    var productData = DataBaseModel(resourceName: "", companyName: "", productModel: "", productDescription: "", productPrice: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        setUpBarButton()
        setUpTapGesture()
        closureCall()
        //addGestures()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    func closureCall() {
        isFavClosure = {
            if DataBase.shared.allData[self.productIndex].isFavourite {
                self.favButton.isSelected = true
            } else {
                self.favButton.isSelected = false
            }
        }
    }
    func addGestures () {
            let tapped = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
            
            sceneView.addGestureRecognizer(tapped)
        }
    @objc func tapGesture (sender: UITapGestureRecognizer) {
            let node = sceneView.scene.rootNode
            let position = node.position
            let newScene = SCNScene(named: "art.scnassets/\(productData.resourceName).usdz")!
            let newNode = newScene.rootNode
            newNode.position = position
            //sceneView.scene.rootNode.addChildNode(newNode)
            sceneView.scene.rootNode.replaceChildNode(node, with: newNode)
        }
    func setUpData() {
        sceneView.delegate = self
        let scene = SCNScene(named: "art.scnassets/\(productData.resourceName).usdz")!
        let spotLight = SCNNode()
        spotLight.light = SCNLight()
        spotLight.light?.type = .ambient
        let scaleFactor: Float = 0.8
        scene.rootNode.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        sceneView.scene = scene
        sceneView.scene.rootNode.addChildNode(spotLight)
        sceneView.defaultCameraController.interactionMode = .orbitTurntable
        
        if let iconImg = UIImage(named: productData.companyName) {
            self.companyIcon.image = iconImg
        }
        self.modelName.text = productData.productModel
        self.productPrice.text = productData.productPrice
        if let productImg = UIImage(named: productData.resourceName) {
            self.productImage.image = productImg
        }
        if DataBase.shared.allData[self.productIndex].isFavourite {
            self.favButton.isSelected = true
        } else {
            self.favButton.isSelected = false
        }
    }
    
    @objc func tapProduct(sender: UITapGestureRecognizer) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC {
            vc.productIndex = productIndex
            vc.productData = DataBase.shared.allData[productIndex]
            present(vc, animated: true, completion: nil)
        }
    }
    func setUpBarButton() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(systemName: "arrow.left")!, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        let barButtonLeft = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButtonLeft
    }
    func setUpTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapProduct(sender:)))
        productView.addGestureRecognizer(tap)
    }
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func favButtonPressed(_ sender: UIButton) {
        sender.isSelected.toggle()
        DataBase.shared.allData[productIndex].isFavourite.toggle()
    }
}
extension SCNVector3 {
    static func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
    }
}
