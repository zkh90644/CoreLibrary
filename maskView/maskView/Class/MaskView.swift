//
//  MaskView.swift
//  maskView
//
//  Created by zkhCreator on 8/20/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit
import Foundation

class MaskView: NSObject {
    var moveView:UIImageView
    var maskViewArray:[UILabel]
    
    override init() {
        moveView = UIImageView.init()
        maskViewArray = []
    }
    
    convenience init(moveView:UIImageView,maskViewArray:[UILabel]){
        self.init()
        self.moveView = moveView
        self.maskViewArray = maskViewArray
        
//        根据X坐标来排序
        self.maskViewArray.sortInPlace { (label1, label2) -> Bool in
            return label1.frame.origin.x < label2.frame.origin.x
        }
    }
    
    func setMoveViewPoint(point:CGPoint) {
        moveView.frame.origin = point
        
        
    }
    
//    func changeMoveViewImage() {
//        <#function body#>
//    }
    
    
    
    
}
