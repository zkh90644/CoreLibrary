//
//  MaskView.swift
//  maskView
//
//  Created by zkhCreator on 8/20/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit

extension UIImage{
    func imageReplaceColor(tintColor:UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        
        tintColor.setFill()
        
        let bounds = CGRectMake(0, 0, self.size.width, self.size.height)
        UIRectFill(bounds)
        
        self.drawInRect(bounds, blendMode: CGBlendMode.DestinationIn, alpha: 1.0)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

public class MaskView: UIImageView {
    var backgroundImage:UIImage
    public var maskViewArray:[UILabel]
    
    //    用于存储遮住图片在moveView中的移动位置
    private var infoArray:Array<(offset:CGPoint,image:UIImage,label:UILabel)>
    
    override init(frame: CGRect) {
        maskViewArray = []
        infoArray = []
        self.backgroundImage = UIImage()
        
        super.init(frame: frame)
        
        self.userInteractionEnabled = true
    }
    
    convenience public init(image:UIImage,frame:CGRect) {
        self.init(frame:frame)
        
        self.image = image
        backgroundImage = image
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     * 当Move的frame发生改变的时候，对每次的遮罩效果进行重新渲染
     *
     * @param    label    遮住的文字
     *
     * @date     2016-8-21
     * @author   zkh90644@gmail.com
     */
    public func changeMoveImage()throws {
        
        var flag = false
        infoArray = []
        
        for item in maskViewArray {
            if (self.frame.origin.y + self.frame.height) >= item.frame.origin.y &&
                self.frame.origin.y < item.frame.origin.y + item.frame.height &&
                self.frame.origin.x + self.frame.width >= item.frame.origin.x &&
                self.frame.origin.x < item.frame.origin.x + item.frame.width{
                
                try changeImage(item)
                flag = true
            }
        }
        
        if flag == true {
            //        重新绘制UIImageView的layer
            UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 2)
            
            //        将界面用背景图先渲染一遍
            backgroundImage.drawInRect(CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
            
            for item in infoArray {
                item.image.drawInRect(CGRect.init(x: item.offset.x, y: item.offset.y, width: item.label.frame.width, height: item.label.frame.height))
            }
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            
            //            关闭上下文
            UIGraphicsEndImageContext()
            
            self.image = image
            
        }else{
            self.image = backgroundImage
        }
    }
    
    
    /**
     * 获得每个图片被遮住的部分以及与MoveView的位置关系，并进行存储
     *
     * @param    label    遮住的文字
     *
     * @date     2016-8-21
     * @author   zkh90644@gmail.com
     */
    func changeImage(label:UILabel)throws{
        
        //        将内容图片绘制到对应的位置
        let offsetX = label.frame.origin.x - self.frame.origin.x
        let offsetY = label.frame.origin.y - self.frame.origin.y
        
        //        创建对应图片在当前位置的修改图
        let contentImage = try getMaskImage(label,offset: CGSize.init(width: -offsetX, height: -offsetY))
        
        self.infoArray.append((CGPoint.init(x: offsetX, y: offsetY),contentImage,label))
    }
    
    /**
     * 获得每个图片被遮住的部分
     *
     * @param    label    遮住的文字
     * @param    offset     遮罩图层的图片
     *
     * @returns  UIImage    遮罩效果产生的背景图
     *
     * @date     2016-8-21
     * @author   zkh90644@gmail.com
     */
    func getMaskImage(label:UILabel,offset:CGSize)throws -> UIImage{
        
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
        
        
        //        获得需要去掉的图片
        UIGraphicsBeginImageContextWithOptions((label.frame.size), false, 2)
        
        backgroundImage.drawInRect(CGRect.init(x: offset.width, y: offset.height, width: self.frame.width, height: self.frame.height))
        
        let backImage = UIGraphicsGetImageFromCurrentImageContext()
        
        
        UIGraphicsEndImageContext()
        
        let result = maskImage(backImage, mask: currentImage)
        
        //        获得实际上绘制的UIImage
        UIGraphicsBeginImageContextWithOptions((label.frame.size), false, 2)
        
        backImage.imageReplaceColor(UIColor.whiteColor()).drawInRect(CGRect.init(origin: CGPoint.zero, size: label.frame.size))
        
        result.drawInRect(CGRect.init(origin: CGPoint.zero, size: label.frame.size))
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return resultImage
    }
    
    /**
     * 生成遮罩效果图
     *
     * @param    image    需要遮罩的图片
     * @param    mask     遮罩图层的图片
     *
     * @returns  UIImage    遮罩效果产生的背景图
     *
     * @date     2016-8-21
     * @author   zkh90644@gmail.com
     */
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
