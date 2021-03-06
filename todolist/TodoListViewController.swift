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
//individually when modifying a single todo
class TodoListViewController: UITableViewController, TodoDelegate {
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
        if let loadedTodos = loadTodos() {
            todoItems += loadedTodos
            removeExpired()
        }
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
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
                todoItems.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        let item = todoItems[indexPath.row]
        cell?.textLabel?.attributedText = item.getAttributeString()
        if item.completed {
            cell?.backgroundColor = UIColorGrayWhite()
            cell?.contentView.backgroundColor = UIColorGrayWhite()
        } else {
            cell?.backgroundColor = UIColor.whiteColor()
            cell?.contentView.backgroundColor = UIColor.whiteColor()
        }
        return cell!
        
    }
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func UIColorGrayWhite() -> UIColor {
        return UIColorFromRGB(0xeeeeee)
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let item = todoItems[indexPath.row]
        item.completed = !item.completed
        if item.completed {
            item.timestamp = NSDate()
        }
        tableView.reloadData()
        saveTodos()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }

}

