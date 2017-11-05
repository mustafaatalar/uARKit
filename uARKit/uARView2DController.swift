import ARKit

var worldView: ARSKView!
var world: uARWorld2D!

class uARView2DController: UIViewController {
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        worldView.session.pause()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let view = self.view as? ARSKView {
            world = uARWorld2D(size: view.bounds.size)
            worldView = view
            worldView!.delegate = world
            worldView.session.delegate = world
            world.scaleMode = .resizeFill
            world.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            //view.showsFPS = true
            //view.showsNodeCount = true
            view.presentScene(world)
            
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = .horizontal
            worldView.session.run(configuration)
            world.setCoordinateMode(mode: .relative)
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
        return true
    }
}
