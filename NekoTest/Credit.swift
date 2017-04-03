//
//  Credit.swift
//  NekoTest
//
//  Created by naoya uchisawa on 2016/07/19.
//  Copyright © 2016年 NaoyaUchisawa. All rights reserved.
//

import Foundation
import UIKit

class CreditView:UIViewController{
    
    @IBOutlet weak var str1: UILabel!
    @IBOutlet weak var str2: UILabel!
    @IBOutlet weak var str3: UILabel!
    @IBOutlet weak var str4: UILabel!
    @IBOutlet weak var str5: UILabel!
    @IBOutlet weak var str6: UILabel!
    @IBOutlet weak var str7: UILabel!
    @IBOutlet weak var str8: UILabel!
    @IBOutlet weak var str9: UILabel!
    
    @IBAction func apache(_ sender: AnyObject) {
        performSegue(withIdentifier: "toApa", sender: nil)
    }
    @IBAction func back(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    let sS = UIScreen.main.bounds.size
    
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
    func uilabelToExtendedLabel(_ ui: UILabel){
        let ex = ExtendedLabel(frame: ui.frame)
        ex.font = ui.font
        ex.textColor = ui.textColor
        ex.text = ui.text
        ex.outLineColor = UIColor.white
        ex.outLineWidth = 3
        ui.removeFromSuperview()
        view.addSubview(ex)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWallpaper()
        uilabelToExtendedLabel(str1)
        uilabelToExtendedLabel(str2)
        uilabelToExtendedLabel(str3)
        uilabelToExtendedLabel(str4)
        uilabelToExtendedLabel(str5)
        uilabelToExtendedLabel(str6)
        uilabelToExtendedLabel(str7)
        uilabelToExtendedLabel(str8)
        uilabelToExtendedLabel(str9)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
