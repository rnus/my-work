//
//  TitleView.swift
//  NekoTest
//
//  Created by naoya uchisawa on 2016/07/06.
//  Copyright © 2016年 NaoyaUchisawa. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds
class TitleView:UIViewController{
    @IBAction func gameStart(_ sender: AnyObject) {
        performSegue(withIdentifier: "toSelect", sender: nil)
    }
    
    
    @IBAction func sound(_ sender: AnyObject) {
        if config.value(forKey: "sound") as! Bool{
            config.set(false, forKey: "sound")
            config.synchronize()
            sound.setImage(UIImage(named:"voloff.png"), for: UIControlState())
        }else{
            config.set(true, forKey: "sound")
            config.synchronize()
            sound.setImage(UIImage(named:"volon.png"), for: UIControlState())
        }
    }
    
    @IBAction func credit(_ sender: AnyObject) {
        performSegue(withIdentifier: "toCre", sender: nil)
    }
    
    @IBOutlet weak var tLabel: UILabel!
    @IBOutlet weak var sound: UIButton!
    @IBOutlet weak var gameStart: UIButton!
    @IBOutlet weak var credit: UIButton!
    @IBOutlet weak var banner: GADBannerView!
    
    let config = UserDefaults.standard
    let sS = UIScreen.main.bounds.size
    var scale:CGFloat = 0
    
    func adjustScale(){
        tLabel.font = UIFont(name: "RiiTegakiFude", size: 22*scale)
        gameStart.titleLabel!.font = UIFont(name: "RiiTegakiFude", size: 22*scale)
        credit.titleLabel!.font = UIFont(name: "RiiTegakiFude", size: 18*scale)
        
        let tEx = ExtendedLabel(frame: tLabel.frame)
        tEx.frame = CGRect(x: tEx.frame.minX, y: tEx.frame.minY, width: tEx.frame.width*scale, height: tEx.frame.height*scale)
        tEx.outLineColor = UIColor.white
        tEx.outLineWidth = 3.0
        tEx.font = UIFont(name: "Chalkduster", size: 27*scale)
        tEx.textColor = UIColor.darkGray
        tEx.text = "CAT NYANBERS"
        tEx.textAlignment = .center
        view.addSubview(tEx)
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
    func loadWallpaper(){
        var wallPaper = UIImage(named: "title.png")
        let resizedSize = CGSize(width: sS.width, height: sS.height)
        UIGraphicsBeginImageContext(resizedSize)
        wallPaper!.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        wallPaper! = resizeImage!
        let wpView = UIImageView(image: wallPaper)
        wpView.frame = CGRect(x: 0, y: 0, width: sS.width, height: sS.height)
        view.addSubview(wpView)
        view.sendSubview(toBack: wpView)
        
        
        var wallPaper2 = UIImage(named: "room1.png")
        let resizedSize2 = CGSize(width: sS.width*3*1.5, height: (sS.height-banner.frame.height)*1.5)
        UIGraphicsBeginImageContext(resizedSize2)
        wallPaper2!.draw(in: CGRect(x: 0, y: 0, width: resizedSize2.width, height: resizedSize2.height))
        let resizeImage2 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        wallPaper2! = resizeImage2!
        let cropRect = CGRect(x: sS.width*3.3, y: sS.height/6, width: sS.width, height: sS.height)
        let cropRef = wallPaper2!.cgImage?.cropping(to: cropRect)
        wallPaper2 = UIImage(cgImage: cropRef!)
        let wpView2 = UIImageView(image: wallPaper2)
        wpView2.frame = CGRect(x: 0, y: 0, width: sS.width, height: sS.height)
        view.addSubview(wpView2)
        view.sendSubview(toBack: wpView2)
    }
    func initConfig(){
        if config.value(forKey: "sound") == nil{
            config.set(true, forKey: "sound")
            config.synchronize()
        }
        if config.value(forKey: "selectFirst") == nil{
            config.set(true, forKey: "selectFirst")
            config.synchronize()
        }
        if config.value(forKey: "sound") as! Bool{
            sound.setImage(UIImage(named:"volon.png"), for: UIControlState())
        }else{
            sound.setImage(UIImage(named:"voloff.png"), for: UIControlState())
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
        initConfig()
        loadWallpaper()
        adjustScale()
        showBanner()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
