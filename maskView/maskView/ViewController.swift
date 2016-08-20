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
    
    func move(gesture:UIPanGestureRecognizer) {
        touchView!.center = gesture.locationInView(self.view)
        
        if ((touchView?.frame.origin.y)! + (touchView?.frame.height)!) >= maskText1.frame.origin.y &&
            (touchView?.frame.origin.y)! < maskText1.frame.origin.y + maskText1.frame.height &&
            (touchView?.frame.origin.x)! + (touchView?.frame.width)! >= maskText1.frame.origin.x &&
            touchView?.frame.origin.x < maskText1.frame.origin.x + maskText1.frame.width{
           
            
            
//            //            将产生的图片绘制到UIView的对应位置
//            let offsetX = maskText1.frame.origin.x - (touchView?.frame.origin.x)!
//            let offsetY = maskText1.frame.origin.y - (touchView?.frame.origin.y)!
//            
//            //            重新绘制UIImageView的layer
//            UIGraphicsBeginImageContextWithOptions((touchView?.frame.size)!, false, 2)
//            
//            //            获取上下文
//            let context = UIGraphicsGetCurrentContext()
//            
//            //            获得原图片的layer
//            backgroundImage!.drawAtPoint(CGPoint.init(x: 0, y: 0))
//            
//            //            绘制背景
//            CGContextSetRGBFillColor(context, 1, 1, 1, 1)
//            CGContextFillRect(context, CGRect.init(x: offsetX, y: offsetY, width: self.maskText1.frame.size.width, height: self.maskText1.frame.size.height))
//            
//            //            将渲染后的图放置到对应位置
//            imageView.image?.drawInRect(CGRect.init(x: offsetX, y: offsetY, width: self.maskText1.frame.size.width, height: self.maskText1.frame.size.height))
//            
//            let tempImage = UIGraphicsGetImageFromCurrentImageContext()
//            
//            UIGraphicsEndImageContext()
//            
//            //            将对应的内容放置到touchView中
//            touchView?.image = tempImage
            changeImage()
            
        }else{
            touchView?.image = backgroundImage
        }
        
    }
    
//    修改移动图片的Image
    
    func changeImage(){
        
        
//        创建对应图片在当前位置的修改图
        let contentImage = getMaskImage()
        
//        绘制整个touchview
        
//            重新绘制UIImageView的layer
        UIGraphicsBeginImageContextWithOptions((touchView?.frame.size)!, false, 2)
        
//            获取上下文
        let context = UIGraphicsGetCurrentContext()
        
//        将界面用背景图先渲染一边
        backgroundImage?.drawInRect(CGRect.init(x: 0, y: 0, width: (touchView?.frame.width)!, height: (touchView?.frame.height)!))
        
//        将内容图片绘制到对应的位置
        let offsetX = maskText1.frame.origin.x - (touchView?.frame.origin.x)!
        let offsetY = maskText1.frame.origin.y - (touchView?.frame.origin.y)!
        
        contentImage.drawInRect(CGRect.init(x: offsetX, y: offsetY, width: maskText1.frame.width, height: maskText2.frame.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
//            关闭上下文
        UIGraphicsEndImageContext()

        touchView?.image = image
        showImageView.image = image
    }
    
    func getMaskImage() -> UIImage{
        UIGraphicsBeginImageContextWithOptions((maskText1.frame.size), false, 2)
        
        let tempContext = UIGraphicsGetCurrentContext()
        
//        将产生的图片绘制到UIView的对应位置
        let offsetX = (touchView?.frame.origin.x)! - maskText1.frame.origin.x
        let offsetY = (touchView?.frame.origin.y)! - maskText1.frame.origin.y
        
//        先绘制背景
        backgroundImage?.drawInRect(CGRect.init(x: offsetX, y: offsetY, width: (touchView?.frame.width)!, height: (touchView?.frame.height)!))
        
//        获得当前的图片
        let backImage = UIGraphicsGetImageFromCurrentImageContext()
        
//        绘制文字
        let temp = UILabel.init(frame:maskText1.frame)
        temp.font = maskText1.font
        temp.text = maskText1.text
        temp.textColor = UIColor.whiteColor()
        
        temp.layer.drawInContext(tempContext!)
        
        let currentImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        self.imageView.image = currentImage
        
        return currentImage
    }
    
    
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

