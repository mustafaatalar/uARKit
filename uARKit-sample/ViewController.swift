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
        //scene.setCoordinateMode(mode: uARScene.CoordinateMode.accordingToCompass)
        //scene.addLabelItem(label: "hello", position: coordinate(top: 0,  right: 0, front: 1))
        //world.addImageItem(imageName: "http://lify.me/wk/emocan/assets/fikriye-emocan.png", position: coordinate(top:0, right:0, front:1))
        //scene.addImageItem(facingMe: false, imageName: "fikriye", position: coordinate(top:0, right:0, front:5))
        //scene.addImageItem(imageName: "fikriye")
        //world.addImageItem(imageName: "fikriye", hitPoint: CGPoint(x:0.5, y:0.5))
        //scene.addLabelItem(label: "merhaba", position: coordinate(top: 0,  right: 0, front: 1))
        //scene.addLabelItem(label: "yuppi", position: coordinate(top: 1,  right: -1, front: 1))
        
        _=world.addVideo(videoName: "myvideo2.mp4", position: coordinate(top:0, right:0, front:5))
        //_=world.addVideoItem(videoName: "http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4", position: coordinate(top:0, right:0, front:5))
    }
    
    @IBAction func button2Clicked(){
        _=world.addLabel(label: "label2", position: coordinate(top: 1,  right: 0, front: 1))
    }
    
    @IBAction func button3Clicked(){
        _=world.addLabel(label: "label3", fontSize:8, position: coordinate(top: 0,  right: 0, front: 1))
    }
    
    @IBAction func button4Clicked(){
        world.resetRelativeCoordinate()
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        world.setCoordinateMode(mode: .relative)
        world.setLigtingFactor(factor: 0.1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

