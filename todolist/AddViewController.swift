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
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var addTextField: FormTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        addTextField.becomeFirstResponder()
        addTextField.delegate = self
    }
    @IBAction func textFieldDidChange(sender: AnyObject) {
        checkValidTodoItem()
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
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if !(addTextField.text ?? "").isEmpty {
            delegate?.addedTodo(addTextField.text!, detail: "")
            self.dismissViewControllerAnimated(true, completion: nil)
            return true
        } else {
            return false
        }
    }
    func checkValidTodoItem() {
        let text = addTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
}
