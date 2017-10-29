import ARKit

extension uARScene: ARSKViewDelegate, ARSCNViewDelegate {
    func session(_ session: ARSession,
                 didFailWithError error: Error) {
        print("Session Failed - probably due to lack of camera access")
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        print("Session interrupted")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        print("Session resumed")
        sceneView.session.run(session.configuration!,
                              options: [.resetTracking,
                                        .removeExistingAnchors])
    }
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        
        for item in items {
            if item.anchorID == anchor.identifier {
                return item.itemObject
            }
        }
        
        
        // If PlaneAnchor is created by horizantal plane detection
        // Place content only for anchors found by plane detection.
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return SKLabelNode(text: "Error") }
        
        let sqPlane = SKShapeNode(rectOf: CGSize(width: 300, height: 100))
        return sqPlane
        
        
        
        //not to expect to reach here
        return SKLabelNode(text: "Error")
    }
    


    
    
    
    /*
     //to attach a bug image to anchor
     func view(_ view: ARSKView,
     nodeFor anchor: ARAnchor) -> SKNode? {
     let bug = SKSpriteNode(imageNamed: "bug")
     bug.name = "bug"
     return bug
     }
     */
}

class uARScene: SKScene {
    
    private var sceneView: ARSKView {
        return view as! ARSKView
    }
    
    private var isWorldSetUp = false
    
    public enum CoordinateMode {
        case accordingToMe //sets the coordinate system of augmented objects according to camera facing, front means X meter in front of camera
        case accordingToCompass //sets the coordinate system of augmented objects according to real compass, front means X meter on north, right means X meter at east
    }
    
    public var lightingFactor :CGFloat=0.0
    
    private var coordinateMode = CoordinateMode.accordingToMe
    
    var items = [uARItem]()
    
    var itemIdLast = 1
    
    private func addLabelItem(label: String, position: coordinate, lightingFactor: Float) -> Int {
        let i=uARItem(itemId: itemIdLast, type: ItemType.label, position: position, itemObject: SKLabelNode(text: label), lightingFactor: lightingFactor)
        items.append(i)
        self.itemIdLast=self.itemIdLast+1
        isWorldSetUp = false //
        return itemIdLast-1
    }
    
    func addLabelItem(label: String, position: coordinate) -> Int {
        return addLabelItem(label: label, position: position, lightingFactor: 0.0)
    }
    
    private func addImageItem(imageName: String, position: coordinate, lightingFactor: Float) -> Int {
        
        var s=String(imageName.prefix(7))
        s=s.lowercased()
        if s == "http://" || s == "https:/" {

            DispatchQueue.global().async(execute: {
                let url = NSURL(string: imageName)
                let data = NSData(contentsOf: url! as URL) //make sure your image in this url does exist, otherwise unwrap in a if let check
                let theImage = UIImage(data: data! as Data)
                let Texture = SKTexture(image: theImage!)                
                let i=uARItem(itemId: self.itemIdLast, type: ItemType.image, position: position, itemObject: SKSpriteNode(texture: Texture), lightingFactor: lightingFactor)
                
                self.items.append(i)
                self.itemIdLast=self.itemIdLast+1
                self.isWorldSetUp = false //
            })

        } else {
            let i=uARItem(itemId: itemIdLast, type: ItemType.image, position: position, itemObject: SKSpriteNode(imageNamed: imageName), lightingFactor: lightingFactor)
            items.append(i)
            self.itemIdLast=self.itemIdLast+1
            isWorldSetUp = false //
        }
        return itemIdLast-1
    }
    
    func addImageItem(imageName: String, position: coordinate) -> Int {
        return addImageItem(imageName: imageName, position: position, lightingFactor: 0.0)
    }
    
    
    func addVideoItem(videoName: String, position: coordinate) -> Int {
        return addVideoItem(videoName: videoName, position: position, lightingFactor: 0.0)
    }
    
    private func addVideoItem(videoName: String, position: coordinate, lightingFactor: Float) -> Int {
        
        var s=String(videoName.prefix(7))
        s=s.lowercased()
        if s == "http://" || s == "https:/" {
            
            DispatchQueue.global().async(execute: {
               
                let i=uARItem(itemId: self.itemIdLast, type: ItemType.video, position: position, itemObject: SKVideoNode(url: URL(string: videoName)!), lightingFactor: lightingFactor)
                let vn:SKVideoNode=i.itemObject as! SKVideoNode
                vn.play()
                
                self.items.append(i)
                self.itemIdLast=self.itemIdLast+1
                self.isWorldSetUp = false //
            })
            
        } else {
            print("video")
            let i=uARItem(itemId: itemIdLast, type: ItemType.video, position: position, itemObject: SKVideoNode(fileNamed: videoName), lightingFactor: lightingFactor)
            let vn:SKVideoNode=i.itemObject as! SKVideoNode
            vn.play()
            items.append(i)
            self.itemIdLast=self.itemIdLast+1
            isWorldSetUp = false //
        }
        return itemIdLast-1
    }
    


    
    /*
    func setCoordinateMode(mode: CoordinateMode){
        self.coordinateMode = mode
        //let configuration=sceneView.session.configuration;
        let configuration = ARWorldTrackingConfiguration()
        switch mode {
        case CoordinateMode.accordingToMe:
            configuration.worldAlignment=ARConfiguration.WorldAlignment.gravity
            break
        case CoordinateMode.accordingToCompass:
            configuration.worldAlignment=ARConfiguration.WorldAlignment.gravityAndHeading
            break
        }
        
        sceneView.session.run(configuration, options:[ .resetTracking ])
    }
    */
    
    
    
    
    
    private func setUpWorld() {
        guard let currentFrame = sceneView.session.currentFrame
            else { return }
        
        let configuration=ARWorldTrackingConfiguration()
        //let configuration = AROrientationTrackingConfiguration()
        switch coordinateMode {
        case CoordinateMode.accordingToMe:
            configuration.worldAlignment=ARConfiguration.WorldAlignment.gravity
            break
        case CoordinateMode.accordingToCompass:
            configuration.worldAlignment=ARConfiguration.WorldAlignment.gravityAndHeading
            break
        }
        sceneView.session.configuration?.worldAlignment=ARConfiguration.WorldAlignment.gravity
        sceneView.session.run(sceneView.session.configuration!, options: [.removeExistingAnchors, .resetTracking ])
        
        
        for (index, item) in items.enumerated() {
            var translation = matrix_identity_float4x4
            translation.columns.3.y = item.position.right
            translation.columns.3.x = -1 * item.position.top
            translation.columns.3.z = -1 * item.position.front
            let transform = currentFrame.camera.transform * translation
            //let transform = translation
            
            let anchor = ARAnchor(transform: transform)
            sceneView.session.add(anchor: anchor)
            items[index].anchorID=anchor.identifier
        }
        
        isWorldSetUp = true
    }
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        if !isWorldSetUp {
            setUpWorld()
        }
        
        
        //needed for light estimation
        //1
        guard let currentFrame = sceneView.session.currentFrame,
            let lightEstimate = currentFrame.lightEstimate else {
                return
        }
        
        // 2
        let neutralIntensity: CGFloat = 1000
        let ambientIntensity = min(lightEstimate.ambientIntensity,
                                   neutralIntensity)
        let blendFactor = 1 - ambientIntensity / neutralIntensity
        
        // 3
        for node in children {
            if let itemObject = node as? SKSpriteNode {
                itemObject.color = .black
                itemObject.colorBlendFactor = blendFactor * self.lightingFactor
            }
        }
        //end of light estimation
    }
    
    
}
