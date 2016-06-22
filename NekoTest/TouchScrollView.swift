//
//  TouchScrollView.swift
//  NekoTest
//
//  Created by NU on 2016/06/07.
//  Copyright © 2016年 NaoyaUchisawa. All rights reserved.
//

import Foundation
import UIKit

class touchScrollView:UIScrollView{
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        superview?.touchesBegan(touches, withEvent: event)
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        superview?.touchesMoved(touches, withEvent: event)
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        superview?.touchesEnded(touches, withEvent: event)
    }
}