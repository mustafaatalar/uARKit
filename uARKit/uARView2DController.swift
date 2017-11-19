// Version 1.0

import ARKit

var world2DView: ARSKView!
var world2D: uARWorld2D!

class uARView2DController: UIViewController {
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        world2DView.session.pause()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let view = self.view as? ARSKView {
            world2D = uARWorld2D(size: view.bounds.size)
            world2DView = view
            world2DView!.delegate = world2D
            world2DView.session.delegate = world2D
            world2D.scaleMode = .resizeFill
            world2D.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            //view.showsFPS = true
            //view.showsNodeCount = true
            view.presentScene(world2D)
            
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = .horizontal
            world2DView.session.run(configuration)
            world2D.setCoordinateMode(mode: .relative)
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

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
