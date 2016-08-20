//
//  UIImageExtension.swift
//  ZafuNews
//
//  Created by zkhCreator on 7/31/16.
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