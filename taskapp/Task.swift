//
//  Task.swift
//  taskapp
//
//  Created by tetsuro miyagawa on 2018/08/21.
//  Copyright © 2018年 tetsuro miyagawa. All rights reserved.
//

import RealmSwift

class Task: Object {
    
    @objc dynamic var id = 0
    
    @objc dynamic var title = ""
    
    @objc dynamic var contents = ""
    
    @objc dynamic var date = Date()
    
    @objc dynamic var category = ""
    
    override static func primaryKey() -> String? {
        
        return "id"
    }
    
    
}
