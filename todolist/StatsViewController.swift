//
//  StatsViewController.swift
//  todolist
//
//  Created by Alex Zhang on 10/5/15.
//  Copyright © 2015 Alex Zhang. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {
    var delegate:TodoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let nav = self.navigationController
//        nav?.title = "hello world"
        // Do any additional setup after loading the view.
//        var count = 0

//        var toRemove = [AnyObject]()
//        for i in todos {
//            let item = i as! TodoItem
//            if item.completed {
//                count++
//                toRemove.append(i)
//            }
//        }
//        for i in toRemove {
//            todos.removeObject(i)
//        }
//http://stackoverflow.com/questions/11969452/viewdidload-is-in-fact-called-every-time-there-is-a-segue-transition
        let todos = (delegate?.getTodo())!
        let completed = todos.filter({$0.completed})
        //        let completedToDelete = todos.filter({$0.expiredTest})
        statsLabel.text = "\(completed.count)"
        taskLabel.text = completed.count == 1 ? "task" : "tasks"
        //        todos.removeObjectsInArray(completedToDelete)
        delegate?.removeExpired()
        delegate?.synchronize()
    }
    //why did this work with viewDidLoad anyway....
    override func viewDidAppear(animated: Bool) {

        super.viewDidLoad()
            let todos = (delegate?.getTodo())!
        let completed = todos.filter({$0.completed})
//        let completedToDelete = todos.filter({$0.expiredTest})
        statsLabel.text = "\(completed.count)"
        taskLabel.text = completed.count == 1 ? "task" : "tasks"
//        todos.removeObjectsInArray(completedToDelete)
        delegate?.removeExpired()
        delegate?.synchronize()
    }
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var statsLabel: UILabel!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
