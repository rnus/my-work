//
//  SelectView.swift
//  NekoTest
//
//  Created by NU on 2016/06/14.
//  Copyright © 2016年 NaoyaUchisawa. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds
class SelectView:UIViewController{
    
    @IBOutlet weak var banner: GADBannerView!
    
    let config = UserDefaults.standard
    let sS = UIScreen.main.bounds.size
    var difficulty = 0
    var scale:CGFloat = 1.0
    var catSize:CGFloat = 100
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGame"{
            let vc = segue.destination as! GameViewController
            vc.difficulty = self.difficulty
        }
    }
    func easy(){
        difficulty = 0
        performSegue(withIdentifier: "toGame", sender: nil)
    }
    func normal(){
        difficulty = 1
        performSegue(withIdentifier: "toGame", sender: nil)
    }
    func hard(){
        difficulty = 2
        performSegue(withIdentifier: "toGame", sender: nil)
    }
    func back(){
        dismiss(animated: true, completion: nil)
    }
    func ranking(){
        performSegue(withIdentifier: "toRank", sender: nil)
    }
    func createButton(){
        let catFrame = CGRect(x: 0, y: 0,width: catSize , height: catSize)
        let easyFrame = CGRect(x: sS.width/2-catSize, y: 20+sS.height/10*4.7, width: catSize, height: catSize)
        let normalFrame = CGRect(x: sS.width/2, y: sS.height/3.3, width: catSize, height: catSize)
        let hardFrame = CGRect(x: sS.width/2-catSize/2, y: sS.height/9, width: catSize, height: catSize)
        let backFrame = CGRect(x: sS.width/2-catSize, y: sS.height/10*7, width: catSize, height: catSize)
        let rankingFrame = CGRect(x: sS.width/2, y: sS.height/10*7, width: catSize, height: catSize)
        
        let easyButton = UIButton(frame: easyFrame)
        let normalButton = UIButton(frame: normalFrame)
        let hardButton = UIButton(frame: hardFrame)
        let backButton = UIButton(frame: backFrame)
        let rankingButton = UIButton(frame: rankingFrame)
        let easyLabel = ExtendedLabel(frame: catFrame)
        let normalLabel = ExtendedLabel(frame: catFrame)
        let hardLabel = ExtendedLabel(frame: catFrame)
        let backLabel = ExtendedLabel(frame: catFrame)
        let rankingLabel = ExtendedLabel(frame: catFrame)
        let labels:[ExtendedLabel] = [easyLabel,normalLabel,hardLabel,backLabel,rankingLabel]
        
        let easyCat = UIImageView(frame: catFrame)
        let easyCatSub = UIImageView(frame: catFrame)
        let normalCat = UIImageView(frame: catFrame)
        let hardCat = UIImageView(frame: catFrame)
        let backCat = UIImageView(frame: catFrame)
        let backCatSub = UIImageView(frame: catFrame)
        let rankingCat = UIImageView(frame: catFrame)
        for label in labels{
            label.textColor = UIColor.darkGray
            label.font = UIFont(name: "RiiTegakiFude", size: 18*scale)
            label.outLineColor = UIColor.white
            label.outLineWidth = 3.0
            label.backgroundColor = UIColor.init(white: 1.0, alpha: 0.0)
            label.textAlignment = .center
        }
        easyLabel.text = "かんたん"
        normalLabel.text = "ふつう"
        hardLabel.text = "むずかしい"
        backLabel.text = "もどる"
        rankingLabel.text = "らんきんぐ"
        easyCat.image = UIImage(named: "lie00.png")
        easyCatSub.image = UIImage(named: "tail10.png")
        normalCat.image = UIImage(named: "stand3.png")
        hardCat.image = UIImage(named: "run24.png")
        backCat.image = UIImage(named: "lie02.png")
        backCatSub.image = UIImage(named: "tail12")
        rankingCat.image = UIImage(named: "stand1.png")
        easyCat.addSubview(easyCatSub)
        easyCat.addSubview(easyLabel)
        normalCat.addSubview(normalLabel)
        hardCat.addSubview(hardLabel)
        backCat.addSubview(backCatSub)
        backCat.addSubview(backLabel)
        rankingCat.addSubview(rankingLabel)
        
        easyButton.addSubview(easyCat)
        easyButton.addTarget(self, action: #selector(SelectView.easy), for: .touchUpInside)
        normalButton.addSubview(normalCat)
        normalButton.addTarget(self, action: #selector(SelectView.normal), for: .touchUpInside)
        hardButton.addSubview(hardCat)
        hardButton.addTarget(self, action: #selector(SelectView.hard), for: .touchUpInside)
        backButton.addSubview(backCat)
        backButton.addTarget(self, action: #selector(SelectView.back), for: .touchUpInside)
        rankingButton.addSubview(rankingCat)
        rankingButton.addTarget(self, action: #selector(SelectView.ranking), for: .touchUpInside)
        view.addSubview(easyButton)
        view.addSubview(normalButton)
        view.addSubview(hardButton)
        view.addSubview(backButton)
        view.addSubview(rankingButton)
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
        var wallPaper = UIImage(named: "select.png")
        let resizedSize = CGSize(width: sS.width*1.2, height: sS.height*1.2)
        UIGraphicsBeginImageContext(resizedSize)
        wallPaper!.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        wallPaper! = resizeImage!
        let cropRect = CGRect(x: sS.width/10.5, y: sS.height/12, width: sS.width, height: sS.height)
        let cropRef = wallPaper!.cgImage?.cropping(to: cropRect)
        wallPaper = UIImage(cgImage: cropRef!)
        let wpView = UIImageView(image: wallPaper)
        wpView.frame = CGRect(x: 0, y: 0, width: sS.width, height: sS.height)
        view.addSubview(wpView)
        view.sendSubview(toBack: wpView)
    }
    
    func showBanner(){
            banner.adUnitID = "ca-app-pub-4139998452148591/4941710868"
            banner.rootViewController = self
            let request:GADRequest = GADRequest()
            banner.load(request)
    }
    func first(){
        if config.value(forKey: "selectFirst") as! Bool{
            config.set("false", forKey: "selectFirst")
            config.synchronize()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scale = loadScale()
        catSize = 100 * scale
        loadWallpaper()
        createButton()
        showBanner()
    }
    override func viewWillAppear(_ animated: Bool) {
        if config.value(forKey: "selectFirst") as! Bool{
            config.set(false, forKey: "selectFirst")
            config.synchronize()
            performSegue(withIdentifier: "toT1", sender: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
