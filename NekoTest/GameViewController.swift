//
//  ViewController.swift
//  NekoTest
//
//  Created by NU on 2016/06/07.
//  Copyright © 2016年 NaoyaUchisawa. All rights reserved.
//

import UIKit
import AVFoundation
import Realm
import RealmSwift
import GameKit
import GoogleMobileAds
class GameViewController: UIViewController ,UIScrollViewDelegate{
    @IBOutlet weak var countNumber: UILabel!
    @IBOutlet weak var scrollView: touchScrollView!
    @IBOutlet weak var banner: GADBannerView!
    
    let sS = UIScreen.main.bounds.size
    let config = UserDefaults.standard
    let space = UIScreen.main.bounds.size.width / 160
    var catNum = 25
    var time:UILabel? = nil
    var startTime:Double? = nil
    var cats:[Neko] = []
    var randNumbers:[Int]?
    var current = 1
    var timer:Timer?
    var first = true
    var stopFlag = false
    var images: [String:UIImage] = [:]
    var objects: [String:UIImageView] = [:]
    var audioPlayer2:AVAudioPlayer? = nil
    var sePlayer:AVAudioPlayer? = nil
    var sePlayer2:AVAudioPlayer? = nil
    var difficulty = 0
    var leftEdge:CGFloat? = nil
    var topEdge:CGFloat? = nil
    var rightEdge:CGFloat? = nil
    var bottomEdge:CGFloat? = nil
    var countTimerFlag = false
    var scale: CGFloat = 1.0
    var catSize:CGFloat = 100
    var cardBoardWidth:CGFloat = 100
    var cardBoardHeight:CGFloat = 75
    var ballSize:CGFloat = 40
    var nextView:UIView? = nil
    var nextImageView:UIImageView? = nil
    var nextLabel:ExtendedLabel? = nil
    var countNum = 3
    var countDownFlag = true
    var progress = 0
    var stopButton: UIButton? = nil
    func start(){
        if difficulty != 0{
            scrollView.contentOffset = CGPoint(x: sS.width, y: 0)
        }
        current = 1
        for l in cats{
            l.label!.removeFromSuperview()
            l.imageView!.removeFromSuperview()
            l.nekoAndNumber!.removeFromSuperview()
            l.imageView?.image = nil
            l.imageView = nil
            l.nekoAndNumber = nil
        }
        if objects["cardBoard"] != nil{
            objects["cardBoard"]?.removeFromSuperview()
            objects["cardBoardFront"]?.removeFromSuperview()
            objects["tennisBall"]?.removeFromSuperview()
            objects["baseball"]?.removeFromSuperview()
        }
        if config.value(forKey: "sound") as! Bool{
            audioPlayer2 = prepareSound("playBgm", type: "wav")
            audioPlayer2?.numberOfLoops = 65536
            audioPlayer2?.play()
        }
        randNumbers = getRandArray(catNum)
        addObjects()
        addNekoAndLabels()
        createNextCat()
        toFront()
        
        if difficulty == 0{
            objects["cardBoard"]?.removeFromSuperview()
            objects["cardBoardFront"]?.removeFromSuperview()
        }
        startTime = Date().timeIntervalSince1970
        countTimerFlag = true
        if timer != nil{
            timer?.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(GameViewController.timerUpdate), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
    }
    func stop(){
        if timer != nil{
            timer?.invalidate()
            stopFlag = true
        }
        let alert = UIAlertController(title: "ていしちゅう", message: "", preferredStyle: .alert)
        let resume = UIAlertAction(title: "まだやる", style: .default, handler: {
            (action:UIAlertAction!)->Void in
            self.resume()
        })
        let back = UIAlertAction(title: "もどる", style: .default, handler: {
            (action:UIAlertAction!)->Void in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(back)
        alert.addAction(resume)
        present(alert, animated: true, completion: nil)
        
    }
    func resume(){
        stopFlag = false
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(GameViewController.timerUpdate), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
    }
    func clear(){
        writeRank()
        if config.value(forKey: "sound") as! Bool{
            let str = "drum"
            sePlayer2 = prepareSound(str, type: "mp3")
            sePlayer2?.play()
        }
        let alert = UIAlertController(title: "くりあ", message: time!.text, preferredStyle: .alert)
        let start = UIAlertAction(title: "もっかい", style: .default, handler: {
            (action:UIAlertAction!)->Void in
            self.start()
        })
        let back = UIAlertAction(title: "もどる", style: .default, handler: {
            (action:UIAlertAction!)->Void in
            self.dismiss(animated: true, completion: nil)
        })
        audioPlayer2?.stop()
        alert.addAction(back)
        alert.addAction(start)
        present(alert, animated: true, completion: nil)
    }
    
    
    func send() {
        let db = try! Realm()
            let score: GKScore = GKScore()
            var doubleValue:Double = 0.0
            if difficulty == 0{
                let highScores = db.objects(EasyScore.self)
                var myHighScore:EasyScore?
                for hs in highScores{
                    if hs.rank == 1{
                        myHighScore = hs
                    }
                }
                doubleValue = myHighScore!.time*1000
                score.leaderboardIdentifier = "easy"
            }else if difficulty == 1{
                let highScores = db.objects(NormalScore.self)
                var myHighScore:NormalScore?
                for hs in highScores{
                    if hs.rank == 1{
                        myHighScore = hs
                    }
                }
                doubleValue = myHighScore!.time*1000
                score.leaderboardIdentifier = "normal"
            }else if difficulty == 2{
                let highScores = db.objects(HardScore.self)
                var myHighScore:HardScore?
                for hs in highScores{
                    if hs.rank == 1{
                        myHighScore = hs
                    }
                }
                doubleValue = myHighScore!.time*1000
                score.leaderboardIdentifier = "hard"
            }
            score.value = Int64(doubleValue)
            let scoreArr:[GKScore] = [score]
            GKScore.report(scoreArr, withCompletionHandler: {(error:Error?)->Void in
                if(error != nil){
                    print("Report: Error")
                }else{
                    print("Report: OK")
                }
            })
        
        
        
    }
    
    func writeRank(){
        let db = try! Realm()
        var newFlag = false
        var newRank = 1
        let newTime = Double(time!.text!)!
        
        if difficulty == 0{
            let highScores = db.objects(EasyScore.self)
            for highScore in highScores{
                if highScore.time <= newTime{
                    newRank += 1
                    newFlag = true
                }
            }
            if !newFlag{
                var newRankFlag = 255
                for highScore in highScores{
                    if newTime < highScore.time && highScore.rank <= newRankFlag{
                        newRank = highScore.rank
                        newFlag = true
                        newRankFlag = highScore.rank
                    }
                }
            }
            if highScores.count == 0{
                newRank = 1
                newFlag = true
            }
            if newFlag{
                let score = EasyScore()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd/HH:mm:SS"
                score.rank = newRank
                score.time = newTime
                score.date = dateFormatter.string(from: Date())
                for highScore in highScores{
                    if highScore.rank >= newRank{
                        let score1 = EasyScore()
                        score1.rank = highScore.rank + 1
                        score1.time = highScore.time
                        score1.date = highScore.date
                        try! db.write(){
                            db.delete(highScore)
                            db.add(score1,update: true)
                        }
                    }
                }
                try! db.write(){
                    db.add(score,update: true)
                }
                for s in highScores{
                    if s.rank == 31{
                        try! db.write(){
                            db.delete(s)
                        }
                        break
                    }
                }
            }
        }else if difficulty == 1{
            let highScores = db.objects(NormalScore.self)
            for highScore in highScores{
                if highScore.time <= newTime{
                    newRank += 1
                    newFlag = true
                }
            }
            if !newFlag{
                var newRankFlag = 255
                for highScore in highScores{
                    if newTime < highScore.time && highScore.rank <= newRankFlag{
                        newRank = highScore.rank
                        newFlag = true
                        newRankFlag = highScore.rank
                    }
                }
            }
            if highScores.count == 0{
                newRank = 1
                newFlag = true
            }
            if newFlag{
                let score = NormalScore()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd/HH:mm:SS"
                score.rank = newRank
                score.time = newTime
                score.date = dateFormatter.string(from: Date())
                for highScore in highScores{
                    if highScore.rank >= newRank{
                        let score1 = NormalScore()
                        score1.rank = highScore.rank + 1
                        score1.time = highScore.time
                        score1.date = highScore.date
                        try! db.write(){
                            db.delete(highScore)
                            db.add(score1,update: true)
                        }
                    }
                }
                try! db.write(){
                    db.add(score,update: true)
                }
                for s in highScores{
                    if s.rank == 31{
                        try! db.write(){
                            db.delete(s)
                        }
                        break
                    }
                }
            }
        }else if difficulty == 2{
            let highScores = db.objects(HardScore.self)
            for highScore in highScores{
                if highScore.time <= newTime{
                    newRank += 1
                    newFlag = true
                }
            }
            if !newFlag{
                var newRankFlag = 255
                for highScore in highScores{
                    if newTime < highScore.time && highScore.rank <= newRankFlag{
                        newRank = highScore.rank
                        newFlag = true
                        newRankFlag = highScore.rank
                    }
                }
            }
            if highScores.count == 0{
                newRank = 1
                newFlag = true
            }
            if newFlag{
                let score = HardScore()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd/HH:mm:SS"
                score.rank = newRank
                score.time = newTime
                score.date = dateFormatter.string(from: Date())
                for highScore in highScores{
                    if highScore.rank >= newRank{
                        let score1 = HardScore()
                        score1.rank = highScore.rank + 1
                        score1.time = highScore.time
                        score1.date = highScore.date
                        try! db.write(){
                            db.delete(highScore)
                            db.add(score1,update: true)
                        }
                    }
                }
                try! db.write(){
                    db.add(score,update: true)
                }
                for s in highScores{
                    if s.rank == 31{
                        try! db.write(){
                            db.delete(s)
                        }
                        break
                    }
                }
            }
        }
        if newRank == 1{
            send()
        }
    }
    func createNextCat(){
        if nextView != nil{
            nextView?.removeFromSuperview()
        }
        let frame1 = CGRect(x: sS.width - sS.width/2.6, y: 20+50*scale, width: sS.width/3, height: sS.width/5)
        nextView = UIView(frame: frame1)
        var nextColor = 0
        for neko in cats{
            if neko.label?.text == String(current){
                nextColor = neko.color
                break
            }
        }
        let frame2 = CGRect(x: 0, y: 0, width: catSize/1.5, height: catSize/1.5)
        nextImageView = UIImageView(frame: frame2)
        let colorAndPose = "stand" + String(nextColor)
        nextImageView!.image = UIImage(named: colorAndPose)
        nextLabel = ExtendedLabel(frame: frame2)
        nextLabel!.textColor = UIColor.darkGray
        nextLabel!.font = UIFont(name: "Chalkduster", size: 24/1.5)
        nextLabel!.outLineColor = UIColor.white
        nextLabel!.outLineWidth = 3.0
        nextLabel!.backgroundColor = UIColor.init(white: 1.0, alpha: 0.0)
        nextLabel!.text = String(current)
        nextLabel!.textAlignment = .center
        nextView?.addSubview(nextImageView!)
        nextView?.addSubview(nextLabel!)
        view.addSubview(nextView!)
    }
    func changeNextCat(){
        if difficulty == 0 && current != 11 || difficulty == 1 && current != 16 || difficulty == 2 && current != 26{
            var nextColor = 0
            for neko in cats{
                if neko.label?.text == String(current){
                    nextColor = neko.color
                    break
                }
            }
            let colorAndPose = "stand" + String(nextColor)
            nextImageView?.image = UIImage(named: colorAndPose)
            nextLabel?.text = String(current)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if first{
            first = false
        }
        let point = touches.first?.location(in: scrollView)
        for l in cats{
            let neko = CGRect(x: l.nekoAndNumber!.frame.minX+catSize/10*1, y: l.nekoAndNumber!.frame.minY+catSize/10*1, width: catSize-catSize/10*2, height: catSize-catSize/10*2)
            if l.label!.text == String(current) && !stopFlag && neko.contains(point!){
                current += 1
                changeNextCat()
                l.catchFlag = true
                if config.value(forKey: "sound") as! Bool{
                    let str = "cat" + String(arc4random()%4+1)
                    sePlayer = prepareSound(str, type: "mp3")
                    sePlayer?.play()
                }
                if l.label!.text == String(cats.count){
                    countTimerFlag = false
                    clear()
                }
                break
            }
        }
    }
    func makeButtons(){
        let frame2 = CGRect(x: sS.width - sS.width/5, y: 20+50*scale, width: sS.width/6, height: sS.width/6)
        stopButton = UIButton(frame: frame2)
        stopButton!.setImage(images["stop"], for: UIControlState())
        stopButton!.setTitle("STOP", for: UIControlState())
        stopButton!.addTarget(self, action: #selector(GameViewController.stop), for: .touchUpInside)
        view.addSubview(stopButton!)
        let frame4 = CGRect(x: sS.width/3, y: catSize/3+50*scale, width: sS.width/3-space-space*2, height: sS.height/20-space*2)
        time = UILabel(frame: frame4)
        time?.font = UIFont.monospacedDigitSystemFont(ofSize: time!.font.pointSize*scale, weight: 1)
        time?.textAlignment = .center
        time!.textColor = UIColor.darkGray
        time!.text = "0.000"
        view.addSubview(time!)
    }
    func toFront(){
        scrollView.bringSubview(toFront: objects["cardBoardFront"]!)
        view.bringSubview(toFront: stopButton!)
    }
    func addNekoAndLabels(){
        cats.removeAll()
        for i in 0..<catNum{
            var frame:CGRect? = nil
            if difficulty == 0{
                let xx = rightEdge! - catSize
                let yy = sS.height - topEdge! - CGFloat(catSize / 1.9)
                var x = CGFloat(arc4random()%UInt32(xx))
                var y = sS.height/10*3.6 + CGFloat(arc4random()%UInt32(yy))
                frame = CGRect(x: x+20*scale, y: y+20*scale, width: catSize-40*scale, height: catSize-40*scale)
                for j in cats{
                    while j.nekoAndNumber!.frame.intersects(frame!){
                        x = CGFloat(arc4random()%UInt32(xx))
                        y = sS.height/10*3.6 + CGFloat(arc4random()%UInt32(yy))
                        frame = CGRect(x: x+20*scale, y: y+20*scale, width: catSize-40*scale, height: catSize-40*scale)
                    }
                }
                frame = CGRect(x: x,y: y,width: catSize, height: catSize)
            }else if difficulty == 1{
                if i == 0{
                    frame = CGRect(x: sS.width/10*8.6,y: sS.height/10*2.8 ,width: catSize, height: catSize)
                }else if i == 1{
                    frame = CGRect(x: sS.width+sS.width/10*7.5,y: sS.height/10*2.8 ,width: catSize, height: catSize)
                }else if i == 2{
                    frame = CGRect(x: objects["cardBoard"]!.frame.minX,y: objects["cardBoard"]!.frame.minY-22,width: catSize, height: catSize)
                }else{
                    while true{
                        let xx = rightEdge! - catSize
                        let yy = sS.height - topEdge! - CGFloat(catSize / 1.9)
                        let x = CGFloat(arc4random()%UInt32(xx))
                        let y = sS.height/10*3.6 + CGFloat(arc4random()%UInt32(yy))
                        frame = CGRect(x: x,y: y,width: catSize, height: catSize)
                        if !(objects["cardBoard"]!.frame.intersects(frame!)){
                            break
                        }
                    }
                }
            }else if difficulty == 2{
                if i == 0{
                    frame = CGRect(x: sS.width*2+sS.width/18*7,y: sS.height/10*4 ,width: catSize, height: catSize)
                }else if i == 1{
                    frame = CGRect(x: sS.width*2+sS.width/18*4,y: sS.height/10*5.3 ,width: catSize, height: catSize)
                }else if i == 2{
                    frame = CGRect(x: sS.width*2+sS.width/18*7.5,y: sS.height/10*6.5 ,width: catSize, height: catSize)
                }else if i == 3{
                    frame = CGRect(x: sS.width/15,y: sS.height/10*3.3 ,width: catSize, height: catSize)
                }else if i == 4{
                    frame = CGRect(x: sS.width/3.5,y: sS.height/10*4.5 ,width: catSize, height: catSize)
                }else if i == 5{
                    frame = CGRect(x: sS.width/5,y: sS.height/10*0.01 ,width: catSize, height: catSize)
                }else if i == 6{
                    frame = CGRect(x: sS.width + sS.width/10*6.7,y: sS.height/10*7 ,width: catSize, height: catSize)
                }else if i == 7{
                    frame = CGRect(x: sS.width/10*8.6,y: sS.height/10*2.8 ,width: catSize, height: catSize)
                }else if i == 8{
                    frame = CGRect(x: sS.width+sS.width/10*7.5,y: sS.height/10*2.8 ,width: catSize, height: catSize)
                }else if i == 9{
                    frame = CGRect(x: sS.width,y: sS.height/10*3.5 ,width: catSize, height: catSize)
                }else if i == 10{
                    frame = CGRect(x: sS.width+sS.width/10*3,y: sS.height/10*3.6 ,width: catSize, height: catSize)
                }else if i == 11{
                    frame = CGRect(x: sS.width+sS.width/10*2,y: sS.height/10*4.5 ,width: catSize, height: catSize)
                }else if i == 12{
                    frame = CGRect(x: objects["cardBoard"]!.frame.minX,y: objects["cardBoard"]!.frame.minY-22,width: catSize, height: catSize)
                }else if i == 13{
                    frame = CGRect(x: sS.width/2,y: sS.height/10*5.3 ,width: catSize, height: catSize)
                }else if i >= 14{
                    while true{
                        let xx = rightEdge! - catSize
                        let yy = sS.height - topEdge! - CGFloat(catSize / 1.9)
                        let x = CGFloat(arc4random()%UInt32(xx))
                        let y = sS.height/10*3.6 + CGFloat(arc4random()%UInt32(yy))
                        frame = CGRect(x: x,y: y,width: catSize, height: catSize)
                        if !(objects["cardBoard"]!.frame.intersects(frame!)){
                            break
                        }
                    }
                }
            }
            let label:ExtendedLabel = ExtendedLabel(frame: frame!)
            label.textColor = UIColor.darkGray
            label.font = UIFont(name: "Chalkduster", size: 24)
            label.outLineColor = UIColor.white
            label.outLineWidth = 3.0
            label.backgroundColor = UIColor.init(white: 1.0, alpha: 0.0)
            label.text = String(randNumbers![i])
            label.textAlignment = .center
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
                if i <= 1{
                    neko = Neko(move: 3,label: label,color: color)
                }else if i == 2{
                    neko = Neko(move: 100,label: label,color: color)
                }else{
                    var move = 1
                    while true{
                        move = Int(arc4random()%7)
                        if move != 3 && move != 4{
                            break
                        }
                    }
                    neko = Neko(move: move,label: label,color: color)
                }
            }else if difficulty == 2{
                if i == 1{
                    neko = Neko(move: 1,label: label,color: color)
                }else if i == 2{
                    neko = Neko(move: 5,label: label,color: color)
                }else if i < 7{
                    neko = Neko(move: 5,label: label,color: color)
                }else if i == 7 || i == 8{
                    neko = Neko(move: 3,label: label,color: color)
                }else if i == 9 || i == 10{
                    neko = Neko(move: 0,label: label,color: color)
                }else if i == 11{
                    neko = Neko(move: 1,label: label,color: color)
                }else if i == 12{
                    neko = Neko(move: 100,label: label,color: color)
                }else if i == 13{
                    neko = Neko(move: 2,label: label,color: color)
                }else if i >= 14{
                    neko = Neko(move: 6,label: label,color: color)
                }
            }
            cats.append(neko!)
            neko!.addObjectFrames("cardBoard", frame: objects["cardBoard"]!.frame)
            neko!.addObjectFrames("cardBoardFront", frame: objects["cardBoardFront"]!.frame)
            neko!.addObjectFrames("tennisBall", frame: objects["tennisBall"]!.frame)
            neko!.addObjectFrames("baseball", frame: objects["baseball"]!.frame)
            scrollView.addSubview(neko!.nekoAndNumber!)        }
    }
    func addObjects(){
        let x = CGFloat(arc4random()).truncatingRemainder(dividingBy: (sS.width-cardBoardWidth)) + sS.width
        let y = CGFloat(arc4random()).truncatingRemainder(dividingBy: (scrollView.frame.height/10*3.6)) + scrollView.frame.height/10*6.4
        let cFrame = CGRect(x: x, y: y, width: cardBoardWidth, height: cardBoardHeight)
        var tFrame:CGRect? = nil
        var bFrame:CGRect? = nil
        let cardBoard = UIImageView(frame: cFrame)
        let cardBoardFront = UIImageView(frame: cFrame)
        cardBoard.image = images["cardBoard"]
        cardBoardFront.image = images["cardBoardFront"]
        scrollView.addSubview(cardBoard)
        scrollView.addSubview(cardBoardFront)
        objects.removeAll()
        objects["cardBoard"] = cardBoard
        objects["cardBoardFront"] = cardBoardFront
        repeat{
            if difficulty == 0{
                let x2 = CGFloat(arc4random()).truncatingRemainder(dividingBy: (sS.width-ballSize))
                let y2 = CGFloat(arc4random()).truncatingRemainder(dividingBy: (scrollView.frame.height/10*4-ballSize)) + scrollView.frame.height/10*6
                tFrame = CGRect(x: x2, y: y2, width: ballSize, height: ballSize)
            }else if difficulty == 1{
                let x2 = CGFloat(arc4random()).truncatingRemainder(dividingBy: (sS.width/3*3.5-ballSize))+sS.width/3*1.5
                let y2 = CGFloat(arc4random()).truncatingRemainder(dividingBy: (scrollView.frame.height/10*4-ballSize)) + scrollView.frame.height/10*6
                tFrame = CGRect(x: x2, y: y2, width: ballSize, height: ballSize)
            }else if difficulty == 2{
                let x2 = CGFloat(arc4random()).truncatingRemainder(dividingBy: (sS.width/3*6.5-ballSize))+sS.width/3*1.5
                let y2 = CGFloat(arc4random()).truncatingRemainder(dividingBy: (scrollView.frame.height/10*4-ballSize)) + scrollView.frame.height/10*6
                tFrame = CGRect(x: x2, y: y2, width: ballSize, height: ballSize)
            }
        }while tFrame!.intersects(cFrame)
        repeat{
            if difficulty == 0{
                let x3 = CGFloat(arc4random()).truncatingRemainder(dividingBy: (sS.width-ballSize))
                let y3 = CGFloat(arc4random()).truncatingRemainder(dividingBy: (scrollView.frame.height/10*4-ballSize)) + scrollView.frame.height/10*6
                bFrame = CGRect(x: x3, y: y3, width: ballSize, height: ballSize)
            }else if difficulty == 1{
                let x3 = CGFloat(arc4random()).truncatingRemainder(dividingBy: (sS.width/3*3.5-ballSize))+sS.width/3*1.5
                let y3 = CGFloat(arc4random()).truncatingRemainder(dividingBy: (scrollView.frame.height/10*4-ballSize)) + scrollView.frame.height/10*6
                bFrame = CGRect(x: x3, y: y3, width: ballSize, height: ballSize)
            }else if difficulty == 2{
                let x3 = CGFloat(arc4random()).truncatingRemainder(dividingBy: (sS.width/3*6.5-ballSize))+sS.width/3*1.5
                let y3 = CGFloat(arc4random()).truncatingRemainder(dividingBy: (scrollView.frame.height/10*4-ballSize)) + scrollView.frame.height/10*6
                bFrame = CGRect(x: x3, y: y3, width: ballSize, height: ballSize)
            }
        }while bFrame!.intersects(cFrame) && bFrame!.intersects(tFrame!)
        let tennisBall = UIImageView(frame: tFrame!)
        let baseball = UIImageView(frame: bFrame!)
        tennisBall.image = images["tennisBall"]
        baseball.image = images["baseball"]
        scrollView.addSubview(tennisBall)
        scrollView.addSubview(baseball)
        objects["tennisBall"] = tennisBall
        objects["baseball"] = baseball
    }
    func getRandArray(_ num:Int)->[Int]{
        randNumbers?.removeAll()
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
                    i.walkRight(images)
                }else if i.move == 1{
                    i.walkLeft(images)
                }else if i.move == 2{
                    i.circleRun(images)
                }else if i.move == 3{
                    i.climbUp(images)
                }else if i.move == 4{
                    i.climbDown(images, bottomEdge: bottomEdge!)
                }else if i.move == 5{
                    i.lie(images)
                }else if i.move == 6{
                    i.walkAround(catSize, images: images, leftEdge: leftEdge!, topEdge: topEdge!, rightEdge: rightEdge!, bottomEdge: bottomEdge!,currentNum: current)
                }else if i.move == 7{
                    i.ball(images)
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
                    i.nekoAndNumber?.frame = CGRect(x: i.nekoAndNumber!.frame.minX - scrollView.contentOffset.x, y: i.nekoAndNumber!.frame.minY+50*scale, width: catSize, height: catSize)
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
                let frame = CGRect(x: p_x, y: p_y, width: catSize, height: catSize)
                i.nekoAndNumber?.frame = frame
                i.catchProgress += 0.005 + i.catchProgress*0.009
            }
            if i.catchProgress >= 1{
                i.catchFlag = false
                i.nekoAndNumber?.isHidden = true
            }
        }
    }
    
    func countDown(){
        if progress == 0{
            if config.value(forKey: "sound") as! Bool{
                let str = "cat2"
                sePlayer2 = prepareSound(str, type: "mp3")
                sePlayer2?.play()
            }
            let anime = CABasicAnimation(keyPath: "strokeEnd")
            anime.duration = 1.0
            anime.fromValue = 0.0
            anime.toValue = 1.0
            sharpLayer.add(anime, forKey: "countCircle")
        }
        progress += 1
        if progress == 51{
            progress = 0
        }
        if progress == 50{
            countNumber.text = String(Int(countNumber.text!)! - 1)
            sharpLayer.removeAllAnimations()
            if countNumber.text == "0"{
                countNumber.removeFromSuperview()
                countNumber = nil
                countDownFlag = false
                sharpLayer.removeFromSuperlayer()
                start()
            }
        }
    }
    func timerUpdate(){
        if countTimerFlag{
            let current = Date().timeIntervalSince1970
            time?.text = String(format: "%.03f", current - startTime!)
        }
        if countDownFlag{
            countDown()
        }else{
            moveCats()
            catchCat()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        if timer != nil{
            timer?.invalidate()
        }
    }
    
    func loadWallImage(){
        var wallPaper = UIImage(named: "room2.png")
        let resizedSize = CGSize(width: sS.width*3, height: scrollView.frame.height)
        UIGraphicsBeginImageContext(resizedSize)
        wallPaper!.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        wallPaper! = resizeImage!
        if difficulty == 0 {
            let cropRect = CGRect(x: wallPaper!.size.width/3, y: 0, width: wallPaper!.size.width/3, height: wallPaper!.size.height)
            let cropRef = wallPaper!.cgImage?.cropping(to: cropRect)
            wallPaper = UIImage(cgImage: cropRef!)
        }else if difficulty == 1{
            let cropRect = CGRect(x: 0, y: 0, width: wallPaper!.size.width/3*2, height: wallPaper!.size.height)
            let cropRef = wallPaper!.cgImage?.cropping(to: cropRect)
            wallPaper = UIImage(cgImage: cropRef!)
        }
        let wpView = UIImageView(image: wallPaper)
        if difficulty == 0{
            wpView.frame = CGRect(x: 0, y: 0, width: sS.width, height: sS.height)
        }else if difficulty == 1{
            wpView.frame = CGRect(x: 0, y: 0, width: sS.width*2, height: sS.height)
        }else{
            wpView.frame = CGRect(x: 0, y: 0, width: sS.width*3, height: sS.height)
        }
        scrollView.addSubview(wpView)
        scrollView.sendSubview(toBack: wpView)
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
        images["cardBoard"] = UIImage(named: "cardBoard.png")!
        images["cardBoardFront"] = UIImage(named: "cardBoardFront.png")!
        images["stop"] = UIImage(named: "stop.png")
        images["ball0"] = UIImage(named: "ball0.png")!
        images["hand00"] = UIImage(named: "hand00.png")!
        images["hand10"] = UIImage(named: "hand10.png")!
        images["hand20"] = UIImage(named: "hand20.png")!
        images["hand30"] = UIImage(named: "hand30.png")!
        images["ball1"] = UIImage(named: "ball1.png")!
        images["hand01"] = UIImage(named: "hand01.png")!
        images["hand11"] = UIImage(named: "hand11.png")!
        images["hand21"] = UIImage(named: "hand21.png")!
        images["hand31"] = UIImage(named: "hand31.png")!
        images["ball2"] = UIImage(named: "ball2.png")!
        images["hand02"] = UIImage(named: "hand02.png")!
        images["hand12"] = UIImage(named: "hand12.png")!
        images["hand22"] = UIImage(named: "hand22.png")!
        images["hand32"] = UIImage(named: "hand32.png")!
        images["ball3"] = UIImage(named: "ball3.png")!
        images["hand03"] = UIImage(named: "hand03.png")!
        images["hand13"] = UIImage(named: "hand13.png")!
        images["hand23"] = UIImage(named: "hand23.png")!
        images["hand33"] = UIImage(named: "hand33.png")!
        images["ball4"] = UIImage(named: "ball4.png")!
        images["hand04"] = UIImage(named: "hand04.png")!
        images["hand14"] = UIImage(named: "hand14.png")!
        images["hand24"] = UIImage(named: "hand24.png")!
        images["hand34"] = UIImage(named: "hand34.png")!
        images["tennisBall"] = UIImage(named: "tennisBall.png")!
        images["baseball"] = UIImage(named: "baseball.png")!
    }
    func rightTopInfomation(){
        let numberLast = UIView(frame: CGRect(x: sS.width/4*2.6,y: 0,width: sS.width/4*1.2,height: sS.height/3))
        let white = UIImageView(frame: CGRect(x: 0,y: 40,width: catSize/3,height: catSize/3))
        let black = UIImageView(frame: CGRect(x: 0,y: 80,width: catSize/3,height: catSize/3))
        let brown = UIImageView(frame: CGRect(x: 0,y: 120,width: catSize/3,height: catSize/3))
        let silver = UIImageView(frame: CGRect(x: 0,y: 160,width: catSize/3,height: catSize/3))
        let three = UIImageView(frame: CGRect(x: 0,y: 200,width: catSize/3,height: catSize/3))
        let whiteLabel = UILabel(frame: CGRect(x: 40,y: 40,width: catSize/3*1.2,height: catSize/3))
        let blackLabel = UILabel(frame: CGRect(x: 40,y: 80,width: catSize/3*1.2,height: catSize/3))
        let brownLabel = UILabel(frame: CGRect(x: 40,y: 120,width: catSize/3*1.2,height: catSize/3))
        let silverLabel = UILabel(frame: CGRect(x: 40,y: 160,width: catSize/3*1.2,height: catSize/3))
        let threeLabel = UILabel(frame: CGRect(x: 40,y: 200,width: catSize/3*1.2,height: catSize/3))
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
    let sharpLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width/2,height: UIScreen.main.bounds.size.height)
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.darkGray.cgColor
        layer.lineWidth = 50.0
        return layer
    }()
    func prepareCount(){
        let center = CGPoint(x: sS.width/2,y: sS.height/2)
        let radius = 100*scale
        let startAngle = CGFloat(-M_PI_2)
        let endAngle = startAngle + 2.0 * CGFloat(M_PI)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        sharpLayer.path = path.cgPath
        countNumber.font = UIFont(name: "ChalkDuster", size: 100*scale)
        countNumber.textColor = UIColor.darkGray
        view.bringSubview(toFront: countNumber)
    }
    func prepareSound(_ name:String,type:String)->AVAudioPlayer{
        var audioPlayer:AVAudioPlayer? = nil
        do{
            let filePath = Bundle.main.path(forResource: name,ofType: type)
            let audioPath = URL(fileURLWithPath: filePath!)
            audioPlayer = try AVAudioPlayer(contentsOf: audioPath)
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
        catSize = catSize * scale
        cardBoardWidth = cardBoardWidth * scale
        cardBoardHeight = cardBoardHeight * scale

        automaticallyAdjustsScrollViewInsets = false
        if difficulty == 0{
            scrollView.contentSize = CGSize(width: sS.width, height: sS.height-50*scale-20)
            leftEdge = 0
            topEdge = scrollView.frame.height/10*6.4
            rightEdge = sS.width
            bottomEdge = scrollView.contentSize.height
            catNum = 10
        }else if difficulty == 1{
            scrollView.contentSize = CGSize(width: sS.width * 2, height: sS.height-50*scale-20)
            leftEdge = sS.width / 10*3
            topEdge = scrollView.frame.height/10*6.4
            rightEdge = sS.width*2
            bottomEdge = scrollView.contentSize.height
            catNum = 15
        }else if difficulty == 2{
            scrollView.contentSize = CGSize(width: sS.width * 3, height: sS.height-50*scale-20)
            leftEdge = sS.width / 10*3
            topEdge = scrollView.frame.height/10*6.4
            rightEdge = sS.width*3
            bottomEdge = scrollView.contentSize.height
            catNum = 25
        }
        if difficulty != 0{
            scrollView.contentOffset = CGPoint(x: sS.width, y: 0)
        }
        scrollView.delegate = self
        loadWallImage()
        makeButtons()
        prepareCount()
        showBanner()
        view.layer.addSublayer(sharpLayer)
        timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(GameViewController.timerUpdate), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view, typically from a nib.
    }
    func showBanner(){
        banner.adUnitID = "ca-app-pub-4139998452148591/4941710868"
        banner.rootViewController = self
        let request:GADRequest = GADRequest()
        banner.load(request)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if timer == nil && cats.count != 0{
            timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(GameViewController.timerUpdate), userInfo: nil, repeats: true)
            RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if timer != nil{
            timer?.invalidate()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

