//
//  ViewController.swift
//  framework-test3
//
//  Created by Mustafa Atalar on 22.10.2017.
//  Copyright © 2017 Mustafa Atalar. All rights reserved.
//

import UIKit


class ViewController: uARView2DController {
    
    @IBAction func button1Clicked(){
        //_=world.addImage(imageName: "penguen")
        _=world2D.addImage(imageName: "http://lify.me/wk/emocan/assets/fikriye-emocan.png", position: coordinate(top: 0, right: 0, front: 3))
        //_=world.addImage(facingMe: true, imageName: "penguen", position: coordinate(top: 0, right: 0, front: 10))
        
        //_=world.addLabel(label: "merhaba")
        //_=world.addLabel(label: "merhaba", position: coordinate(top: 0, right: 0, front: 5))
        //_=world.addLabel(facingMe: true, label: "merhaba", position: coordinate(top: 0, right: 0, front: 3))
        
        //_=world.addVideo(videoName: "myvideo2.mp4")
        //_=world.addVideo(videoName: "http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4", position: coordinate(top: 0, right: 0, front: 5))
        //_=world.addVideo(facingMe: true, videoName: "myvideo2.mp4", position: coordinate(top: 0, right: 0, front: 7))
    }
    
    @IBAction func button2Clicked(){
        _=world2D.addLabel(label: "label2", position: coordinate(top: 1,  right: 0, front: 1))
    }
    
    @IBAction func button3Clicked(){
        _=world2D.addLabel(label: "label3", fontSize:8, position: coordinate(top: 0,  right: 0, front: 1))
    }
    
    @IBAction func button4Clicked(){
        world2D.resetRelativeCoordinate()
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        world2D.setCoordinateMode(mode: .compass)
        world2D.setLigtingFactor(factor: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

