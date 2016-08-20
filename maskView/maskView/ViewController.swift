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
    var touchView:UIImageView?
    
    var backgroundImage = UIImage.init(named: "1")
//    var touchView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        创建用来移动的UIImageView图片，即指针移动的图片
        let touchView = UIImageView.init(frame: CGRect.init(origin: CGPoint(x: 0,y: 0), size: CGSize(width: 100, height: 50)))
        
//        设置图片里面的内容，用来被遮罩
        touchView.image = UIImage.init(named: "1")
        touchView.userInteractionEnabled = true
        
//        添加到父View
        self.view.addSubview(touchView)
        
//        添加移动手势
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(ViewController.move(_:)))
        touchView.addGestureRecognizer(gesture)
        
//        赋值给系统的这个变量
        self.touchView = touchView
        
//        获得被遮住后的图片的遮罩显示效果图
//        getImageWithMask()
    }
    
//    获得遮罩变换后的对象
    func getImageWithMask() {
//        获得文字的图片格式
        UIGraphicsBeginImageContextWithOptions(self.maskText1.frame.size, false, 2)
//        获得上下文
        let context = UIGraphicsGetCurrentContext()
        
//        因为遮罩效果正反相逆，但是为了不改变原来的内容，所以要重新创建一个label
        let temp = UILabel.init(frame: maskText1.frame)
        temp.text = maskText1.text
        temp.font = maskText1.font
        temp.textColor = UIColor.whiteColor()
        
//        将文字绘制到图片上
        temp.layer.drawInContext(context!)
        
//        获得产生的相反的图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        touchView?.image?.drawInRect(CGRect.init(x: 0, y: 0, width: self.maskText1.frame.size.width, height: self.maskText1.frame.size.height))
        let touchImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        self.showImageView.image = touchImage
        
//        与原图产生遮罩效果
        let returnImage = maskImage(touchImage, mask: image)
        
        self.imageView.image = returnImage
        
    }
    
//    移动效果
    func move(gesture:UIPanGestureRecognizer) {
        
        var flag = false
        infoArr = []
        touchView!.center = gesture.locationInView(self.view)
        
        for item in [maskText1,maskText2] {
            if ((touchView?.frame.origin.y)! + (touchView?.frame.height)!) >= item.frame.origin.y &&
                (touchView?.frame.origin.y)! < item.frame.origin.y + item.frame.height &&
                (touchView?.frame.origin.x)! + (touchView?.frame.width)! >= item.frame.origin.x &&
                touchView?.frame.origin.x < item.frame.origin.x + item.frame.width{
                
                changeImage(item)
                flag = true
            }
        }
        
        if flag == true {
            //        重新绘制UIImageView的layer
            UIGraphicsBeginImageContextWithOptions((touchView?.frame.size)!, false, 2)
            
            //        将界面用背景图先渲染一边
            backgroundImage?.drawInRect(CGRect.init(x: 0, y: 0, width: (touchView?.frame.width)!, height: (touchView?.frame.height)!))
            
            for item in infoArr {
                item.image.drawInRect(CGRect.init(x: item.offset.x, y: item.offset.y, width: item.label.frame.width, height: item.label.frame.height))
            }
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            
            //            关闭上下文
            UIGraphicsEndImageContext()
            
            touchView?.image = image
            showImageView.image = image
        }else{
            touchView?.image = backgroundImage
        }
    }
    
//    修改移动图片的Image
    
    func changeImage(label:UILabel){
        
//        将内容图片绘制到对应的位置
        let offsetX = label.frame.origin.x - (touchView?.frame.origin.x)!
        let offsetY = label.frame.origin.y - (touchView?.frame.origin.y)!
        
//        创建对应图片在当前位置的修改图
        let contentImage = getMaskImage(label,offsetSize: CGSize.init(width: -offsetX, height: -offsetY))
        
        self.infoArr.append((CGPoint.init(x: offsetX, y: offsetY),contentImage,label))
    }
    
//    获得内部图片
    func getMaskImage(label:UILabel,offsetSize:CGSize) -> UIImage{

//        获得问题字图片
        UIGraphicsBeginImageContextWithOptions((label.frame.size), false, 2)
        
        let tempContext = UIGraphicsGetCurrentContext()
        
        let temp = UILabel.init(frame:label.frame)
        temp.font = label.font
        temp.text = label.text
        temp.textColor = UIColor.whiteColor()
        
        temp.layer.drawInContext(tempContext!)
        
        let currentImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        
//        获得需要扣掉的图片
        UIGraphicsBeginImageContextWithOptions((label.frame.size), false, 2)
        
        backgroundImage?.drawInRect(CGRect.init(x: offsetSize.width, y: offsetSize.height, width: (touchView?.frame.width)!, height: (touchView?.frame.height)!))
        
        let backImage = UIGraphicsGetImageFromCurrentImageContext()
        
        
        UIGraphicsEndImageContext()
        
        let result = maskImage(backImage, mask: currentImage)
        
//        获得实际上绘制的UIImage
        UIGraphicsBeginImageContextWithOptions((label.frame.size), false, 2)
        
        backImage.imageReplaceColor(UIColor.whiteColor()).drawInRect(CGRect.init(origin: CGPoint.zero, size: label.frame.size))
        
        result.drawInRect(CGRect.init(origin: CGPoint.zero, size: label.frame.size))
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
//        显示效果
        self.imageView.image = result
        self.imageView.backgroundColor = UIColor.greenColor()
        
        return resultImage
    }
    
//    进行遮罩变换
    func maskImage(image:UIImage, mask:(UIImage))->UIImage{
        
        let imageReference = image.CGImage
        let maskReference = mask.CGImage
        
        let imageMask = CGImageMaskCreate(CGImageGetWidth(maskReference),
                                          CGImageGetHeight(maskReference),
                                          CGImageGetBitsPerComponent(maskReference),
                                          CGImageGetBitsPerPixel(maskReference),
                                          CGImageGetBytesPerRow(maskReference),
                                          CGImageGetDataProvider(maskReference), nil, true)
        
        let maskedReference = CGImageCreateWithMask(imageReference, imageMask)
        
        let maskedImage = UIImage(CGImage:maskedReference!)
        
        return maskedImage
    }
    
    
}

