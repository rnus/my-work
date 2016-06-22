//
//  ExtendedLabel.swift
//  NekoTest
//
//  Created by NU on 2016/06/10.
//  Copyright © 2016年 NaoyaUchisawa. All rights reserved.
//

import Foundation
import UIKit

class ExtendedLabel:UILabel{
    var outLineColor: UIColor?
    var outLineWidth: CGFloat?
    override init(frame: CGRect) {
        super.init(frame: frame)
        outLineColor = UIColor.blackColor()
        outLineWidth = 0.64
    }
    
    override func drawTextInRect(rect: CGRect) {
        let cr = UIGraphicsGetCurrentContext()!
        let textColor = self.textColor
        CGContextSetLineWidth(cr, outLineWidth!)
        CGContextSetLineJoin(cr, CGLineJoin.Round)
        CGContextSetTextDrawingMode(cr, CGTextDrawingMode.Stroke)
        self.textColor = outLineColor
        super.drawTextInRect(rect)
        
        CGContextSetTextDrawingMode(cr, CGTextDrawingMode.Fill)
        self.textColor = textColor
        super.drawTextInRect(rect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}