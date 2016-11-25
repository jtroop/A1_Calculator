//
//  ViewController.swift
//  Calculator
//
//  Created by DevStuff on 2016-11-21.
//  Copyright © 2016 DevStuff. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    private var userIsInTheMiddleOfTyping = false
    @IBOutlet private weak var history: UILabel!
    
    
    //  This method just deals with numbers and decimals
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if (display.text!.rangeOfString(".") != nil && digit == "." ) {
            return
        }
        setHistory = brain.description
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text
            display.text = textCurrentlyInDisplay! + digit
        }
        else {
            display.text = digit
            
        }
        userIsInTheMiddleOfTyping = true
        
    }
    
    // What we are doing in the below declarations is
    // we are allowing the controller to talk to the model 
    // remember that the controller has unlimited access to 
    // the model and all of its public methods
    // and this provides that access.
    private var brain = CalculatorBrain()
    
    // Below is all we need to hook our model (CalculatorBrain) 
    // up to our model (This class) 
    @IBAction private func performOperation(sender: UIButton) {

        var status = ""
        
        if userIsInTheMiddleOfTyping{
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
            
            if mathematicalSymbol == "=" { status = "=" }
            else {status = "..."}
        }
        displayValue = brain.result
        setHistory = brain.description + status
    }
    
    
    @IBAction func ClearButton(sender: UIButton) {
        displayValue = 0
        brain.description = " "
        history.text = " "

    }
    
    // Example of computed property
    private var displayValue: Double{
        get {
            // This is returning an optional double instead of a regular double
            // So because this is an optional double we have to unwrap it
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    private var setHistory: String {
        get {
            return history.text!
        }
        set{
            history.text = newValue
        }
    }
    
}