//
//  AddViewController.swift
//  todolist
//
//  Created by Alex Zhang on 10/5/15.
//  Copyright © 2015 Alex Zhang. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class FormTextField: UITextField {
    
    @IBInspectable var inset: CGFloat = 0
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, inset, inset)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }
    
}

class AddViewController : UIViewController, UITextFieldDelegate {
  
    var delegate:TodoDelegate?;
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBAction func addButtonAction(sender: AnyObject) {
        delegate?.addedTodo(addTextField.text!, detail: "")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func backButtonAction(sender: AnyObject) {
        //self.navigationController?.popViewControllerAnimated(true)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var addTextField: FormTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        //addTextField.layer.cornerRadius = -1.0;
//        let border = CALayer()
//        let width = CGFloat(2.0)
//        border.borderColor = UIColor.darkGrayColor().CGColor
//        border.frame = CGRect(x: 0, y: addTextField.frame.size.height - width, width:  addTextField.frame.size.width, height: addTextField.frame.size.height)
//        
//        border.borderWidth = width
//        addTextField.layer.addSublayer(border)
//        addTextField.layer.masksToBounds = true
//        print("hello")
        addTextField.becomeFirstResponder()
        addTextField.delegate = self

//        addTextField.layer.borderColor = UIColor.grayColor().CGColor

        
    }
    override func viewDidLayoutSubviews() {
                addTextField.borderStyle = UITextBorderStyle.None
        let textField = addTextField
        let bottomBorder = CALayer();
        let topLayer = CALayer();
        topLayer.frame = CGRectMake(0.0, 0.0, textField.frame.size.width, 1.0);
        bottomBorder.frame = CGRectMake(0.0, textField.frame.size.height - 1, textField.frame.size.width, 1.0);
        bottomBorder.backgroundColor = UIColor.grayColor().CGColor
        topLayer.backgroundColor = UIColor.grayColor().CGColor
       // textField.layer.addSublayer(bottomBorder)
        //textField.layer.addSublayer(topLayer)

    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        delegate?.addedTodo(addTextField.text!, detail: "")
        self.dismissViewControllerAnimated(true, completion: nil)
        return true
    }
    
}
