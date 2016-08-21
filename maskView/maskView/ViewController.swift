//
//  ViewController.swift
//  maskView
//
//  Created by zkhCreator on 8/19/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit

var i = 1

class ViewController: UIViewController,UIGestureRecognizerDelegate {

    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var maskText2: UILabel!
    @IBOutlet weak var maskText1: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var infoArr = Array<(offset:CGPoint,image:UIImage,label:UILabel)>()
    
    var coverImage:UIImage?
    var touchView:MaskView?
    
    var backgroundImage = UIImage.init(named: "1")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        touchView = MaskView.init(frame: CGRect.init(origin: CGPoint(x: 0,y: 0), size: CGSize(width: 100, height: 50)))
        
        touchView?.image = UIImage.init(named: "1")
        touchView?.backgroundImage = touchView?.image
        
//        添加到父View
        self.view.addSubview(touchView!)
        
//        添加移动手势
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(ViewController.move(_:)))
        touchView!.addGestureRecognizer(gesture)
        
//        将对应的label加入touchView中
        touchView!.maskViewArray.append(maskText1)
        touchView!.maskViewArray.append(maskText2)
        
    }
    
//    移动效果
    func move(gesture:UIPanGestureRecognizer)throws {
        touchView?.center = gesture.locationInView(self.view)
        
        try touchView?.changeMoveImage()

    }
}

