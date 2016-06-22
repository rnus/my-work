//
//  SelectView.swift
//  NekoTest
//
//  Created by NU on 2016/06/14.
//  Copyright © 2016年 NaoyaUchisawa. All rights reserved.
//

import Foundation
import UIKit

class SelectView:UIViewController{
    var difficulty = 0
    @IBAction func setting(sender: AnyObject) {
    }
    @IBAction func hard(sender: AnyObject) {
        difficulty = 2
        performSegueWithIdentifier("toGame", sender: nil)
    }
    @IBAction func normal(sender: AnyObject) {
        difficulty = 1
        performSegueWithIdentifier("toGame", sender: nil)
    }
    @IBAction func easy(sender: AnyObject) {
        difficulty = 0
        performSegueWithIdentifier("toGame", sender: nil)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! GameViewController
        vc.difficulty = self.difficulty
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}