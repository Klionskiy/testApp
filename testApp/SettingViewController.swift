//
//  ViewController.swift
//  TestApp
//
//  Created by Gosha K on 08.05.17.
//  Copyright © 2017 Gosha K. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var quantityPicker: UIPickerView!
    @IBOutlet weak var minimalQuantity: UITextField!
    @IBOutlet weak var maximumQauntity: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    

    
    var activeField: UITextField?
    
    private var amount = [Int]()
    {
        didSet
        {
            if amount.count > 0
            {
                quantityPicker.isHidden = false
                quantityPicker.reloadComponent(0)
                NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        quantityPicker.isHidden = true
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        minimalQuantity.delegate = self
        maximumQauntity.delegate = self
        quantityPicker.delegate = self
        quantityPicker.dataSource = self

    
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        amount.removeAll()
        if maximumQauntity.hasText && minimalQuantity.hasText
        {
            if Int(maximumQauntity.text!)! > Int(minimalQuantity.text!)!
            {
                for i in 0...Int(maximumQauntity.text!)! - Int(minimalQuantity.text!)!
                {
                    amount.append(Int(minimalQuantity.text!)! + i)
                }
                textField.resignFirstResponder()
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        amount.removeAll()
        if maximumQauntity.hasText && minimalQuantity.hasText
        {
            if Int(maximumQauntity.text!)! > Int(minimalQuantity.text!)!
            {
                for i in 0...Int(maximumQauntity.text!)! - Int(minimalQuantity.text!)!
                {
                    amount.append(Int(minimalQuantity.text!)! + i)
                }
                textField.resignFirstResponder()
            }
        }
    }
    
    func keyboardWillShow(sender: NSNotification)
    {
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
            self.view.frame.origin.y = -keyboardSize.height
        }
    }

    
    func keyboardWillHide(sender: NSNotification)
    {
        self.view.frame.origin.y = 0
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return amount.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return String(amount[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
//        if let tbc = tabBarController as? MainTabBarController
//        {
//            if let controller = tbc.viewControllers?[0] as? ViewDrawerViewController
//            {
//                controller.numberOfViews = amount[row]
//            }
//        }
        SharingManager.number = amount[row] + 1 
    }
    

}


