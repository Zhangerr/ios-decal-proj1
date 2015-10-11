//
//  ViewController.swift
//  todolist
//
//  Created by Alex Zhang on 10/5/15.
//  Copyright © 2015 Alex Zhang. All rights reserved.
//

import UIKit
import Foundation

protocol TodoDelegate {
    func addedTodo(info:String, detail:String)
    func getTodo() -> [TodoItem]
    func synchronize()
    func removeExpired()
}
//extremely inefficient since saving all the todos when just modifying one or adding a new one
//would be better with coredata cause probably can just update one record only easily
//alternative could be separate files or separate keys in userdefaults for each todo and add logic for loading and writing those
//individually when modifying a single todo. then also need to handle deletion though. generate uid? increment counter or what.. maybe use hash of timestamp + content
class TodoListViewController: UITableViewController, TodoDelegate {
    //eventually convert this to use a swift array instead, and follow how the meal tracker does unwind to modify the array that's only referenced in the main view controller
    //maybe move the stuff in statviewcontroller that modifies the array into here instead??
    var todoItems:[TodoItem] = [TodoItem]()
    func saveTodos() {
        print("saving todos...")
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(todoItems, toFile: TodoItem.ArchiveURL.path!)
        
        if !isSuccessfulSave {
            print("Failed to save todo...")
        }
    }
    
    func loadTodos() -> [TodoItem]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(TodoItem.ArchiveURL.path!) as? [TodoItem]
    }
    
    func addedTodo(info: String, detail: String) {
        todoItems.append(TodoItem(item: info, detail: detail))
//        let userDefaults = NSUserDefaults.standardUserDefaults();
        
  //      userDefaults.setObject(todoItems, forKey: "ListData");
    //    userDefaults.synchronize();
        saveTodos()
        self.tableView.reloadData();
    }
    func getTodo() -> [TodoItem] {
        return todoItems
    }
    func synchronize() {
        self.tableView.reloadData()
    }
    func removeExpired() {
        let oldlen = todoItems.count
        todoItems = todoItems.filter({!$0.expired})
        if oldlen != todoItems.count {
            saveTodos()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.allowsMultipleSelectionDuringEditing = false
//         let userDefaults = NSUserDefaults.standardUserDefaults()
//            if let data : AnyObject = userDefaults.objectForKey("ListData") {
//                print(data)
//                todoItems = data as! NSMutableArray
//            }
        if let loadedTodos = loadTodos() {
            todoItems += loadedTodos
            removeExpired()
        }
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(segue.identifier)
        if segue.identifier == "addsegue" {
            let vc = segue.destinationViewController as! AddViewController
            vc.delegate = self
        }
        if segue.identifier == "stats" {
            let vc = segue.destinationViewController as! StatsViewController
            vc.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.

    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
            if editingStyle == UITableViewCellEditingStyle.Delete {
                //todoItems.removeObjectAtIndex(indexPath.row)
                todoItems.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        //cell?.backgroundColor = UIColor.blackColor()
//        cell?.textLabel?.text = "hello world";
  //      cell?.detailTextLabel?.text = "wow";
          //  let cellTitle = cell?.contentView.viewWithTag(1) as! UILabel
        //cellTitle.text = (todoItems.objectAtIndex(indexPath.row) as! TodoItem).item
//        let item = (todoItems.objectAtIndex(indexPath.row) as! TodoItem)
        let item = todoItems[indexPath.row]
        var attributes = [String: AnyObject]()
        if item.completed {
            attributes[NSStrikethroughStyleAttributeName] = 1
            attributes[NSForegroundColorAttributeName] = UIColor.grayColor()
            //  s.attribute([NSStrikethroughStyleAttributeName:1], atIndex: 0, effectiveRange: &range)
        }
        let s = NSAttributedString(string: item.item, attributes: attributes)
        cell?.textLabel?.attributedText = s

        return cell!
        
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      //  let item:TodoItem = todoItems.objectAtIndex(indexPath.row) as! TodoItem
        let item = todoItems[indexPath.row]
        item.completed = !item.completed
        let cell:UITableViewCell = self.tableView.cellForRowAtIndexPath(indexPath)!

//        NSAttributedString(
        //var range = NSMakeRange(0, s.length);
        var attributes = [String: AnyObject]()
        if item.completed {
            attributes[NSStrikethroughStyleAttributeName] = 1
            attributes[NSForegroundColorAttributeName] = UIColor.grayColor()
            item.timestamp = NSDate()
          //  s.attribute([NSStrikethroughStyleAttributeName:1], atIndex: 0, effectiveRange: &range)
        }
        let s = NSAttributedString(string: item.item, attributes: attributes)

        // s.attribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, s.length))
        
//        (cell.viewWithTag(1) as! UILabel).attributedText = s
        cell.textLabel?.attributedText = s
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        saveTodos()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }

}

