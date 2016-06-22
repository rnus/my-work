//
//  ViewController.swift
//  NekoTest
//
//  Created by NU on 2016/06/07.
//  Copyright © 2016年 NaoyaUchisawa. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController ,UIScrollViewDelegate{
    @IBOutlet weak var scrollView: touchScrollView!
    let sS = UIScreen.mainScreen().bounds.size
    let space = UIScreen.mainScreen().bounds.size.width / 160
    var catNum = 25
    var time:UILabel? = nil
    var startTime:Double? = nil
    var cats:[Neko] = []
    var randNumbers:[Int]?
    var current = 1
    var timer:NSTimer?
    var first = true
    var stopFlag = false
    var images: [String:UIImage] = [:]
    var audioPlayer:AVAudioPlayer? = nil
    var sePlayer:AVAudioPlayer? = nil
    var difficulty = 0
    var leftEdge:CGFloat? = nil
    var topEdge:CGFloat? = nil
    var rightEdge:CGFloat? = nil
    var bottomEdge:CGFloat? = nil
    var countTimerFlag = false
    var scale: CGFloat = 1.0
    var catSize:CGFloat = 100
    func start(){
        current = 1
        for l in cats{
            l.label!.removeFromSuperview()
            l.imageView!.removeFromSuperview()
            l.nekoAndNumber!.removeFromSuperview()
            if l.item1 != nil{
                l.item1 = nil
            }
            if l.item2 != nil{
                l.item2 = nil
            }
            if l.itemAndNeko != nil{
                l.itemAndNeko = nil
            }
        }
        cats.removeAll()
        randNumbers = getRandArray(catNum)
        makeLabels()
        startTime = NSDate().timeIntervalSince1970
        countTimerFlag = true
        if timer != nil{
            timer?.invalidate()
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: #selector(GameViewController.timerUpdate), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
    }
    func stop(){
        if timer != nil{
            timer?.invalidate()
            stopFlag = true
        }
    }
    func resume(){
        stopFlag = false
        timer = NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: #selector(GameViewController.timerUpdate), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if first{
            first = false
        }
        let point = touches.first?.locationInView(scrollView)
        match:for l in cats{
            if l.label!.text == String(current) && !stopFlag && l.nekoAndNumber!.frame.minX+(catSize/10)*2.7 <= point?.x && l.nekoAndNumber!.frame.maxX-(catSize/10)*2.7 >= point?.x && l.nekoAndNumber!.frame.minY+(catSize/10)*2.7 <= point?.y && l.nekoAndNumber!.frame.maxY-(catSize/10)*2.7 >= point?.y{
                current += 1
                l.catchFlag = true
                l.move = 5
                l.progress = 0
                l.patience = 0
                let str = "cat" + String(arc4random()%4+1)
                sePlayer = prepareSound(str, type: "mp3")
                sePlayer?.play()
                if l.label!.text == String(cats.count){
                    countTimerFlag = false
                }
                break match
            }
        }
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchesBegan(touches, withEvent: event)
    }
    func makeButtons(){
        let frame = CGRectMake(sS.width/3*2+space, sS.height-sS.height/20+space-20, sS.width/3-space-space*2, sS.height/20-space*2)
        let start = UIButton(frame: frame)
        start.backgroundColor = UIColor.init(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
        start.setTitle("START", forState: .Normal)
        start.addTarget(self, action: #selector(GameViewController.start), forControlEvents: .TouchUpInside)
        view.addSubview(start)
        let frame2 = CGRectMake(sS.width/3*2+space, sS.height-sS.height/20*2+space-20, sS.width/3-space-space*2, sS.height/20-space*2)
        let stop = UIButton(frame: frame2)
        stop.backgroundColor = UIColor.init(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
        stop.setTitle("STOP", forState: .Normal)
        stop.addTarget(self, action: #selector(GameViewController.stop), forControlEvents: .TouchUpInside)
        view.addSubview(stop)
        let frame3 = CGRectMake(sS.width/3*2+space, sS.height-sS.height/20*3+space-20, sS.width/3-space-space*2, sS.height/20-space*2)
        let resume = UIButton(frame: frame3)
        resume.backgroundColor = UIColor.init(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
        resume.setTitle("RESUME", forState: .Normal)
        resume.addTarget(self, action: #selector(GameViewController.resume), forControlEvents: .TouchUpInside)
        view.addSubview(resume)
        let frame4 = CGRectMake(sS.width/3*2+space, sS.height-sS.height/20*4+space-20, sS.width/3-space-space*2, sS.height/20-space*2)
        time = UILabel(frame: frame4)
        time?.font = UIFont.monospacedDigitSystemFontOfSize(time!.font.pointSize, weight: 0.1)
        time?.textAlignment = .Center
        time!.textColor = UIColor.init(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
        time!.text = "0.000"
        view.addSubview(time!)
    }
    func makeLabels(){
        for i in 0..<catNum{
            var frame:CGRect? = nil
            if difficulty == 0{
                let xx = rightEdge! - catSize
                let yy = sS.height - topEdge! - catSize
                var x = CGFloat(arc4random()%UInt32(xx))
                var y = sS.height/10*3.6 + CGFloat(arc4random()%UInt32(yy))
                for j in cats{
                    while x > j.nekoAndNumber!.frame.minX-catSize*0.5 && x < j.nekoAndNumber!.frame.maxX+catSize*0.5 && y > j.nekoAndNumber!.frame.minY-catSize*0.5 && y < j.nekoAndNumber!.frame.maxY+catSize*0.5{
                        x = CGFloat(arc4random()%UInt32(xx))
                        y = sS.height/10*3.6 + CGFloat(arc4random()%UInt32(yy))
                    }
                }
                frame = CGRectMake(x,y,catSize, catSize)
            }else if difficulty == 1{
                let xx = rightEdge! - catSize
                let yy = sS.height - topEdge! - catSize
                let x = CGFloat(arc4random()%UInt32(xx))
                let y = sS.height/10*3.6 + CGFloat(arc4random()%UInt32(yy))
                frame = CGRectMake(x,y,catSize, catSize)
            }else if difficulty == 2{
                if i == 0{
                    frame = CGRectMake(sS.width*2+sS.width/18*7,sS.height/10*4 ,catSize, catSize)
                }else if i == 1{
                    frame = CGRectMake(sS.width*2+sS.width/18*4,sS.height/10*5.3 ,catSize, catSize)
                }else if i == 2{
                    frame = CGRectMake(sS.width*2+sS.width/18*7.5,sS.height/10*6.5 ,catSize, catSize)
                }else if i == 3{
                    frame = CGRectMake(sS.width/2,sS.height/10*2 ,catSize, catSize)
                }else if i == 4{
                    frame = CGRectMake(sS.width/2,sS.height/10*4 ,catSize, catSize)
                }else if i == 5{
                    frame = CGRectMake(sS.width/2,sS.height/10*0.2 ,catSize, catSize)
                }else if i == 6{
                    frame = CGRectMake(sS.width + sS.width/10*6.7,sS.height/10*7 ,catSize, catSize)
                }else if i == 7{
                    frame = CGRectMake(sS.width/10*8.6,sS.height/10*2.8 ,catSize, catSize)
                }else if i == 8{
                    frame = CGRectMake(sS.width+sS.width/10*8.5,sS.height/10*2.8 ,catSize, catSize)
                }else if i == 9{
                    frame = CGRectMake(sS.width,sS.height/10*3.5 ,catSize, catSize)
                }else if i == 10{
                    frame = CGRectMake(sS.width+sS.width/10*3,sS.height/10*3.6 ,catSize, catSize)
                }else if i == 11{
                    frame = CGRectMake(sS.width+sS.width/10*2,sS.height/10*4.5 ,catSize, catSize)
                }else if i == 12{
                    frame = CGRectMake(sS.width/10*8,sS.height/10*6.5 ,catSize, catSize)
                }else if i == 13{
                    frame = CGRectMake(sS.width/2,sS.height/10*5.3 ,catSize, catSize)
                }else if i >= 14{
                    let xx = rightEdge! - catSize
                    let yy = sS.height - topEdge! - catSize
                    let x = CGFloat(arc4random()%UInt32(xx))
                    let y = sS.height/10*3.6 + CGFloat(arc4random()%UInt32(yy))
                    frame = CGRectMake(x,y,catSize, catSize)
                }
            }
            let label:ExtendedLabel = ExtendedLabel(frame: frame!)
            label.textColor = UIColor.darkGrayColor()
            label.font = UIFont(name: "Helvetica", size: 24)
            label.outLineColor = UIColor.whiteColor()
            label.outLineWidth = 1.0
            label.backgroundColor = UIColor.init(white: 1.0, alpha: 0.0)
            label.text = String(randNumbers![i])
            label.textAlignment = .Center
            var color: Int = 0
            if randNumbers![i]%5 == 1{
                color = 0
            }else if randNumbers![i]%5 == 2{
                color = 1
            }else if randNumbers![i]%5 == 3{
                color = 2
            }else if randNumbers![i]%5 == 4{
                color = 3
            }else if randNumbers![i]%5 == 0{
                color = 4
            }
            var neko:Neko?
            if difficulty == 0{
                if randNumbers![i] == 1{
                    neko = Neko(move: 6,label: label,color: color)
                }else if randNumbers![i] == 2{
                    neko = Neko(move: 2,label: label,color: color)
                }else if randNumbers![i] == 3{
                    neko = Neko(move: 6,label: label,color: color)
                }else if randNumbers![i] == 4{
                    neko = Neko(move: 2,label: label,color: color)
                }else if randNumbers![i] == 5{
                    neko = Neko(move: 6,label: label,color: color)
                }else if randNumbers![i] == 6{
                    neko = Neko(move: 5,label: label,color: color)
                }else if randNumbers![i] == 7{
                    neko = Neko(move: 0,label: label,color: color)
                }else if randNumbers![i] == 8{
                    neko = Neko(move: 1,label: label,color: color)
                }else if randNumbers![i] == 9{
                    neko = Neko(move: 1,label: label,color: color)
                }else if randNumbers![i] == 10{
                    neko = Neko(move: 5,label: label,color: color)
                }
            }else if difficulty == 1{
                neko = Neko(move: Int(arc4random()%7),label: label,color: color)
            }else if difficulty == 2{
                if i == 1{
                    neko = Neko(move: 1,label: label,color: color)
                }else if i == 2{
                    neko = Neko(move: 100,label: label,color: color)
                }else if i < 7{
                    neko = Neko(move: 5,label: label,color: color)
                }else if i == 7 || i == 8{
                    neko = Neko(move: 3,label: label,color: color)
                }else if i == 9 || i == 10{
                    neko = Neko(move: 0,label: label,color: color)
                }else if i == 11{
                    neko = Neko(move: 1,label: label,color: color)
                }else if i == 12{
                    neko = Neko(move: 5,label: label,color: color)
                }else if i == 13{
                    neko = Neko(move: 2,label: label,color: color)
                }else if i >= 14{
                    neko = Neko(move: 6,label: label,color: color)
                }
            }
            cats.append(neko!)
            if neko?.itemAndNeko != nil{
                scrollView.addSubview(neko!.itemAndNeko!)
            }else{
                scrollView.addSubview(neko!.nekoAndNumber!)
            }
        }
    }
    func getRandArray(num:Int)->[Int]{
        var numbers:[Int] = []
        numbers.append(Int(arc4random()%UInt32(num))+1)
        for _ in 0..<num-1{
            match:while true{
                var rand = Int(arc4random()%UInt32(num)+1)
                var counter = 0
                for j in numbers{
                    if j == rand{
                        while j == rand{
                            rand = Int(arc4random()%UInt32(num)+1)
                        }
                        
                    }else{
                        counter += 1
                    }
                    if counter == numbers.count{
                        numbers.append(rand)
                        break match
                    }
                }
            }
        }
        return numbers
    }
    func moveCats(){
        for i in cats{
            if i.patience == 0{
                if i.move == 0{
                    if i.progress <= 500{
                        let current = i.progress / 10
                        if current != i.currentProgress{
                            if i.nekoAndNumber!.frame.minX + 1 < scrollView.contentSize.width{
                                if i.progress%100 <= 25{
                                    let colorAndPose = "standr" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else if i.progress%100 <= 50{
                                    let colorAndPose = "walk1r" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else if i.progress%100 <= 75{
                                    let colorAndPose = "standr" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else{
                                    let colorAndPose = "walk2r" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }
                                i.nekoAndNumber!.frame = CGRectMake(i.nekoAndNumber!.frame.minX+1, i.nekoAndNumber!.frame.minY,
                                                                    i.nekoAndNumber!.frame.width, i.nekoAndNumber!.frame.height)
                            }
                            i.currentProgress = current
                        }
                    }else{
                        let colorAndPose = "shitDown" + String(i.color)
                        i.imageView?.image = images[colorAndPose]
                        i.move = 1
                        i.progress = 0
                        i.patience = Int(arc4random()%500)
                    }
                    i.progress += 1
                }else if i.move == 1{
                    if i.progress <= 500{
                        let current = i.progress / 10
                        if current != i.currentProgress{
                            if i.nekoAndNumber!.frame.minX >= 0{
                                if i.progress%100 <= 25{
                                    let colorAndPose = "stand" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else if i.progress%100 <= 50{
                                    let colorAndPose = "walk1" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else if i.progress%100 <= 75{
                                    let colorAndPose = "stand" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else{
                                    let colorAndPose = "walk2" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }
                                i.nekoAndNumber!.frame = CGRectMake(i.nekoAndNumber!.frame.minX-1, i.nekoAndNumber!.frame.minY,
                                                                    i.nekoAndNumber!.frame.width, i.nekoAndNumber!.frame.height)
                            }
                            i.currentProgress = current
                        }
                    }else{
                        let colorAndPose = "shitDown" + String(i.color)
                        i.imageView?.image = images[colorAndPose]
                        i.move = 0
                        i.progress = 0
                        i.patience = Int(arc4random()%500)
                    }
                    i.progress += 1
                }else if i.move == 2{
                    if i.progress < 200{
                        let current = i.progress / 10
                        if current != i.currentProgress{
                            if i.progress <= 20{
                                let colorAndPose = "run0" + String(i.color)
                                i.imageView?.image = images[colorAndPose]
                            }else if i.progress <= 40{
                                let colorAndPose = "run1" + String(i.color)
                                i.imageView?.image = images[colorAndPose]
                            }else if i.progress <= 60{
                                let colorAndPose = "run2" + String(i.color)
                                i.imageView?.image = images[colorAndPose]
                            }else if i.progress <= 80{
                                let colorAndPose = "run1" + String(i.color)
                                i.imageView?.image = images[colorAndPose]
                            }else if i.progress <= 100{
                                let colorAndPose = "run0" + String(i.color)
                                i.imageView?.image = images[colorAndPose]
                            }else if i.progress <= 120{
                                let colorAndPose = "run0r" + String(i.color)
                                i.imageView?.image = images[colorAndPose]
                            }else if i.progress <= 140{
                                let colorAndPose = "run1r" + String(i.color)
                                i.imageView?.image = images[colorAndPose]
                            }else if i.progress <= 160{
                                let colorAndPose = "run2r" + String(i.color)
                                i.imageView?.image = images[colorAndPose]
                            }else if i.progress <= 180{
                                let colorAndPose = "run1r" + String(i.color)
                                i.imageView?.image = images[colorAndPose]
                            }else{
                                let colorAndPose = "run0r" + String(i.color)
                                i.imageView?.image = images[colorAndPose]
                            }
                            let rad = (Double(i.progress) + 0.01) * (360.0 / Double(200))
                            let labelX = CGFloat(12 * cos(M_PI / 180 * rad))
                            let labelY = CGFloat(12 * sin(M_PI / 180 * rad))
                            i.nekoAndNumber!.frame = CGRectMake(i.nekoAndNumber!.frame.minX + labelX, i.nekoAndNumber!.frame.minY+labelY,
                                                                i.nekoAndNumber!.frame.width, i.nekoAndNumber!.frame.height)
                            
                            i.currentProgress = current
                        }
                    }else{
                        let colorAndPose = "shitDown" + String(i.color)
                        i.imageView?.image = images[colorAndPose]
                        i.progress = 0
                        i.patience = Int(arc4random()%500)
                    }
                    i.progress += 1
                }else if i.move == 3{
                    if i.progress < 500{
                        let current = i.progress / 10
                        if current != i.currentProgress{
                            if i.nekoAndNumber!.frame.minY - 1 > 0{
                                if i.progress < 125{
                                    let colorAndPose = "climb0" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else if i.progress < 250{
                                    let colorAndPose = "climb1" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else if i.progress < 375{
                                    let colorAndPose = "climb0" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else{
                                    let colorAndPose = "climb2" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }
                                i.nekoAndNumber!.frame = CGRectMake(i.nekoAndNumber!.frame.minX, i.nekoAndNumber!.frame.minY-1,
                                                                    i.nekoAndNumber!.frame.width, i.nekoAndNumber!.frame.height)
                            }
                            i.currentProgress = current
                        }
                    }else{
                        let colorAndPose = "climb0" + String(i.color)
                        i.imageView?.image = images[colorAndPose]
                        i.move = 4
                        i.progress = 0
                        i.patience = Int(arc4random()%1000)
                    }
                    i.progress += 1
                }else if i.move == 4{
                    if i.progress < 100{
                        let current = i.progress / 10
                        if current != i.currentProgress{
                            if i.nekoAndNumber!.frame.minY + 5 < scrollView.contentSize.height{
                                let colorAndPose = "climb0" + String(i.color)
                                i.imageView?.image = images[colorAndPose]
                                i.nekoAndNumber!.frame = CGRectMake(i.nekoAndNumber!.frame.minX, i.nekoAndNumber!.frame.minY + 5,
                                                                    i.nekoAndNumber!.frame.width, i.nekoAndNumber!.frame.height)
                            }
                            i.currentProgress = current
                        }
                    }else{
                        i.move = 3
                        i.progress = 0
                        i.patience = Int(arc4random()%1000)
                    }
                    i.progress += 1
                }else if i.move == 5{
                    if i.progress < 100{
                        let current = i.progress / 16
                        if current != i.currentProgress{
                            if i.progress <= 16{
                                let colorAndPose = "tail2" + String(i.color)
                                i.subImageView?.image = images[colorAndPose]
                            }else if i.progress <= 32{
                                let colorAndPose = "tail3" + String(i.color)
                                i.subImageView?.image = images[colorAndPose]
                            }else if i.progress <= 48{
                                let colorAndPose = "tail4" + String(i.color)
                                i.subImageView?.image = images[colorAndPose]
                            }else if i.progress <= 64{
                                let colorAndPose = "tail3" + String(i.color)
                                i.subImageView?.image = images[colorAndPose]
                            }else if i.progress <= 80{
                                let colorAndPose = "tail2" + String(i.color)
                                i.subImageView?.image = images[colorAndPose]
                            }else if i.progress <= 100{
                                let colorAndPose = "tail1" + String(i.color)
                                i.subImageView?.image = images[colorAndPose]
                            }
                            
                            i.currentProgress = current
                        }
                    }else{
                        let colorAndPose = "tail1" + String(i.color)
                        i.subImageView?.image = images[colorAndPose]
                        i.progress = 0
                        i.patience = Int(arc4random()%2000)
                    }
                    i.progress += 1
                }else if i.move == 6{
                    if i.progress < 2000{
                        let current = i.progress / 10
                        if current != i.currentProgress{
                            if i.currentProgress%10 == 1{
                                i.direction = Int(arc4random()%8)
                            }
                            if i.direction == 0{
                                if i.progress%100 <= 25{
                                    let colorAndPose = "stand" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else if i.progress%100 <= 50{
                                    let colorAndPose = "walk1" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else if i.progress%100 <= 75{
                                    let colorAndPose = "stand" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else{
                                    let colorAndPose = "walk2" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }
                                if i.nekoAndNumber!.frame.minX - 5 > leftEdge{
                                    i.nekoAndNumber!.frame = CGRectMake(i.nekoAndNumber!.frame.minX-5, i.nekoAndNumber!.frame.minY,
                                                                        i.nekoAndNumber!.frame.width, i.nekoAndNumber!.frame.height)
                                }else{
                                    i.direction = Int(arc4random()%8)
                                }
                            }else if i.direction == 1{
                                if i.progress%100 <= 25{
                                    let colorAndPose = "stand" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else if i.progress%100 <= 50{
                                    let colorAndPose = "walk1" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else if i.progress%100 <= 75{
                                    let colorAndPose = "stand" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else{
                                    let colorAndPose = "walk2" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }
                                if i.nekoAndNumber!.frame.minY - 5 > topEdge{
                                    i.nekoAndNumber!.frame = CGRectMake(i.nekoAndNumber!.frame.minX, i.nekoAndNumber!.frame.minY-5,
                                                                        i.nekoAndNumber!.frame.width, i.nekoAndNumber!.frame.height)
                                }else{
                                    i.direction = Int(arc4random()%8)
                                }
                            }else if i.direction == 2{
                                if i.progress%100 <= 25{
                                    let colorAndPose = "standr" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else if i.progress%100 <= 50{
                                    let colorAndPose = "walk1r" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else if i.progress%100 <= 75{
                                    let colorAndPose = "standr" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else{
                                    let colorAndPose = "walk2r" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }
                                if i.nekoAndNumber!.frame.minX + catSize + 5 < rightEdge{
                                    i.nekoAndNumber!.frame = CGRectMake(i.nekoAndNumber!.frame.minX+5, i.nekoAndNumber!.frame.minY,
                                                                        i.nekoAndNumber!.frame.width, i.nekoAndNumber!.frame.height)
                                }else{
                                    i.direction = Int(arc4random()%8)
                                }
                            }else if i.direction == 3{
                                if i.progress%100 <= 25{
                                    let colorAndPose = "standr" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else if i.progress%100 <= 50{
                                    let colorAndPose = "walk1r" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else if i.progress%100 <= 75{
                                    let colorAndPose = "standr" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else{
                                    let colorAndPose = "walk2r" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }
                                if i.nekoAndNumber!.frame.minY + catSize + 5 < bottomEdge{
                                    i.nekoAndNumber!.frame = CGRectMake(i.nekoAndNumber!.frame.minX, i.nekoAndNumber!.frame.minY+5,
                                                                        i.nekoAndNumber!.frame.width, i.nekoAndNumber!.frame.height)
                                }else{
                                    i.direction = Int(arc4random()%8)
                                }
                            }else if i.direction == 4{
                                if i.progress%100 <= 25{
                                    let colorAndPose = "stand" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else if i.progress%100 <= 50{
                                    let colorAndPose = "walk1" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else if i.progress%100 <= 75{
                                    let colorAndPose = "stand" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else{
                                    let colorAndPose = "walk2" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }
                                if i.nekoAndNumber!.frame.minX - 5 > leftEdge && i.nekoAndNumber!.frame.minY - 5 > topEdge{
                                    i.nekoAndNumber!.frame = CGRectMake(i.nekoAndNumber!.frame.minX-5, i.nekoAndNumber!.frame.minY-5,
                                                                        i.nekoAndNumber!.frame.width, i.nekoAndNumber!.frame.height)
                                }else{
                                    i.direction = Int(arc4random()%8)
                                }
                            }else if i.direction == 5{
                                if i.progress%100 <= 25{
                                    let colorAndPose = "standr" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else if i.progress%100 <= 50{
                                    let colorAndPose = "walk1r" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else if i.progress%100 <= 75{
                                    let colorAndPose = "standr" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else{
                                    let colorAndPose = "walk2r" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }
                                let x = i.nekoAndNumber!.frame.minX + catSize + 5
                                let y = i.nekoAndNumber!.frame.minY + catSize - 5
                                if y > topEdge && x < rightEdge{
                                    i.nekoAndNumber!.frame = CGRectMake(i.nekoAndNumber!.frame.minX+5, i.nekoAndNumber!.frame.minY-5,
                                                                        i.nekoAndNumber!.frame.width, i.nekoAndNumber!.frame.height)
                                }else{
                                    i.direction = Int(arc4random()%8)
                                }
                            }else if i.direction == 6{
                                if i.progress%100 <= 25{
                                    let colorAndPose = "standr" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else if i.progress%100 <= 50{
                                    let colorAndPose = "walk1r" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else if i.progress%100 <= 75{
                                    let colorAndPose = "standr" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else{
                                    let colorAndPose = "walk2r" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }
                                let x = i.nekoAndNumber!.frame.minX + catSize + 5
                                let y = i.nekoAndNumber!.frame.minY + catSize + 5
                                if x < rightEdge &&
                                    y < bottomEdge{
                                    i.nekoAndNumber!.frame = CGRectMake(i.nekoAndNumber!.frame.minX+5, i.nekoAndNumber!.frame.minY+5,
                                                                        i.nekoAndNumber!.frame.width, i.nekoAndNumber!.frame.height)
                                }else{
                                    i.direction = Int(arc4random()%8)
                                }
                            }else if i.direction == 7{
                                if i.progress%100 <= 25{
                                    let colorAndPose = "stand" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else if i.progress%100 <= 50{
                                    let colorAndPose = "walk1" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else if i.progress%100 <= 75{
                                    let colorAndPose = "stand" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }else{
                                    let colorAndPose = "walk2" + String(i.color)
                                    i.imageView?.image = images[colorAndPose]
                                }
                                if i.nekoAndNumber!.frame.minX - 5 > leftEdge && i.nekoAndNumber!.frame.minY + catSize + 5 < bottomEdge{
                                    i.nekoAndNumber!.frame = CGRectMake(i.nekoAndNumber!.frame.minX-5, i.nekoAndNumber!.frame.minY+5,
                                                                        i.nekoAndNumber!.frame.width, i.nekoAndNumber!.frame.height)
                                }else{
                                    i.direction = Int(arc4random()%8)
                                }
                            }
                            i.currentProgress = current
                        }
                    }else{
                        let colorAndPose = "shitDown" + String(i.color)
                        i.imageView?.image = images[colorAndPose]
                        i.progress = 0
                        i.patience = Int(arc4random()%500)
                    }
                    i.progress += 1
                }
            }
            if i.patience != 0{
                i.patience -= 1
            }
        }
    }
    func catchCat(){
        for i in cats{
            if i.catchFlag{
                if i.first{
                    i.first = false
                    i.nekoAndNumber?.removeFromSuperview()
                    view.addSubview(i.nekoAndNumber!)
                    i.nekoAndNumber?.frame = CGRectMake(i.nekoAndNumber!.frame.minX - scrollView.contentOffset.x, i.nekoAndNumber!.frame.minY, catSize, catSize)
                    i.px1 = i.nekoAndNumber!.frame.minX
                    i.py1 = i.nekoAndNumber!.frame.minY + 20
                    if i.nekoAndNumber!.frame.minX+50 > sS.width/2{
                        i.px2 = sS.width/4
                    }else{
                        i.px2 = sS.width/4*3
                    }
                    i.py2 = i.nekoAndNumber!.frame.minY + (sS.height - i.nekoAndNumber!.frame.minY)/2 - catSize
                }
                let p_x1 = CGFloat((1-i.catchProgress)*(1-i.catchProgress))*i.px1
                let p_x2 = CGFloat(2*(1-i.catchProgress)*i.catchProgress)*i.px2
                let p_x3 = CGFloat(i.catchProgress*i.catchProgress)*sS.width/2
                let p_x = p_x1 + p_x2 + p_x3
                let p_y1 = CGFloat((1-i.catchProgress)*(1-i.catchProgress))*i.py1
                let p_y2 = CGFloat(2*(1-i.catchProgress)*i.catchProgress)*i.py2
                let p_y3 = CGFloat(i.catchProgress*i.catchProgress)*(sS.height-50)
                let p_y = p_y1 + p_y2 + p_y3
                let frame = CGRectMake(p_x, p_y, catSize, catSize)
                i.nekoAndNumber?.frame = frame
                i.catchProgress += 0.005 + i.catchProgress*0.009
            }
            if i.catchProgress >= 1{
                i.catchFlag = false
                i.nekoAndNumber?.hidden = true
            }
        }
    }
    
    func timerUpdate(){
        if countTimerFlag{
            let current = NSDate().timeIntervalSince1970
            time?.text = String(format: "%.03f", current - startTime!)
        }
        moveCats()
        catchCat()
    }
    override func viewWillDisappear(animated: Bool) {
        if timer != nil{
            timer?.invalidate()
        }
    }
    
    func loadWallImage(){
        var wallPaper = UIImage(named: "room1.png")
        let resizedSize = CGSize(width: sS.width*3, height: sS.height)
        UIGraphicsBeginImageContext(resizedSize)
        wallPaper!.drawInRect(CGRectMake(0, 0, resizedSize.width, resizedSize.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        wallPaper! = resizeImage
        print(wallPaper!.size)
        print(scrollView.contentSize)
        if difficulty == 0 {
            let cropRect = CGRectMake(wallPaper!.size.width/3, 0, wallPaper!.size.width/3, wallPaper!.size.height)
            let cropRef = CGImageCreateWithImageInRect(wallPaper!.CGImage, cropRect)
            wallPaper = UIImage(CGImage: cropRef!)
        }else if difficulty == 1{
            if difficulty == 0 {
                let cropRect = CGRectMake(0, 0, wallPaper!.size.width/3*2, wallPaper!.size.height)
                let cropRef = CGImageCreateWithImageInRect(wallPaper!.CGImage, cropRect)
                wallPaper = UIImage(CGImage: cropRef!)
            }
        }
        let wpView = UIImageView(image: wallPaper)
        wpView.frame = CGRectMake(0, 0, wallPaper!.size.width, wallPaper!.size.height)
        scrollView.addSubview(wpView)
        scrollView.sendSubviewToBack(wpView)
        images["shitDown0"] = UIImage(named: "shitDown0.png")!
        images["shitDown1"] = UIImage(named: "shitDown1.png")!
        images["shitDown2"] = UIImage(named: "shitDown2.png")!
        images["shitDown3"] = UIImage(named: "shitDown3.png")!
        images["shitDown4"] = UIImage(named: "shitDown4.png")!
        images["walk10"] = UIImage(named: "walk10.png")!
        images["walk20"] = UIImage(named: "walk20.png")!
        images["walk1r0"] = UIImage(named: "walk1r0.png")!
        images["walk2r0"] = UIImage(named: "walk2r0.png")!
        images["walk11"] = UIImage(named: "walk11.png")!
        images["walk21"] = UIImage(named: "walk21.png")!
        images["walk1r1"] = UIImage(named: "walk1r1.png")!
        images["walk2r1"] = UIImage(named: "walk2r1.png")!
        images["walk12"] = UIImage(named: "walk12.png")!
        images["walk22"] = UIImage(named: "walk22.png")!
        images["walk1r2"] = UIImage(named: "walk1r2.png")!
        images["walk2r2"] = UIImage(named: "walk2r2.png")!
        images["walk13"] = UIImage(named: "walk13.png")!
        images["walk23"] = UIImage(named: "walk23.png")!
        images["walk1r3"] = UIImage(named: "walk1r3.png")!
        images["walk2r3"] = UIImage(named: "walk2r3.png")!
        images["walk14"] = UIImage(named: "walk14.png")!
        images["walk24"] = UIImage(named: "walk24.png")!
        images["walk1r4"] = UIImage(named: "walk1r4.png")!
        images["walk2r4"] = UIImage(named: "walk2r4.png")!
        images["stand0"] = UIImage(named: "stand0.png")!
        images["standr0"] = UIImage(named: "standr0.png")!
        images["stand1"] = UIImage(named: "stand1.png")!
        images["standr1"] = UIImage(named: "standr1.png")!
        images["stand2"] = UIImage(named: "stand2.png")!
        images["standr2"] = UIImage(named: "standr2.png")!
        images["stand3"] = UIImage(named: "stand3.png")!
        images["standr3"] = UIImage(named: "standr3.png")!
        images["stand4"] = UIImage(named: "stand4.png")!
        images["standr4"] = UIImage(named: "standr4.png")!
        images["run00"] = UIImage(named: "run00.png")!
        images["run10"] = UIImage(named: "run10.png")!
        images["run20"] = UIImage(named: "run20.png")!
        images["run0r0"] = UIImage(named: "run0r0.png")!
        images["run1r0"] = UIImage(named: "run1r0.png")!
        images["run2r0"] = UIImage(named: "run2r0.png")!
        images["run01"] = UIImage(named: "run01.png")!
        images["run11"] = UIImage(named: "run11.png")!
        images["run21"] = UIImage(named: "run21.png")!
        images["run0r1"] = UIImage(named: "run0r1.png")!
        images["run1r1"] = UIImage(named: "run1r1.png")!
        images["run2r1"] = UIImage(named: "run2r1.png")!
        images["run02"] = UIImage(named: "run02.png")!
        images["run12"] = UIImage(named: "run12.png")!
        images["run22"] = UIImage(named: "run22.png")!
        images["run0r2"] = UIImage(named: "run0r2.png")!
        images["run1r2"] = UIImage(named: "run1r2.png")!
        images["run2r2"] = UIImage(named: "run2r2.png")!
        images["run03"] = UIImage(named: "run03.png")!
        images["run13"] = UIImage(named: "run13.png")!
        images["run23"] = UIImage(named: "run23.png")!
        images["run0r3"] = UIImage(named: "run0r3.png")!
        images["run1r3"] = UIImage(named: "run1r3.png")!
        images["run2r3"] = UIImage(named: "run2r3.png")!
        images["run04"] = UIImage(named: "run04.png")!
        images["run14"] = UIImage(named: "run14.png")!
        images["run24"] = UIImage(named: "run24.png")!
        images["run0r4"] = UIImage(named: "run0r4.png")!
        images["run1r4"] = UIImage(named: "run1r4.png")!
        images["run2r4"] = UIImage(named: "run2r4.png")!
        images["climb00"] = UIImage(named: "climb00.png")!
        images["climb01"] = UIImage(named: "climb01.png")!
        images["climb02"] = UIImage(named: "climb02.png")!
        images["climb03"] = UIImage(named: "climb03.png")!
        images["climb04"] = UIImage(named: "climb04.png")!
        images["climb00"] = UIImage(named: "climb00.png")!
        images["climb10"] = UIImage(named: "climb10.png")!
        images["climb11"] = UIImage(named: "climb11.png")!
        images["climb12"] = UIImage(named: "climb12.png")!
        images["climb13"] = UIImage(named: "climb13.png")!
        images["climb14"] = UIImage(named: "climb14.png")!
        images["climb20"] = UIImage(named: "climb20.png")!
        images["climb21"] = UIImage(named: "climb21.png")!
        images["climb22"] = UIImage(named: "climb22.png")!
        images["climb23"] = UIImage(named: "climb23.png")!
        images["climb24"] = UIImage(named: "climb24.png")!
        images["lie00"] = UIImage(named: "lie00.png")!
        images["tail10"] = UIImage(named: "tail10.png")!
        images["tail20"] = UIImage(named: "tail20.png")!
        images["tail30"] = UIImage(named: "tail30.png")!
        images["tail40"] = UIImage(named: "tail40.png")!
        images["lie01"] = UIImage(named: "lie01.png")!
        images["tail11"] = UIImage(named: "tail11.png")!
        images["tail21"] = UIImage(named: "tail21.png")!
        images["tail31"] = UIImage(named: "tail31.png")!
        images["tail41"] = UIImage(named: "tail41.png")!
        images["lie02"] = UIImage(named: "lie02.png")!
        images["tail12"] = UIImage(named: "tail12.png")!
        images["tail22"] = UIImage(named: "tail22.png")!
        images["tail32"] = UIImage(named: "tail32.png")!
        images["tail42"] = UIImage(named: "tail42.png")!
        images["lie03"] = UIImage(named: "lie03.png")!
        images["tail13"] = UIImage(named: "tail13.png")!
        images["tail23"] = UIImage(named: "tail23.png")!
        images["tail33"] = UIImage(named: "tail33.png")!
        images["tail43"] = UIImage(named: "tail43.png")!
        images["lie04"] = UIImage(named: "lie04.png")!
        images["tail14"] = UIImage(named: "tail14.png")!
        images["tail24"] = UIImage(named: "tail24.png")!
        images["tail34"] = UIImage(named: "tail34.png")!
        images["tail44"] = UIImage(named: "tail44.png")!
        
    }
    func rightTopInfomation(){
        let numberLast = UIView(frame: CGRectMake(sS.width/4*3,0,sS.width/4,sS.height/3))
        let white = UIImageView(frame: CGRectMake(0,40,catSize/3,catSize/3))
        let black = UIImageView(frame: CGRectMake(0,80,catSize/3,catSize/3))
        let brown = UIImageView(frame: CGRectMake(0,120,catSize/3,catSize/3))
        let silver = UIImageView(frame: CGRectMake(0,160,catSize/3,catSize/3))
        let three = UIImageView(frame: CGRectMake(0,200,catSize/3,catSize/3))
        let whiteLabel = UILabel(frame: CGRectMake(40,40,catSize/3,catSize/3))
        let blackLabel = UILabel(frame: CGRectMake(40,80,catSize/3,catSize/3))
        let brownLabel = UILabel(frame: CGRectMake(40,120,catSize/3,catSize/3))
        let silverLabel = UILabel(frame: CGRectMake(40,160,catSize/3,catSize/3))
        let threeLabel = UILabel(frame: CGRectMake(40,200,catSize/3,catSize/3))
        whiteLabel.text = "1,6..."
        blackLabel.text = "2,7..."
        brownLabel.text = "3,8..."
        silverLabel.text = "4,9..."
        threeLabel.text = "5,10..."
        whiteLabel.font = UIFont(name: "Helvetica", size: whiteLabel.font!.pointSize*0.9)
        blackLabel.font = UIFont(name: "Helvetica", size: blackLabel.font!.pointSize*0.9)
        brownLabel.font = UIFont(name: "Helvetica", size: brownLabel.font!.pointSize*0.9)
        silverLabel.font = UIFont(name: "Helvetica", size: silverLabel.font!.pointSize*0.9)
        threeLabel.font = UIFont(name: "Helvetica", size: threeLabel.font!.pointSize*0.9)
        white.image = UIImage(named: "stand0.png")
        black.image = UIImage(named: "stand1.png")
        brown.image = UIImage(named: "stand2.png")
        silver.image = UIImage(named: "stand3.png")
        three.image = UIImage(named: "stand4.png")
        numberLast.addSubview(white)
        numberLast.addSubview(black)
        numberLast.addSubview(brown)
        numberLast.addSubview(silver)
        numberLast.addSubview(three)
        numberLast.addSubview(whiteLabel)
        numberLast.addSubview(blackLabel)
        numberLast.addSubview(brownLabel)
        numberLast.addSubview(silverLabel)
        numberLast.addSubview(threeLabel)
        view.addSubview(numberLast)
    }
    func prepareSound(name:String,type:String)->AVAudioPlayer{
        var audioPlayer:AVAudioPlayer? = nil
        do{
            let filePath = NSBundle.mainBundle().pathForResource(name,ofType: type)
            let audioPath = NSURL(fileURLWithPath: filePath!)
            audioPlayer = try AVAudioPlayer(contentsOfURL: audioPath)
            audioPlayer!.prepareToPlay()
        }catch{
            print("error")
        }
        return audioPlayer!
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
    override func viewDidLoad() {
        super.viewDidLoad()
        scale = loadScale()
        catSize = 100 * scale
        rightTopInfomation()
        automaticallyAdjustsScrollViewInsets = false
        scrollView.frame = CGRectMake(0, 0, sS.width, sS.height-20)
        scrollView.bounces = false
        if difficulty == 0{
            scrollView.contentSize = CGSizeMake(sS.width, sS.height-20)
            leftEdge = 0
            topEdge = sS.height/10*3.6
            rightEdge = sS.width
            bottomEdge = sS.height - catSize
            catNum = 10
        }else if difficulty == 1{
            scrollView.contentSize = CGSizeMake(sS.width * 2, sS.height-20)
            leftEdge = sS.width / 10*3
            topEdge = sS.height/10*3.6
            rightEdge = sS.width*2
            bottomEdge = sS.height - catSize
            catNum = 15
        }else if difficulty == 2{
            scrollView.contentSize = CGSizeMake(sS.width * 3, sS.height-20)
            leftEdge = sS.width / 10*3
            topEdge = sS.height/10*3.6
            rightEdge = sS.width*2+sS.width/18*4
            bottomEdge = sS.height - catSize
            catNum = 25
        }
        scrollView.contentOffset = CGPointMake(sS.width, 0)
        scrollView.delegate = self
        loadWallImage()
        makeButtons()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if timer == nil && cats.count != 0{
            timer = NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: #selector(GameViewController.timerUpdate), userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
        }
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if timer != nil{
            timer?.invalidate()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    class Neko{
        let sS = UIScreen.mainScreen().bounds.size
        var move = 0
        var progress = 0
        var currentProgress = 0
        var patience = Int(arc4random()%500)
        var itemAndNeko: UIView?
        var nekoAndNumber:UIView?
        var imageView: UIImageView?
        var subImageView: UIImageView?
        var item1: UIImageView?
        var item2: UIImageView?
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
            let frame = CGRectMake(0, 0, label.frame.width, label.frame.height)
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
            if move == 100{
                self.move = 5
            }
            
            nekoAndNumber!.addSubview(imageView!)
            nekoAndNumber!.addSubview(label)
            if move == 100{
                itemAndNeko = UIView(frame: CGRectMake(0,0,sS.width*3,sS.height))
                item1 = UIImageView(frame: CGRectMake(0,0,sS.width*3,sS.height))
                item2 = UIImageView(frame: CGRectMake(0,0,sS.width*3,sS.height))
                item1?.image = UIImage(named: "roomTV.png")
                item2?.image = UIImage(named: "roomTVTop.png")
                itemAndNeko!.addSubview(item1!)
                itemAndNeko!.addSubview(nekoAndNumber!)
                itemAndNeko!.addSubview(item2!)
            }
            if subImageView != nil{
                nekoAndNumber?.addSubview(subImageView!)
            }
        }
        func walk(cat:Neko){
            
        }
        func circleRun(cat:Neko){
            
        }
        func climb(cat:Neko){
            
        }
        func lie(cat:Neko){
            
        }
        func walkAround(cat:Neko){
            
        }
    }
}

