//
//  Score.swift
//  NekoTest
//
//  Created by naoya uchisawa on 2016/07/07.
//  Copyright © 2016年 NaoyaUchisawa. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
class Score: Object{
    dynamic var time = 0.0
    dynamic var rank = 0
    dynamic var date:String = ""
    override static func primaryKey() -> String? {
        return "date"
    }
}