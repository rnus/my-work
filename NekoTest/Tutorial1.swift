//
//  Tutorial1.swift
//  NekoTest
//
//  Created by naoya uchisawa on 2016/07/28.
//  Copyright © 2016年 NaoyaUchisawa. All rights reserved.
//

import Foundation
import UIKit

class Tutorial1:UIViewController{
    let sS = UIScreen.main.bounds.size
    var scale: CGFloat = 1.0
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
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
        let frame1 = CGRect(x: 20, y: 290, width: sS.width, height: 30)
        let description1 = ExtendedLabel(frame: frame1)
        let frame2 = CGRect(x: 20, y: 100, width: sS.width, height: 30)
        let description2 = ExtendedLabel(frame: frame2)
        let frame3 = CGRect(x: 20, y: 130, width: sS.width, height: 30)
        let description3 = ExtendedLabel(frame: frame3)
        let frame4 = CGRect(x: 20, y: 160, width: sS.width, height: 30)
        let description4 = ExtendedLabel(frame: frame4)
        let frame5 = CGRect(x: 20, y: 190, width: sS.width, height: 30)
        let description5 = ExtendedLabel(frame: frame5)
        let frame6 = CGRect(x: 20, y: 220, width: sS.width, height: 30)
        let description6 = ExtendedLabel(frame: frame6)
        let frame7 = CGRect(x: 20, y: 500, width: sS.width, height: 30)
        let description7 = ExtendedLabel(frame: frame7)
        let frame8 = CGRect(x: 30, y: 530, width: sS.width, height: 30)
        let description8 = ExtendedLabel(frame: frame8)
        let labels:[ExtendedLabel] = [description1,description2,description3,description4,description5,description6,description7,description8]
        for label in labels{
            label.textColor = UIColor.darkGray
            label.outLineColor = UIColor.white
            label.outLineWidth = 3.0
            label.font = UIFont(name: "RiiTegakiFude", size: 18*scale)
        }
        description1.text = "猫を選ぶとゲーム開始です。"
        description2.text = "１から順番に"
        description3.text = "数字が書いてある猫を"
        description4.text = "タッチしていくゲームです。"
        description5.text = "\"ふつう\"と\"むずかしい\"は画面を"
        description6.text = "左右にスクロールできます。"
        description7.text = "※音が出るので周りの環境に"
        description8.text = "注意してプレイしてください。"
        view.addSubview(description1)
        view.addSubview(description2)
        view.addSubview(description3)
        view.addSubview(description4)
        view.addSubview(description5)
        view.addSubview(description6)
        view.addSubview(description7)
        view.addSubview(description8)
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
        loadWallpaper()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
