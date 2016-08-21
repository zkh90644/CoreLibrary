//
//  ViewController.swift
//  ASMaskImageViewDemo
//
//  Created by zkhCreator on 8/21/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit
import ASMaskImageView

class ViewController: UIViewController {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    var touchView:MaskView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        touchView = MaskView.init(image:UIImage.init(named: "1")!,frame: CGRect.init(origin: CGPoint(x: 0,y: 0), size: CGSize(width: 100, height: 100)))
        
        //        添加到父View
        self.view.addSubview(touchView!)
        
        //        添加移动手势
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(ViewController.move(_:)))
        touchView!.addGestureRecognizer(gesture)
        
        //        将对应的label加入touchView中
        touchView!.maskViewArray.append(label1)
        touchView!.maskViewArray.append(label2)
        touchView!.maskViewArray.append(label3)
        
        try! touchView?.changeMoveImage()
    }
    
    func move(gesture:UIPanGestureRecognizer)throws {
        touchView?.center = gesture.locationInView(self.view)
        
        try touchView?.changeMoveImage()
        
    }
    
}

