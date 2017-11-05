import ARKit

var worldView: ARSKView!
var world: uARWorld!

class uARViewController: UIViewController {
    
    @IBAction func button1Clicked(){
        //scene.setCoordinateMode(mode: uARScene.CoordinateMode.accordingToCompass)
        //scene.addLabelItem(label: "hello", position: coordinate(top: 0,  right: 0, front: 1))
        //scene.addImageItem(imageName: "http://lify.me/wk/emocan/assets/fikriye-emocan.png", position: coordinate(top:0, right:0, front:1))
        //scene.addImageItem(facingMe: false, imageName: "fikriye", position: coordinate(top:0, right:0, front:5))
        //scene.addImageItem(imageName: "fikriye")
        world.addImageItem(imageName: "fikriye", hitPoint: CGPoint(x:0.5, y:0.5))
        //scene.addLabelItem(label: "merhaba", position: coordinate(top: 0,  right: 0, front: 1))
        //scene.addLabelItem(label: "yuppi", position: coordinate(top: 1,  right: -1, front: 1))
        
        //_=scene.addVideoItem(videoName: "myvideo.mp4", position: coordinate(top:0, right:0, front:5))
        //scene.addVideoItem(videoName: "http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4", position: coordinate(top:0, right:0, front:5))
    }
    
    @IBAction func button2Clicked(){
        world.addLabelItem(label: "merhaba", position: coordinate(top: 1,  right: 0, front: 1))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        //let configuration = AROrientationTrackingConfiguration()
        configuration.worldAlignment=ARConfiguration.WorldAlignment.gravity
        configuration.planeDetection = .horizontal
        worldView.session.run(configuration)
        //scene.setCoordinateMode(mode: uARScene.CoordinateMode.accordingToCompass)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        worldView.session.pause()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let view = self.view as? ARSKView {
            world = uARWorld(size: view.bounds.size)
            worldView = view
            worldView!.delegate = world
            worldView.session.delegate = world
            world.scaleMode = .resizeFill
            world.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            view.showsFPS = true
            view.showsNodeCount = true
            view.presentScene(world)
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
