//
//  RankView.swift
//  NekoTest
//
//  Created by naoya uchisawa on 2016/07/09.
//  Copyright © 2016年 NaoyaUchisawa. All rights reserved.
//

import Foundation
import UIKit
import Realm
import RealmSwift
import GameKit
import GoogleMobileAds
class RankView:UIViewController,GKGameCenterControllerDelegate{
    
    @IBOutlet weak var banner: GADBannerView!
    @IBOutlet weak var gameCenter: ExtendedLabel!
    @IBOutlet weak var gc: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    func back(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func viewGc(_ sender: AnyObject) {
        let localPlayer = GKLocalPlayer()
        localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: {(leaderboardIdentifier:String?,error:Error?)->Void in
            if error != nil{
                print(error?.localizedDescription)
            }else{
                let gcViewController: GKGameCenterViewController = GKGameCenterViewController()
                gcViewController.gameCenterDelegate = self
                gcViewController.viewState = GKGameCenterViewControllerState.leaderboards
                gcViewController.leaderboardIdentifier = nil
                self.present(gcViewController, animated: true, completion: nil)
            }
        })
    }
    
    let sS = UIScreen.main.bounds.size
    var difficulty = 0
    var scale:CGFloat = 1
    var catSize:CGFloat = 100
    
    func back(){
        dismiss(animated: true, completion: nil)
    }
    func adjustButton(){
        let catFrame = CGRect(x: 0, y: 0,width: catSize , height: catSize)
        let backFrame = CGRect(x: sS.width/2-catSize, y: sS.height/10*7, width: catSize, height: catSize)
        
        let back = UIButton(frame:backFrame)
        let backLabel = ExtendedLabel(frame: catFrame)
        let backCat = UIImageView(frame: catFrame)
        let backCatSub = UIImageView(frame: catFrame)
        let gcLabel = ExtendedLabel(frame: gameCenter.frame)
        gcLabel.frame = CGRect(x: gcLabel.frame.minX, y: gcLabel.frame.minY, width: gcLabel.frame.width*scale, height: gcLabel.frame.height*scale)
        backLabel.textColor = UIColor.darkGray
        backLabel.font = UIFont(name: "RiiTegakiFude", size: 18*scale)
        backLabel.outLineColor = UIColor.white
        backLabel.outLineWidth = 3.0
        backLabel.backgroundColor = UIColor.init(white: 1.0, alpha: 0.0)
        backLabel.textAlignment = .center
        backLabel.text = "もどる"
        gcLabel.outLineColor = UIColor.white
        gcLabel.outLineWidth = 3.0
        gcLabel.font = UIFont(name: "RiiTegakiFude", size: 25*scale)
        gcLabel.textColor = UIColor.darkGray
        gcLabel.text = "ねっとらんきんぐ→"
        backCat.image = UIImage(named: "lie02.png")
        backCatSub.image = UIImage(named: "tail12")
        backCat.addSubview(backCatSub)
        backCat.addSubview(backLabel)
        back.addTarget(self, action: #selector(RankView.back as (RankView) -> () -> ()), for: .touchUpInside)
        back.addSubview(backCat)
        view.addSubview(back)
        gc.frame = CGRect(x: gc.frame.minX, y: gc.frame.minY, width: 58*scale, height: 58*scale)
        view.addSubview(gcLabel)
        
    }
    
    func loadScore(){
        let db = try! Realm()
        if difficulty == 0{
            let highScores = db.objects(EasyScore.self)
            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: CGFloat(highScores.count+1)*22*scale)
            for highScore in highScores{
                let frame = CGRect(x: 0,y: CGFloat(highScore.rank)*(22*scale), width: scrollView.frame.width, height: 22*scale)
                let scoreText = UILabel(frame: frame)
                var text = "   "
                text += String(highScore.rank) + "     " + String(highScore.time)
                scoreText.font = UIFont(name: "Chalkduster", size: scoreText.font.pointSize * scale*1.7)
                scoreText.text = text
                scoreText.textColor = UIColor.darkGray
                scrollView.addSubview(scoreText)
            }
        }else if difficulty == 1{
            let highScores = db.objects(NormalScore.self)
            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: CGFloat(highScores.count+1)*22*scale)
            for highScore in highScores{
                let frame = CGRect(x: 0,y: CGFloat(highScore.rank)*(22*scale), width: scrollView.frame.width, height: 22*scale)
                let scoreText = UILabel(frame: frame)
                var text = "   "
                text += String(highScore.rank) + "     " + String(highScore.time)
                scoreText.font = UIFont(name: "Chalkduster", size: scoreText.font.pointSize * scale*1.7)
                scoreText.text = text
                scoreText.textColor = UIColor.darkGray
                scrollView.addSubview(scoreText)
            }
        }else if difficulty == 2{
            let highScores = db.objects(HardScore.self)
            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: CGFloat(highScores.count+1)*22*scale)
            for highScore in highScores{
                let frame = CGRect(x: 0,y: CGFloat(highScore.rank)*(22*scale), width: scrollView.frame.width, height: 22*scale)
                let scoreText = UILabel(frame: frame)
                var text = "   "
                text += String(highScore.rank) + "     " + String(highScore.time)
                scoreText.font = UIFont(name: "Chalkduster", size: scoreText.font.pointSize * scale*1.7)
                scoreText.text = text
                scoreText.textColor = UIColor.darkGray
                scrollView.addSubview(scoreText)
            }
        }
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func loadWallpaper(){
        var wallPaper = UIImage(named: "room1.png")
        let resizedSize = CGSize(width: sS.width*3*1.55, height: sS.height*1.55)
        UIGraphicsBeginImageContext(resizedSize)
        wallPaper!.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        wallPaper! = resizeImage!
        let cropRect = CGRect(x: sS.width*1.95, y: sS.height/17, width: sS.width, height: sS.height)
        let cropRef = wallPaper!.cgImage?.cropping(to: cropRect)
        wallPaper = UIImage(cgImage: cropRef!)
        let wpView = UIImageView(image: wallPaper)
        wpView.frame = CGRect(x: 0, y: 0, width: sS.width, height: sS.height)
        view.addSubview(wpView)
        view.sendSubview(toBack: wpView)
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
    
    func showBanner(){
        banner.adUnitID = "ca-app-pub-4139998452148591/4941710868"
        banner.rootViewController = self
        let request:GADRequest = GADRequest()
        banner.load(request)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scale = loadScale()
        catSize = 100 * scale
        adjustButton()
        loadScore()
        loadWallpaper()
        showBanner()
    }
    override func didReceiveMemoryWarning() {
        super.viewDidLoad()
    }
}
