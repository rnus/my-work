//
//  Neko.swift
//  NekoTest
//
//  Created by naoya uchisawa on 2016/06/22.
//  Copyright © 2016年 NaoyaUchisawa. All rights reserved.
//

import Foundation
import UIKit
class Neko{
    let sS = UIScreen.main.bounds.size
    var move = 0
    var progress = 0
    var currentProgress = 0
    var patience = Int(arc4random()%500)
    var nekoAndNumber:UIView?
    var imageView: UIImageView?
    var subImageView: UIImageView?
    var objectFrames:[String:CGRect] = [:]
    var foot: UIImageView?
    var label: ExtendedLabel?
    var color = 0
    var direction = 0
    var catchFlag = false
    var catchProgress = 0.0
    var first = true
    var px1:CGFloat = 0.0
    var py1:CGFloat = 0.0
    var px2:CGFloat = 0.0
    var py2:CGFloat = 0.0
    init(move: Int,label: ExtendedLabel,color:Int){
        let frame = CGRect(x: 0, y: 0, width: label.frame.width, height: label.frame.height)
        let colorAndPose = "shitDown" + String(color) + ".png"
        self.move = move
        self.label = label
        self.color = color
        self.nekoAndNumber = UIView(frame: label.frame)
        self.imageView = UIImageView(frame: frame)
        self.imageView!.image = UIImage(named: colorAndPose)
        self.label!.frame = frame
        if move == 3{
            let colorAndPose = "climb0" + String(color) + ".png"
            self.imageView!.image = UIImage(named: colorAndPose)
        }
        if move == 5 || move == 100{
            var colorAndPose = "lie0" + String(color) + ".png"
            self.imageView!.image = UIImage(named: colorAndPose)
            self.subImageView = UIImageView(frame: frame)
            colorAndPose = "tail1" + String(color) + ".png"
            self.subImageView!.image = UIImage(named: colorAndPose)
        }
        if move == 7{
            var colorAndPose = "ball" + String(color) + ".png"
            self.imageView!.image = UIImage(named: colorAndPose)
            self.subImageView = UIImageView(frame: frame)
            colorAndPose = "hand0" + String(color) + ".png"
            self.subImageView!.image = UIImage(named: colorAndPose)
        }
        nekoAndNumber!.addSubview(imageView!)
        nekoAndNumber!.addSubview(label)
        if subImageView != nil{
            nekoAndNumber?.addSubview(subImageView!)
            nekoAndNumber?.sendSubview(toBack: subImageView!)
        }
    }
    func addObjectFrames(_ name:String,frame:CGRect){
        objectFrames[name] = frame
    }
    func isOverlapObject(_ oFrame:CGRect,direction:Int)->Bool{
        var frame:CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        if direction == 0{
            frame = CGRect(x: nekoAndNumber!.frame.minX-1, y: nekoAndNumber!.frame.minY, width: nekoAndNumber!.frame.width, height: nekoAndNumber!.frame.height)
        }else if direction == 1{
            frame = CGRect(x: nekoAndNumber!.frame.minX, y: nekoAndNumber!.frame.minY-1, width: nekoAndNumber!.frame.width, height: nekoAndNumber!.frame.height)
        }else if direction == 2{
            frame = CGRect(x: nekoAndNumber!.frame.minX+1, y: nekoAndNumber!.frame.minY, width: nekoAndNumber!.frame.width, height: nekoAndNumber!.frame.height)
        }else if direction == 3{
            frame = CGRect(x: nekoAndNumber!.frame.minX, y: nekoAndNumber!.frame.minY+1, width: nekoAndNumber!.frame.width, height: nekoAndNumber!.frame.height)
        }else if direction == 4{
            frame = CGRect(x: nekoAndNumber!.frame.minX-1, y: nekoAndNumber!.frame.minY-1, width: nekoAndNumber!.frame.width, height: nekoAndNumber!.frame.height)
        }else if direction == 5{
            frame = CGRect(x: nekoAndNumber!.frame.minX+1, y: nekoAndNumber!.frame.minY-1, width: nekoAndNumber!.frame.width, height: nekoAndNumber!.frame.height)
        }else if direction == 6{
            frame = CGRect(x: nekoAndNumber!.frame.minX+1, y: nekoAndNumber!.frame.minY+1, width: nekoAndNumber!.frame.width, height: nekoAndNumber!.frame.height)
        }else if direction == 7{
            frame = CGRect(x: nekoAndNumber!.frame.minX-1, y: nekoAndNumber!.frame.minY+1, width: nekoAndNumber!.frame.width, height: nekoAndNumber!.frame.height)
        }
        if oFrame.intersects(frame){
            return true
        }else{
            return false
        }
    }
    func walkRight(_ images:[String:UIImage]){
        if progress <= 500{
            let current = progress / 10
            if current != currentProgress{
                if progress%100 <= 25{
                    let colorAndPose = "standr" + String(color)
                    imageView?.image = images[colorAndPose]
                }else if progress%100 <= 50{
                    let colorAndPose = "walk1r" + String(color)
                    imageView?.image = images[colorAndPose]
                }else if progress%100 <= 75{
                    let colorAndPose = "standr" + String(color)
                    imageView?.image = images[colorAndPose]
                }else{
                    let colorAndPose = "walk2r" + String(color)
                    imageView?.image = images[colorAndPose]
                }
                nekoAndNumber!.frame = CGRect(x: nekoAndNumber!.frame.minX+1, y: nekoAndNumber!.frame.minY,
                                                  width: nekoAndNumber!.frame.width, height: nekoAndNumber!.frame.height)
                currentProgress = current
            }
        }else{
            let colorAndPose = "shitDown" + String(color)
            imageView?.image = images[colorAndPose]
            move = 1
            progress = 0
            patience = Int(arc4random()%500)
        }
        progress += 1
    }
    func walkLeft(_ images:[String:UIImage]){
        if progress <= 500{
            let current = progress / 10
            if current != currentProgress{
                if progress%100 <= 25{
                    let colorAndPose = "stand" + String(color)
                    imageView?.image = images[colorAndPose]
                }else if progress%100 <= 50{
                    let colorAndPose = "walk1" + String(color)
                    imageView?.image = images[colorAndPose]
                }else if progress%100 <= 75{
                    let colorAndPose = "stand" + String(color)
                    imageView?.image = images[colorAndPose]
                }else{
                    let colorAndPose = "walk2" + String(color)
                    imageView?.image = images[colorAndPose]
                }
                nekoAndNumber!.frame = CGRect(x: nekoAndNumber!.frame.minX-1, y: nekoAndNumber!.frame.minY,
                                                  width: nekoAndNumber!.frame.width, height: nekoAndNumber!.frame.height)
                currentProgress = current
            }
        }else{
            let colorAndPose = "shitDown" + String(color)
            imageView?.image = images[colorAndPose]
            move = 0
            progress = 0
            patience = Int(arc4random()%500)
        }
        progress += 1
    }
    func circleRun(_ images:[String:UIImage]){
        if progress < 200{
            let current = progress / 10
            if current != currentProgress{
                if progress <= 20{
                    let colorAndPose = "run0" + String(color)
                    imageView?.image = images[colorAndPose]
                }else if progress <= 40{
                    let colorAndPose = "run1" + String(color)
                    imageView?.image = images[colorAndPose]
                }else if progress <= 60{
                    let colorAndPose = "run2" + String(color)
                    imageView?.image = images[colorAndPose]
                }else if progress <= 80{
                    let colorAndPose = "run1" + String(color)
                    imageView?.image = images[colorAndPose]
                }else if progress <= 100{
                    let colorAndPose = "run0" + String(color)
                    imageView?.image = images[colorAndPose]
                }else if progress <= 120{
                    let colorAndPose = "run0r" + String(color)
                    imageView?.image = images[colorAndPose]
                }else if progress <= 140{
                    let colorAndPose = "run1r" + String(color)
                    imageView?.image = images[colorAndPose]
                }else if progress <= 160{
                    let colorAndPose = "run2r" + String(color)
                    imageView?.image = images[colorAndPose]
                }else if progress <= 180{
                    let colorAndPose = "run1r" + String(color)
                    imageView?.image = images[colorAndPose]
                }else{
                    let colorAndPose = "run0r" + String(color)
                    imageView?.image = images[colorAndPose]
                }
                let rad = (Double(progress) + 0.01) * (360.0 / Double(200))
                let labelX = CGFloat(12 * cos(M_PI / 180 * rad))
                let labelY = CGFloat(12 * sin(M_PI / 180 * rad))
                nekoAndNumber!.frame = CGRect(x: nekoAndNumber!.frame.minX + labelX, y: nekoAndNumber!.frame.minY+labelY,
                                                  width: nekoAndNumber!.frame.width, height: nekoAndNumber!.frame.height)
                
                currentProgress = current
            }
        }else{
            let colorAndPose = "shitDown" + String(color)
            imageView?.image = images[colorAndPose]
            progress = 0
            patience = Int(arc4random()%500)
        }
        progress += 1
    }
    func climbUp(_ images:[String:UIImage]){
        if progress < 500{
            let current = progress / 10
            if current != currentProgress{
                if nekoAndNumber!.frame.minY - 1 > 0{
                    if progress < 125{
                        let colorAndPose = "climb0" + String(color)
                        imageView?.image = images[colorAndPose]
                    }else if progress < 250{
                        let colorAndPose = "climb1" + String(color)
                        imageView?.image = images[colorAndPose]
                    }else if progress < 375{
                        let colorAndPose = "climb0" + String(color)
                        imageView?.image = images[colorAndPose]
                    }else{
                        let colorAndPose = "climb2" + String(color)
                        imageView?.image = images[colorAndPose]
                    }
                    nekoAndNumber!.frame = CGRect(x: nekoAndNumber!.frame.minX, y: nekoAndNumber!.frame.minY-1,
                                                      width: nekoAndNumber!.frame.width, height: nekoAndNumber!.frame.height)
                }
                currentProgress = current
            }
        }else{
            let colorAndPose = "climb0" + String(color)
            imageView?.image = images[colorAndPose]
            move = 4
            progress = 0
            patience = Int(arc4random()%1000)
        }
        progress += 1
    }
    func climbDown(_ images:[String:UIImage],bottomEdge:CGFloat){
        if progress < 100{
            let current = progress / 10
            if current != currentProgress{
                if nekoAndNumber!.frame.minY + 5 < bottomEdge{
                    let colorAndPose = "climb0" + String(color)
                    imageView?.image = images[colorAndPose]
                    nekoAndNumber!.frame = CGRect(x: nekoAndNumber!.frame.minX, y: nekoAndNumber!.frame.minY + 5,
                                                      width: nekoAndNumber!.frame.width, height: nekoAndNumber!.frame.height)
                }
                currentProgress = current
            }
        }else{
            move = 3
            progress = 0
            patience = Int(arc4random()%1000)
        }
        progress += 1
    }
    func lie(_ images:[String:UIImage]){
        if progress < 100{
            let current = progress / 16
            if current != currentProgress{
                if progress <= 16{
                    let colorAndPose = "tail2" + String(color)
                    subImageView?.image = images[colorAndPose]
                }else if progress <= 32{
                    let colorAndPose = "tail3" + String(color)
                    subImageView?.image = images[colorAndPose]
                }else if progress <= 48{
                    let colorAndPose = "tail4" + String(color)
                    subImageView?.image = images[colorAndPose]
                }else if progress <= 64{
                    let colorAndPose = "tail3" + String(color)
                    subImageView?.image = images[colorAndPose]
                }else if progress <= 80{
                    let colorAndPose = "tail2" + String(color)
                    subImageView?.image = images[colorAndPose]
                }else if progress <= 100{
                    let colorAndPose = "tail1" + String(color)
                    subImageView?.image = images[colorAndPose]
                }
                
                currentProgress = current
            }
        }else{
            let colorAndPose = "tail1" + String(color)
            subImageView?.image = images[colorAndPose]
            progress = 0
            patience = Int(arc4random()%2000)
        }
        progress += 1
    }
    func walkAround(_ catSize:CGFloat,images:[String:UIImage],leftEdge:CGFloat,topEdge:CGFloat,rightEdge:CGFloat,bottomEdge:CGFloat,currentNum:Int){
        if progress < 1000{
            let current = Int(Double(progress)/1.5)
            if current != currentProgress{
                if currentProgress%100 == 1{
                    direction = Int(arc4random()%8)
                }
                if direction == 0{
                    if progress%100 <= 25{
                        let colorAndPose = "stand" + String(color)
                        imageView?.image = images[colorAndPose]
                    }else if progress%100 <= 50{
                        let colorAndPose = "walk1" + String(color)
                        imageView?.image = images[colorAndPose]
                    }else if progress%100 <= 75{
                        let colorAndPose = "stand" + String(color)
                        imageView?.image = images[colorAndPose]
                    }else{
                        let colorAndPose = "walk2" + String(color)
                        imageView?.image = images[colorAndPose]
                    }
                    var count = 0
                    if objectFrames["cardBoard"] != nil && isOverlapObject(objectFrames["cardBoard"]!, direction: 0){
                        count += 1
                    }
                    if objectFrames["tennisBall"] != nil && isOverlapObject(objectFrames["tennisBall"]!, direction: 0) && currentNum == Int(label!.text!){
                        move = 7
                        let frame = CGRect(x: objectFrames["tennisBall"]!.minX, y: objectFrames["tennisBall"]!.minY-catSize/1.5, width: catSize, height: catSize)
                        nekoAndNumber?.frame = frame
                        var colorAndPose = "ball" + String(color)
                        imageView?.image = images[colorAndPose]
                        subImageView = UIImageView(frame: imageView!.frame)
                        colorAndPose = "hand0" + String(color)
                        subImageView?.image = images[colorAndPose]
                        nekoAndNumber?.addSubview(subImageView!)
                    }
                    if objectFrames["baseball"] != nil && isOverlapObject(objectFrames["baseball"]!, direction: 0) && currentNum + 1 == Int(label!.text!){
                        move = 7
                        let frame = CGRect(x: objectFrames["baseball"]!.minX, y: objectFrames["baseball"]!.minY-catSize/1.5, width: catSize, height: catSize)
                        nekoAndNumber?.frame = frame
                        var colorAndPose = "ball" + String(color)
                        imageView?.image = images[colorAndPose]
                        subImageView = UIImageView(frame: imageView!.frame)
                        colorAndPose = "hand0" + String(color)
                        subImageView?.image = images[colorAndPose]
                        nekoAndNumber?.addSubview(subImageView!)
                    }
                    if nekoAndNumber!.frame.minX - 1 > leftEdge && (count == 0 || objectFrames["cardBoard"] == nil){
                        nekoAndNumber!.frame = CGRect(x: nekoAndNumber!.frame.minX-1, y: nekoAndNumber!.frame.minY,
                                                          width: nekoAndNumber!.frame.width, height: nekoAndNumber!.frame.height)
                    }else{
                        direction = Int(arc4random()%8)
                    }
                }else if direction == 1{
                    if progress%100 <= 25{
                        let colorAndPose = "stand" + String(color)
                        imageView?.image = images[colorAndPose]
                    }else if progress%100 <= 50{
                        let colorAndPose = "walk1" + String(color)
                        imageView?.image = images[colorAndPose]
                    }else if progress%100 <= 75{
                        let colorAndPose = "stand" + String(color)
                        imageView?.image = images[colorAndPose]
                    }else{
                        let colorAndPose = "walk2" + String(color)
                        imageView?.image = images[colorAndPose]
                    }
                    var count = 0
                    if objectFrames["cardBoard"] != nil && isOverlapObject(objectFrames["cardBoard"]!, direction: 1){
                        count += 1
                    }
                    if objectFrames["tennisBall"] != nil && isOverlapObject(objectFrames["tennisBall"]!, direction: 1) && currentNum == Int(label!.text!){
                        move = 7
                        let frame = CGRect(x: objectFrames["tennisBall"]!.minX, y: objectFrames["tennisBall"]!.minY-catSize/1.5, width: catSize, height: catSize)
                        nekoAndNumber?.frame = frame
                        var colorAndPose = "ball" + String(color)
                        imageView?.image = images[colorAndPose]
                        subImageView = UIImageView(frame: imageView!.frame)
                        colorAndPose = "hand0" + String(color)
                        subImageView?.image = images[colorAndPose]
                        nekoAndNumber?.addSubview(subImageView!)
                    }
                    if objectFrames["baseball"] != nil && isOverlapObject(objectFrames["baseball"]!, direction: 1) && currentNum + 1 == Int(label!.text!){
                        move = 7
                        let frame = CGRect(x: objectFrames["baseball"]!.minX, y: objectFrames["baseball"]!.minY-catSize/1.5, width: catSize, height: catSize)
                        nekoAndNumber?.frame = frame
                        var colorAndPose = "ball" + String(color)
                        imageView?.image = images[colorAndPose]
                        subImageView = UIImageView(frame: imageView!.frame)
                        colorAndPose = "hand0" + String(color)
                        subImageView?.image = images[colorAndPose]
                        nekoAndNumber?.addSubview(subImageView!)
                    }
                    if nekoAndNumber!.frame.minY - 1 > topEdge && (count == 0 || objectFrames["cardBoard"] == nil){
                        nekoAndNumber!.frame = CGRect(x: nekoAndNumber!.frame.minX, y: nekoAndNumber!.frame.minY-1,
                                                          width: nekoAndNumber!.frame.width, height: nekoAndNumber!.frame.height)
                    }else{
                        direction = Int(arc4random()%8)
                    }
                }else if direction == 2{
                    if progress%100 <= 25{
                        let colorAndPose = "standr" + String(color)
                        imageView?.image = images[colorAndPose]
                    }else if progress%100 <= 50{
                        let colorAndPose = "walk1r" + String(color)
                        imageView?.image = images[colorAndPose]
                    }else if progress%100 <= 75{
                        let colorAndPose = "standr" + String(color)
                        imageView?.image = images[colorAndPose]
                    }else{
                        let colorAndPose = "walk2r" + String(color)
                        imageView?.image = images[colorAndPose]
                    }
                    var count = 0
                    if objectFrames["cardBoard"] != nil && isOverlapObject(objectFrames["cardBoard"]!, direction: 2){
                        count += 1
                    }
                    if objectFrames["tennisBall"] != nil && isOverlapObject(objectFrames["tennisBall"]!, direction: 2) && currentNum == Int(label!.text!){
                        move = 7
                        let frame = CGRect(x: objectFrames["tennisBall"]!.minX, y: objectFrames["tennisBall"]!.minY-catSize/1.5, width: catSize, height: catSize)
                        nekoAndNumber?.frame = frame
                        var colorAndPose = "ball" + String(color)
                        imageView?.image = images[colorAndPose]
                        subImageView = UIImageView(frame: imageView!.frame)
                        colorAndPose = "hand0" + String(color)
                        subImageView?.image = images[colorAndPose]
                        nekoAndNumber?.addSubview(subImageView!)
                    }
                    if objectFrames["baseball"] != nil && isOverlapObject(objectFrames["baseball"]!, direction: 2) && currentNum + 1 == Int(label!.text!){
                        move = 7
                        let frame = CGRect(x: objectFrames["baseball"]!.minX, y: objectFrames["baseball"]!.minY-catSize/1.5, width: catSize, height: catSize)
                        nekoAndNumber?.frame = frame
                        var colorAndPose = "ball" + String(color)
                        imageView?.image = images[colorAndPose]
                        subImageView = UIImageView(frame: imageView!.frame)
                        colorAndPose = "hand0" + String(color)
                        subImageView?.image = images[colorAndPose]
                        nekoAndNumber?.addSubview(subImageView!)
                    }
                    if nekoAndNumber!.frame.minX + catSize + 1 < rightEdge && (count == 0 || objectFrames["cardBoard"] == nil){
                        nekoAndNumber!.frame = CGRect(x: nekoAndNumber!.frame.minX+1, y: nekoAndNumber!.frame.minY,
                                                          width: nekoAndNumber!.frame.width, height: nekoAndNumber!.frame.height)
                    }else{
                        direction = Int(arc4random()%8)
                    }
                }else if direction == 3{
                    if progress%100 <= 25{
                        let colorAndPose = "standr" + String(color)
                        imageView?.image = images[colorAndPose]
                    }else if progress%100 <= 50{
                        let colorAndPose = "walk1r" + String(color)
                        imageView?.image = images[colorAndPose]
                    }else if progress%100 <= 75{
                        let colorAndPose = "standr" + String(color)
                        imageView?.image = images[colorAndPose]
                    }else{
                        let colorAndPose = "walk2r" + String(color)
                        imageView?.image = images[colorAndPose]
                    }
                    var count = 0
                    if objectFrames["cardBoard"] != nil && isOverlapObject(objectFrames["cardBoard"]!, direction: 3){
                        count += 1
                    }
                    if objectFrames["tennisBall"] != nil && isOverlapObject(objectFrames["tennisBall"]!, direction: 3) && currentNum == Int(label!.text!){
                        move = 7
                        let frame = CGRect(x: objectFrames["tennisBall"]!.minX, y: objectFrames["tennisBall"]!.minY-catSize/1.5, width: catSize, height: catSize)
                        nekoAndNumber?.frame = frame
                        var colorAndPose = "ball" + String(color)
                        imageView?.image = images[colorAndPose]
                        subImageView = UIImageView(frame: imageView!.frame)
                        colorAndPose = "hand0" + String(color)
                        subImageView?.image = images[colorAndPose]
                        nekoAndNumber?.addSubview(subImageView!)
                    }
                    if objectFrames["baseball"] != nil && isOverlapObject(objectFrames["baseball"]!, direction: 3) && currentNum + 1 == Int(label!.text!){
                        move = 7
                        let frame = CGRect(x: objectFrames["baseball"]!.minX, y: objectFrames["baseball"]!.minY-catSize/1.5, width: catSize, height: catSize)
                        nekoAndNumber?.frame = frame
                        var colorAndPose = "ball" + String(color)
                        imageView?.image = images[colorAndPose]
                        subImageView = UIImageView(frame: imageView!.frame)
                        colorAndPose = "hand0" + String(color)
                        subImageView?.image = images[colorAndPose]
                        nekoAndNumber?.addSubview(subImageView!)
                    }
                    if nekoAndNumber!.frame.minY + catSize + 1 < bottomEdge && (count == 0 || objectFrames["cardBoard"] == nil){
                        nekoAndNumber!.frame = CGRect(x: nekoAndNumber!.frame.minX, y: nekoAndNumber!.frame.minY+1,
                                                          width: nekoAndNumber!.frame.width, height: nekoAndNumber!.frame.height)
                    }else{
                        direction = Int(arc4random()%8)
                    }
                }else if direction == 4{
                    if progress%100 <= 25{
                        let colorAndPose = "stand" + String(color)
                        imageView?.image = images[colorAndPose]
                    }else if progress%100 <= 50{
                        let colorAndPose = "walk1" + String(color)
                        imageView?.image = images[colorAndPose]
                    }else if progress%100 <= 75{
                        let colorAndPose = "stand" + String(color)
                        imageView?.image = images[colorAndPose]
                    }else{
                        let colorAndPose = "walk2" + String(color)
                        imageView?.image = images[colorAndPose]
                    }
                    var count = 0
                    if objectFrames["cardBoard"] != nil && isOverlapObject(objectFrames["cardBoard"]!, direction: 4){
                        count += 1
                    }
                    if objectFrames["tennisBall"] != nil && isOverlapObject(objectFrames["tennisBall"]!, direction: 4) && currentNum == Int(label!.text!){
                        move = 7
                        let frame = CGRect(x: objectFrames["tennisBall"]!.minX, y: objectFrames["tennisBall"]!.minY-catSize/1.5, width: catSize, height: catSize)
                        nekoAndNumber?.frame = frame
                        var colorAndPose = "ball" + String(color)
                        imageView?.image = images[colorAndPose]
                        subImageView = UIImageView(frame: imageView!.frame)
                        colorAndPose = "hand0" + String(color)
                        subImageView?.image = images[colorAndPose]
                        nekoAndNumber?.addSubview(subImageView!)
                    }
                    if objectFrames["baseball"] != nil && isOverlapObject(objectFrames["baseball"]!, direction: 4) && currentNum + 1 == Int(label!.text!){
                        move = 7
                        let frame = CGRect(x: objectFrames["baseball"]!.minX, y: objectFrames["baseball"]!.minY-catSize/1.5, width: catSize, height: catSize)
                        nekoAndNumber?.frame = frame
                        var colorAndPose = "ball" + String(color)
                        imageView?.image = images[colorAndPose]
                        subImageView = UIImageView(frame: imageView!.frame)
                        colorAndPose = "hand0" + String(color)
                        subImageView?.image = images[colorAndPose]
                        nekoAndNumber?.addSubview(subImageView!)
                    }
                    if nekoAndNumber!.frame.minX - 1 > leftEdge && nekoAndNumber!.frame.minY - 1 > topEdge &&  (count == 0 || objectFrames["cardBoard"] == nil){
                        nekoAndNumber!.frame = CGRect(x: nekoAndNumber!.frame.minX-1, y: nekoAndNumber!.frame.minY-1,
                                                          width: nekoAndNumber!.frame.width, height: nekoAndNumber!.frame.height)
                    }else{
                        direction = Int(arc4random()%8)
                    }
                }else if direction == 5{
                    if progress%100 <= 25{
                        let colorAndPose = "standr" + String(color)
                        imageView?.image = images[colorAndPose]
                    }else if progress%100 <= 50{
                        let colorAndPose = "walk1r" + String(color)
                        imageView?.image = images[colorAndPose]
                    }else if progress%100 <= 75{
                        let colorAndPose = "standr" + String(color)
                        imageView?.image = images[colorAndPose]
                    }else{
                        let colorAndPose = "walk2r" + String(color)
                        imageView?.image = images[colorAndPose]
                    }
                    var count = 0
                    if objectFrames["cardBoard"] != nil && isOverlapObject(objectFrames["cardBoard"]!, direction: 5){
                        count += 1
                    }
                    if objectFrames["tennisBall"] != nil && isOverlapObject(objectFrames["tennisBall"]!, direction: 5) && currentNum == Int(label!.text!){
                        move = 7
                        let frame = CGRect(x: objectFrames["tennisBall"]!.minX, y: objectFrames["tennisBall"]!.minY-catSize/1.5, width: catSize, height: catSize)
                        nekoAndNumber?.frame = frame
                        var colorAndPose = "ball" + String(color)
                        imageView?.image = images[colorAndPose]
                        subImageView = UIImageView(frame: imageView!.frame)
                        colorAndPose = "hand0" + String(color)
                        subImageView?.image = images[colorAndPose]
                        nekoAndNumber?.addSubview(subImageView!)
                    }
                    if objectFrames["baseball"] != nil && isOverlapObject(objectFrames["baseball"]!, direction: 5) && currentNum + 1 == Int(label!.text!){
                        move = 7
                        let frame = CGRect(x: objectFrames["baseball"]!.minX, y: objectFrames["baseball"]!.minY-catSize/1.5, width: catSize, height: catSize)
                        nekoAndNumber?.frame = frame
                        var colorAndPose = "ball" + String(color)
                        imageView?.image = images[colorAndPose]
                        subImageView = UIImageView(frame: imageView!.frame)
                        colorAndPose = "hand0" + String(color)
                        subImageView?.image = images[colorAndPose]
                        nekoAndNumber?.addSubview(subImageView!)
                    }
                    let x = nekoAndNumber!.frame.minX + catSize + 1
                    let y = nekoAndNumber!.frame.minY + catSize - 1
                    if y > topEdge && x < rightEdge && (count == 0 || objectFrames["cardBoard"] == nil){
                        nekoAndNumber!.frame = CGRect(x: nekoAndNumber!.frame.minX+1, y: nekoAndNumber!.frame.minY-1,
                                                          width: nekoAndNumber!.frame.width, height: nekoAndNumber!.frame.height)
                    }else{
                        direction = Int(arc4random()%8)
                    }
                }else if direction == 6{
                    if progress%100 <= 25{
                        let colorAndPose = "standr" + String(color)
                        imageView?.image = images[colorAndPose]
                    }else if progress%100 <= 50{
                        let colorAndPose = "walk1r" + String(color)
                        imageView?.image = images[colorAndPose]
                    }else if progress%100 <= 75{
                        let colorAndPose = "standr" + String(color)
                        imageView?.image = images[colorAndPose]
                    }else{
                        let colorAndPose = "walk2r" + String(color)
                        imageView?.image = images[colorAndPose]
                    }
                    var count = 0
                    if objectFrames["cardBoard"] != nil && isOverlapObject(objectFrames["cardBoard"]!, direction: 6){
                        count += 1
                    }
                    if objectFrames["tennisBall"] != nil && isOverlapObject(objectFrames["tennisBall"]!, direction: 6) && currentNum == Int(label!.text!){
                        move = 7
                        let frame = CGRect(x: objectFrames["tennisBall"]!.minX, y: objectFrames["tennisBall"]!.minY-catSize/1.5, width: catSize, height: catSize)
                        nekoAndNumber?.frame = frame
                        var colorAndPose = "ball" + String(color)
                        imageView?.image = images[colorAndPose]
                        subImageView = UIImageView(frame: imageView!.frame)
                        colorAndPose = "hand0" + String(color)
                        subImageView?.image = images[colorAndPose]
                        nekoAndNumber?.addSubview(subImageView!)
                    }
                    if objectFrames["baseball"] != nil && isOverlapObject(objectFrames["baseball"]!, direction: 6) && currentNum + 1 == Int(label!.text!){
                        move = 7
                        let frame = CGRect(x: objectFrames["baseball"]!.minX, y: objectFrames["baseball"]!.minY-catSize/1.5, width: catSize, height: catSize)
                        nekoAndNumber?.frame = frame
                        var colorAndPose = "ball" + String(color)
                        imageView?.image = images[colorAndPose]
                        subImageView = UIImageView(frame: imageView!.frame)
                        colorAndPose = "hand0" + String(color)
                        subImageView?.image = images[colorAndPose]
                        nekoAndNumber?.addSubview(subImageView!)
                    }
                    let x = nekoAndNumber!.frame.minX + catSize + 1
                    let y = nekoAndNumber!.frame.minY + catSize + 1
                    if x < rightEdge &&
                        y < bottomEdge && (count == 0 || objectFrames["cardBoard"] == nil){
                        nekoAndNumber!.frame = CGRect(x: nekoAndNumber!.frame.minX+1, y: nekoAndNumber!.frame.minY+1,
                                                          width: nekoAndNumber!.frame.width, height: nekoAndNumber!.frame.height)
                    }else{
                        direction = Int(arc4random()%8)
                    }
                }else if direction == 7{
                    if progress%100 <= 25{
                        let colorAndPose = "stand" + String(color)
                        imageView?.image = images[colorAndPose]
                    }else if progress%100 <= 50{
                        let colorAndPose = "walk1" + String(color)
                        imageView?.image = images[colorAndPose]
                    }else if progress%100 <= 75{
                        let colorAndPose = "stand" + String(color)
                        imageView?.image = images[colorAndPose]
                    }else{
                        let colorAndPose = "walk2" + String(color)
                        imageView?.image = images[colorAndPose]
                    }
                    var count = 0
                    if objectFrames["cardBoard"] != nil && isOverlapObject(objectFrames["cardBoard"]!, direction: 7){
                        count += 1
                    }
                    if objectFrames["tennisBall"] != nil && isOverlapObject(objectFrames["tennisBall"]!, direction: 7) && currentNum == Int(label!.text!){
                        move = 7
                        let frame = CGRect(x: objectFrames["tennisBall"]!.minX, y: objectFrames["tennisBall"]!.minY-catSize/1.5, width: catSize, height: catSize)
                        nekoAndNumber?.frame = frame
                        var colorAndPose = "ball" + String(color)
                        imageView?.image = images[colorAndPose]
                        subImageView = UIImageView(frame: imageView!.frame)
                        colorAndPose = "hand0" + String(color)
                        subImageView?.image = images[colorAndPose]
                        nekoAndNumber?.addSubview(subImageView!)
                    }
                    if objectFrames["baseball"] != nil && isOverlapObject(objectFrames["baseball"]!, direction: 7) && currentNum + 1 == Int(label!.text!){
                        move = 7
                        let frame = CGRect(x: objectFrames["baseball"]!.minX, y: objectFrames["baseball"]!.minY-catSize/1.5, width: catSize, height: catSize)
                        nekoAndNumber?.frame = frame
                        var colorAndPose = "ball" + String(color)
                        imageView?.image = images[colorAndPose]
                        subImageView = UIImageView(frame: imageView!.frame)
                        colorAndPose = "hand0" + String(color)
                        subImageView?.image = images[colorAndPose]
                        nekoAndNumber?.addSubview(subImageView!)
                    }
                    if nekoAndNumber!.frame.minX - 1 > leftEdge && nekoAndNumber!.frame.minY + catSize + 1 < bottomEdge && (count == 0 || objectFrames["cardBoard"] == nil){
                        nekoAndNumber!.frame = CGRect(x: nekoAndNumber!.frame.minX-1, y: nekoAndNumber!.frame.minY+1,
                                                          width: nekoAndNumber!.frame.width, height: nekoAndNumber!.frame.height)
                    }else{
                        direction = Int(arc4random()%8)
                    }
                }
                currentProgress = current
            }
        }else{
            let colorAndPose = "shitDown" + String(color)
            imageView?.image = images[colorAndPose]
            progress = 0
            patience = Int(arc4random()%500)
        }
        progress += 1
    }
    func ball(_ images:[String:UIImage]){
        if progress < 100{
            let current = progress / 16
            if current != currentProgress{
                if progress <= 16{
                    let colorAndPose = "hand1" + String(color)
                    subImageView?.image = images[colorAndPose]
                }else if progress <= 32{
                    let colorAndPose = "hand2" + String(color)
                    subImageView?.image = images[colorAndPose]
                }else if progress <= 48{
                    let colorAndPose = "hand3" + String(color)
                    subImageView?.image = images[colorAndPose]
                }else if progress <= 64{
                    let colorAndPose = "hand1" + String(color)
                    subImageView?.image = images[colorAndPose]
                }else if progress <= 80{
                    let colorAndPose = "hand2" + String(color)
                    subImageView?.image = images[colorAndPose]
                }else if progress <= 100{
                    let colorAndPose = "hand3" + String(color)
                    subImageView?.image = images[colorAndPose]
                }
                
                currentProgress = current
            }
        }else{
            let colorAndPose = "hand0" + String(color)
            subImageView?.image = images[colorAndPose]
            progress = 0
            patience = Int(arc4random()%2000)
        }
        progress += 1
    }
}
