//
//  ViewController.swift
//
//  Created by Mustafa Atalar on 22.10.2017.
//  Copyright © 2017 Mustafa Atalar. All rights reserved.
//

class ViewController: uARView2DController {
    
    @IBAction func button1Clicked(){
        _=world2D.addImage(imageName: "penguen")
    }
    
    @IBAction func button2Clicked(){
        _=world2D.addLabel(facingMe:true, label: "Hello!", position: coordinate(top: 0,  right: 0, front: 2))
    }
    
    @IBAction func button3Clicked(){
        _=world2D.addVideo(videoName: "myvideo2.mp4", position: coordinate(top: 5, right: 0, front: 3))
    }
    

    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        world2D.setCoordinateMode(mode: .relative)
        world2D.setLigtingFactor(factor: 0.8)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

