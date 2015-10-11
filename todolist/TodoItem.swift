//
//  TodoItem.swift
//  todolist
//
//  Created by Alex Zhang on 10/11/15.
//  Copyright © 2015 Alex Zhang. All rights reserved.
//

import Foundation
 class TodoItem: NSObject, NSCoding {
     var item:String
     var detail:String
     var completed:Bool
     var timestamp:NSDate
    init(item:String, detail:String, completed:Bool = false, timestamp:NSDate = NSDate()) {
        self.item = item
        self.detail = detail
        self.completed = completed
        self.timestamp = timestamp
        
    }
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("todos")
    
    struct PropertyKey {
        static let itemKey = "item"
        static let detailKey = "detail"
        static let completedKey = "completed"
        static let timestampKey = "timestamp"
    }
    var expired: Bool {
        return completed && (timestamp.timeIntervalSinceNow < -(60 * 60 * 24))
    }
    //used for testing purposes instead of expired
    var expiredTest: Bool {
        return completed && (timestamp.timeIntervalSinceNow <  -5)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(item, forKey: PropertyKey.itemKey)
        aCoder.encodeObject(detail, forKey: PropertyKey.detailKey)
        aCoder.encodeBool(completed, forKey: PropertyKey.completedKey)
        aCoder.encodeObject(timestamp, forKey: PropertyKey.timestampKey)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        let item = aDecoder.decodeObjectForKey(PropertyKey.itemKey) as! String
        let detail = aDecoder.decodeObjectForKey(PropertyKey.detailKey) as! String
        let completed = aDecoder.decodeBoolForKey(PropertyKey.completedKey)
        let timestamp = aDecoder.decodeObjectForKey(PropertyKey.timestampKey) as! NSDate
        self.init(item:item, detail:detail, completed:completed, timestamp:timestamp)
    }
}
