//
//  Count.swift
//  NekoTest
//
//  Created by naoya uchisawa on 2016/07/04.
//  Copyright © 2016年 NaoyaUchisawa. All rights reserved.
//

import Foundation
import UIKit

class Count: UIView{
    let sS = UIScreen.main.bounds.size
    var scale: CGFloat = 1
    var progress: CGFloat = 0
    override func draw(_ rect: CGRect) {
        let arc = UIBezierPath(arcCenter: CGPoint(x: sS.width/2, y: sS.height/2), radius: 100 * scale, startAngle: CGFloat(M_PI)*1.5, endAngle: progress, clockwise: true)
        arc.lineWidth = 50 * scale
        UIColor.darkGray.setStroke()
        arc.stroke()
        print(progress)
    }
    
    func loadScale()->CGFloat{
        if sS.height > 1000{
            return 2.4
        }else if sS.height > 700{
            return 1.29375
        }else if sS.height > 650{
            return 1.171875
        }else{
            return 1.0
        }
    }
    func settingProgress(_ progress:CGFloat){
        self.progress = progress
    }
    init(frame: CGRect,progress: CGFloat) {
        super.init(frame:frame)
        self.progress = progress
        scale = loadScale()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
