//
//  ViewController.swift
//  Calculator
//
//  Created by LinWiilen on 15/4/7.
//  Copyright (c) 2015年 LinWiilen. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingNumber = false
    
    var brain = CalculationBrain()

    @IBAction func appendDigit(sender: UIButton) {
        

        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingNumber{
            display.text = display.text!+digit
        } else{
            display.text=digit
            userIsInTheMiddleOfTypingNumber=true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingNumber {
            enter()
        }
        if let operation = sender.currentTitle{
            if let result = brain.performOperation(operation){
                displayValue = result
            } else {
                displayValue = nil
            }
        }

        
    }
    
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingNumber=false
  
        if let result = brain.pushOperand(displayValue!){
            displayValue = result
        }
        
    }
    
    @IBAction func clearAll() {
        userIsInTheMiddleOfTypingNumber = false
        brain.clear()
        display.text=" "
    }
    
    
    var displayValue:Double?{
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            if let value = newValue{
                    display.text = "\(value)"
            }
            else{
                clearAll()
            }
            userIsInTheMiddleOfTypingNumber = false
        }
    }
    

}

