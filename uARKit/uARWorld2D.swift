// Version 1.0

import ARKit

extension uARWorld2D: ARSKViewDelegate, ARSCNViewDelegate, ARSessionDelegate {
    func session(_ session: ARSession,
                 didFailWithError error: Error) {
        print("AR Session Failed - probably due to lack of camera access")
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        print("AR Session interrupted")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        print("AR Session resumed")
        worldView.session.run(session.configuration!,
                              options: [.resetTracking,
                                        .removeExistingAnchors])
    }
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        
        //find the item and return
        for item in items {
            if item.anchorID == anchor.identifier {
                item.isShown = true
                return item.itemObject
            }
        }
        
        //return empty node for auto detected planes
        return SKNode()
    }
    
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            //pass if the anchor was not added by auto detection or hitTest
            guard let _ = anchor as? ARPlaneAnchor else { continue }
            //print("auto detected anchor")
            
            //when detected a plane, if there is a hit based item waiting to be shown, add its anchor
            for item in items{
                if item.positionType == .hitTest && !item.isShown {
                    //print("Hit item")
                    
                    let hitResult = session.currentFrame?.hitTest(item.hitPoint, types: [ .estimatedHorizontalPlane ])
                    if let closestResult = hitResult?.first {
                        let anchor = ARAnchor(transform: (closestResult.worldTransform))
                        item.anchorID = anchor.identifier
                        //print("Hit detected")
                        session.add(anchor: anchor)
                    }
                }
            }
        }
    }
    
    /*
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        for anchor in anchors {
            //pass if the anchor was not added by auto detection or hitTest
            guard let planeAnchor = anchor as? ARPlaneAnchor else { continue }
            
            for (index, anc) in self.detectedAnchors.enumerated() {
                if anc.identifier == planeAnchor.identifier {
                    self.detectedAnchors.remove(at: index)
                }
            }
        }
    }
 */
    
}

class uARWorld2D: SKScene {

    private var worldView: ARSKView {
        return view as! ARSKView
    }

    private var isTransformSetup = false
    
    public enum CoordinateMode {
        case relative //sets the coordinate system of augmented objects according to camera facing, front means X meter in front of camera
        case compass //sets the coordinate system of augmented objects according to real compass, front means X meter on north, right means X meter at east
    }
    
    private var lightingFactor :CGFloat = 0.0
    
    private var coordinateMode = CoordinateMode.relative
    
    private var items = [uARItem]()
    
    private var itemIdLast = 1
    
    //private var isHitActive: Bool = false;
    
    //private var detectedAnchors = [ARAnchor]()
    
    public func setLigtingFactor(factor: CGFloat){
        self.lightingFactor = factor
    }
    
    private func addLabelItem(label: String, fontSize: CGFloat = 36, fontColor: UIColor = UIColor.white, fontName: String = "Helvetica", position: coordinate, positionType: PositionType) -> Int {
        
        let labelNode=SKLabelNode(text: label)
        labelNode.fontSize = fontSize
        labelNode.fontColor = fontColor
        labelNode.fontName = fontName
        
        let i=uARItem(itemId: itemIdLast, type: ItemType.label, position: position, positionType: positionType, itemObject: labelNode)
        items.append(i)
        self.itemIdLast=self.itemIdLast+1
        isTransformSetup = false
        return itemIdLast-1
    }
    
    public func addLabelItem(label: String, fontSize: CGFloat = 36, fontColor: UIColor = UIColor.white, fontName: String = "Helvetica") -> Int {
        return addLabelItem(label: label, fontSize: fontSize, fontColor: fontColor, fontName: fontName, position: coordinate(top:0.0, right: 0.0, front: 0.0), positionType: .hitTest)
    }
    
    public func addLabelItem(label: String, fontSize: CGFloat = 36, fontColor: UIColor = UIColor.white, fontName: String = "Helvetica", position: coordinate) -> Int {
        return addLabelItem(label: label, fontSize: fontSize, fontColor: fontColor, fontName: fontName, position: position, positionType: .coordinate)
    }
    
    public func addLabelItem(facingMe: Bool, label: String, fontSize: CGFloat = 36, fontColor: UIColor = UIColor.white, fontName: String = "Helvetica", position: coordinate) -> Int {
        if facingMe {
            return addLabelItem(label: label, fontSize: fontSize, fontColor: fontColor, fontName: fontName, position: position, positionType: .facing_me)
        } else {
            return addLabelItem(label: label, fontSize: fontSize, fontColor: fontColor, fontName: fontName, position: position, positionType: .coordinate)
        }
    }
    
    private func addImageItem(imageName: String, position: coordinate, positionType: PositionType) -> Int {
        
        var s=String(imageName.prefix(7))
        s=s.lowercased()
        if s == "http://" || s == "https:/" {
            self.itemIdLast=self.itemIdLast+1
            DispatchQueue.global().async(execute: {
                let url = NSURL(string: imageName)
                if let data = NSData(contentsOf: url! as URL) { //make sure your image in this url does exist, otherwise unwrap in a if let check
                    let theImage = UIImage(data: data as Data)
                    let Texture = SKTexture(image: theImage!)
                    let i=uARItem(itemId: self.itemIdLast-1, type: ItemType.image, position: position, positionType: positionType ,itemObject: SKSpriteNode(texture: Texture))

                    self.items.append(i)
                    self.isTransformSetup = false //
                }
            })

        } else {
            self.itemIdLast=self.itemIdLast+1
            if let imageNode: SKSpriteNode = SKSpriteNode(imageNamed: imageName) {
                let i=uARItem(itemId: itemIdLast, type: ItemType.image, position: position, positionType: positionType ,itemObject: imageNode)
                items.append(i)
                isTransformSetup = false
            }
        }
        return itemIdLast-1
    }

    public func addImageItem(facingMe: Bool, imageName: String, position: coordinate) -> Int {
        if facingMe {
            return addImageItem(imageName: imageName, position: position, positionType: .facing_me)
        } else {
            return addImageItem(imageName: imageName, position: position, positionType: .coordinate)
        }
    }
    
    public func addImageItem(imageName: String, position: coordinate) -> Int {
        return addImageItem(imageName: imageName, position: position, positionType: .coordinate)
    }
    
    public func addImageItem(imageName: String) -> Int {
        return addImageItem(imageName: imageName, position: coordinate(top: 0.0, right: 0.0, front: 0.0), positionType: .hitTest)
    }

    
    private func addVideoItem(videoName: String, position: coordinate, positionType: PositionType) -> Int {
        
        var s=String(videoName.prefix(7))
        s=s.lowercased()
        if s == "http://" || s == "https:/" {
           self.itemIdLast=self.itemIdLast+1
            DispatchQueue.global().async(execute: {
               
                if let videoNode:SKVideoNode = SKVideoNode(url: URL(string: videoName)!) {
                    let i=uARItem(itemId: self.itemIdLast, type: ItemType.video, position: position, positionType: positionType,  itemObject: videoNode)
                    videoNode.play()
                    
                    self.items.append(i)
                    self.isTransformSetup = false
                }
            })
            
        } else {
            let vn: SKVideoNode? = {
                guard let urlString = Bundle.main.path(forAuxiliaryExecutable: videoName) else {
                    return nil
                }
                
                let url = URL(fileURLWithPath: urlString)
                let item = AVPlayerItem(url: url)
                let player = AVPlayer(playerItem: item)
                
                return SKVideoNode(avPlayer: player)
            }()
            
            self.itemIdLast=self.itemIdLast+1
            if vn != nil {
                let i=uARItem(itemId: itemIdLast, type: ItemType.video, position: position, positionType: positionType, itemObject: vn!)
                vn?.play()
                items.append(i)
                isTransformSetup = false
            } else {
                
            }
        }
        return itemIdLast-1
    }
    
    public func addVideoItem(videoName: String) -> Int {
        return addVideoItem(videoName: videoName, position: coordinate(top: 0.0, right: 0.0, front: 0.0), positionType: .hitTest)
    }
    
    public func addVideoItem(videoName: String, position: coordinate) -> Int {
        return addVideoItem(videoName: videoName, position: position, positionType: .coordinate)
    }
    
    public func addVideoItem(facingMe: Bool, videoName: String, position: coordinate) -> Int {
        if facingMe {
            return addVideoItem(videoName: videoName, position: position, positionType: .facing_me)
        } else {
            return addVideoItem(videoName: videoName, position: position, positionType: .coordinate)
        }
    }
    


    
    
    public func setCoordinateMode(mode: CoordinateMode){
        self.coordinateMode = mode
        //let configuration=worldView.session.configuration;
        let configuration = ARWorldTrackingConfiguration()
        switch mode {
        case CoordinateMode.relative:
            configuration.worldAlignment=ARConfiguration.WorldAlignment.gravity
            break
        case CoordinateMode.compass:
            configuration.worldAlignment=ARConfiguration.WorldAlignment.gravityAndHeading
            break
        }
        configuration.planeDetection = .horizontal
        worldView.session.run(configuration, options:[ .resetTracking ])
    }
    
    
    public func resetRelativeCoordinate(){
        worldView.session.run(worldView.session.configuration!, options: .resetTracking)
    }
    
    
    
    
    
    
    private func setUpTransform() {
        guard let currentFrame = worldView.session.currentFrame
            else { return }
        
        for (index, item) in items.enumerated() {
            
            if item.isShown {
                continue
            }
            
            var transform: simd_float4x4 = matrix_identity_float4x4
            var translation = matrix_identity_float4x4
            
            if item.positionType == .facing_me ||
                item.positionType == .coordinate {
                
                if item.positionType == .facing_me {
                    translation.columns.3.y = item.position.right
                    translation.columns.3.x = -1 * item.position.top
                    translation.columns.3.z = -1 * item.position.front
                    transform = currentFrame.camera.transform * translation
                } else if item.positionType == .coordinate {
                    translation.columns.3.x = item.position.right
                    translation.columns.3.y = item.position.top
                    translation.columns.3.z = -1 * item.position.front
                    transform = translation
                }
                
                let anchor = ARAnchor(transform: transform)
                worldView.session.add(anchor: anchor)
                items[index].anchorID=anchor.identifier
            }
        }
        isTransformSetup = true
    }
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        if !isTransformSetup {
            setUpTransform()
        }
        
        
        //light estimation
        //1
        guard let currentFrame = worldView.session.currentFrame,
            let lightEstimate = currentFrame.lightEstimate else {
                return
        }
        
        // 2
        let neutralIntensity: CGFloat = 1000
        let ambientIntensity = min(lightEstimate.ambientIntensity,
                                   neutralIntensity)
        let blendFactor = 1 - ambientIntensity / neutralIntensity
        
        // 3 set lighting for SKSpriteNode(image) and label items, no ligting effect for videos
        for node in children {
            if let itemObject = node as? SKSpriteNode {
                itemObject.color = .black
                itemObject.colorBlendFactor = blendFactor * self.lightingFactor
            } else if let itemObject = node as? SKLabelNode {
                itemObject.color = .black
                itemObject.colorBlendFactor = blendFactor * self.lightingFactor
            }
        }
        //end of light estimation
    }
    
    
}
