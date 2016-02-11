//
//  ViewController.swift
//  HealthKitUpdater
//
//  Created by Maciek Rylko on 10.01.2016.
//  Copyright © 2016 Maciek Rylko. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var fatTextField: UITextField!
    @IBOutlet weak var muscleTextField: UITextField!
    @IBOutlet weak var bmiTextField: UITextField!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var uiActivityIndicator: UIActivityIndicatorView!
    
    private var textFields : [UITextField!] = []
    private let entitlementsProvider = HealthKitEntitlementsProvider()
    private let activityView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        pushTextFieldsToArray()
        pinUpDelegates()
        
        toggleDoneButtonAvailability()
        
        entitlementsProvider.authorizeHealthKit(nil)
        
        initializeUIActivityView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pinUpDelegates() {
        for field in textFields {
            field!.delegate = self
        }
    }
    
    func normalize(value : Double) -> Double {
        return value / 100
    }
    
    func initializeUIActivityView() {
        uiActivityIndicator.startAnimating()
        self.view.insertSubview(loadingView, aboveSubview: self.view)
    }
    
    func displayCompletion(success: Bool, error: NSError!) {
        
        var title = "Fine!"
        var message = "Everything is ok!"
        
        if (!success) {
            title = "Ooops!"
            message = "\(error)"
        }
        
        let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "Ok!")
        alert.show()
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    }
    
    @IBAction func onDoneTouched(sender: AnyObject) {
        
        activityView.startAnimating()
        //activityView.stopAnimating()
//        activityView.stopAnimating()
        return
        
        let weight = Double(weightTextField.text!)!
        let fat = normalize(Double(fatTextField.text!)!)
        let muscle = weight * normalize(Double(muscleTextField.text!)!)
        let bmi = Double(bmiTextField.text!.stringByReplacingOccurrencesOfString(",", withString: "."))!
        
        entitlementsProvider.update(weight * 1000, fat: fat, muscle: muscle * 1000, bmi: bmi, completion: displayCompletion)
        
    }
    
    func toggleDoneButtonAvailability() {
        doneButton.enabled =  true //doFieldsFulfill()
    }
    
    func doFieldsFulfill() -> Bool {
        for field in textFields {
            if let numericValue = Double(field.text!.stringByReplacingOccurrencesOfString(",", withString: ".")) {
                if (numericValue <= 0 || numericValue >= 100) {
                    return false
                }
            }
            else {
                return false
            }
        }
        
        return true
    }

    func textFieldDidEndEditing(textField: UITextField) {
        toggleDoneButtonAvailability()
    }
    
    func pushTextFieldsToArray() {
        textFields = [weightTextField, fatTextField, muscleTextField, bmiTextField]
    }
}

