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
        outLineColor = UIColor.black
        outLineWidth = 0.64
    }
    
    override func drawText(in rect: CGRect) {
        let cr = UIGraphicsGetCurrentContext()!
        let textColor = self.textColor
        cr.setLineWidth(outLineWidth!)
        cr.setLineJoin(CGLineJoin.round)
        cr.setTextDrawingMode(CGTextDrawingMode.stroke)
        self.textColor = outLineColor
        super.drawText(in: rect)
        
        cr.setTextDrawingMode(CGTextDrawingMode.fill)
        self.textColor = textColor
        super.drawText(in: rect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
