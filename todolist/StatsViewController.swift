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
        //http://stackoverflow.com/questions/11969452/viewdidload-is-in-fact-called-every-time-there-is-a-segue-transition
        let todos = (delegate?.getTodo())!
        let completed = todos.filter({$0.completed})
        statsLabel.text = "\(completed.count)"
        taskLabel.text = completed.count == 1 ? "task" : "tasks"
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
