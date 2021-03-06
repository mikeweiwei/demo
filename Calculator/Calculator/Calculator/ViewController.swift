//
//  ViewController.swift
//  Calculator
//
//  Created by tutujiaw on 15/4/25.
//  Copyright (c) 2015年 tutujiaw. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    var sumInMemory: Double = 0.0
    var sumSoFar: Double = 0.0
    var factorSoFar: Double = 0.0
    var pendingAdditiveOperator = ""
    var pendingMultiplicativeOperator = ""
    var waitingForOperand = true
    var isDao:Bool = false
    
    var displayValue: Double {
        set {
            let intValue = Int(newValue)
            if (Double(intValue) == newValue) {
                display.text = "\(intValue)"
            } else {
                display.text = "\(newValue)"
            }
        }
        get {
            return (display.text! as NSString).doubleValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func calculate(rightOperand: Double, pendingOperator: String) -> Bool {
        var result = false
        switch pendingOperator {
            case "+":
            sumSoFar += rightOperand
            result = true
            case "-":
            sumSoFar -= rightOperand
            result = true
            case "*":
            factorSoFar *= rightOperand
            result = true
            case "/":
            if rightOperand != 0.0 {
                factorSoFar /= rightOperand
                result = true
            }
        default:
            break
        }
        return result
     }
    
    func abortOperation() {
        clearAll()
         display.text = "####"
        
    }
    
    @IBOutlet weak var dot: UIButton!
    
    @IBAction func dotc(sender: UIButton) {
        if !isDao {
            isDao = true
            display.text = display.text! + sender.currentTitle!
        }
        
    }
    
    @IBAction func digitClicked(sender: UIButton) {
        let digitValue = Int(sender.currentTitle!)
        if Int(display.text!) == 0 && digitValue == 0 {
            return
        }
        
        if waitingForOperand {
            display.text = ""
            waitingForOperand = false
        }
        display.text = display.text! + sender.currentTitle!
    }

    @IBAction func changeSignClicked() {
        displayValue *= -1
    }
    
    @IBAction func backspaceClicked() {
        if waitingForOperand {
            return
        }
        
        let strValue = display.text!
        display.text = String(strValue.characters.dropLast())
        if display.text!.isEmpty {
            displayValue = 0.0
            waitingForOperand = true
        }
    }
    
    @IBAction func clear() {
        if waitingForOperand {
            return
        }
        
        displayValue = 0
        waitingForOperand = true
        isDao = false
    }
    
    @IBAction func clearAll() {
        sumSoFar = 0.0
        factorSoFar = 0.0
        sumInMemory = 0.0
        pendingAdditiveOperator = ""
        pendingMultiplicativeOperator = ""
        displayValue = 0.0
        waitingForOperand = true
        isDao = false
    }
    
    @IBAction func clearMemory() {
        sumInMemory = 0.0
    }
    
    @IBAction func readMemory() {
        displayValue = sumInMemory
        //waitingForOperand = true
        waitingForOperand = false

    }
    
    @IBAction func setMemory() {
        equalClicked()
        sumInMemory = displayValue
        waitingForOperand = false
    }
    
    @IBAction func addToMemory() {
        equalClicked()
        sumInMemory += displayValue
        waitingForOperand = false
    }
    
    @IBAction func multiplicativeOperatorClicked(sender: UIButton) {
        let clickedOperator = sender.currentTitle!
        let operand = displayValue
        if !pendingMultiplicativeOperator.isEmpty {
            if !calculate(operand, pendingOperator: pendingMultiplicativeOperator) {
                abortOperation()
                return
            }
            displayValue = factorSoFar
        } else {
            factorSoFar = operand
        }
        
        pendingMultiplicativeOperator = clickedOperator
        waitingForOperand = true
        isDao = false

    }
    
    @IBAction func additiveOperatorClicked(sender: UIButton) {
        let clickedOperator = sender.currentTitle!
        let operand = displayValue
        if !pendingMultiplicativeOperator.isEmpty {
            if !calculate(operand, pendingOperator: pendingMultiplicativeOperator) {
                abortOperation()
                return
            }
            displayValue = factorSoFar
            factorSoFar = 0.0
            pendingMultiplicativeOperator = ""
        }
        
        if !pendingAdditiveOperator.isEmpty {
            if !calculate(operand, pendingOperator: pendingAdditiveOperator) {
                abortOperation()
                return
            }
            displayValue = sumSoFar
        } else {
            sumSoFar = operand
        }
        
        pendingAdditiveOperator = clickedOperator
        waitingForOperand = true

    }
    
    @IBAction func unaryOperatorClicked(sender: UIButton) {
        let clickedOperator = sender.currentTitle!
        var result: Double = 0
        
        if clickedOperator == "Sqrt" {
            if displayValue < 0 {
                abortOperation()
                return
            }
            result = sqrt(displayValue)
        } else if clickedOperator == "x^2" {
            result = pow(displayValue, 2)
        } else if clickedOperator == "1/x" {
            if displayValue == 0 {
                abortOperation()
                return
            }
            result = 1.0 / displayValue
        }
        displayValue = result
        waitingForOperand = false
    }
    
    @IBAction func equalClicked() {
        var operand = displayValue
        if !pendingMultiplicativeOperator.isEmpty {
            if !calculate(operand, pendingOperator: pendingMultiplicativeOperator) {
                abortOperation()
                return
            }
            operand = factorSoFar
            factorSoFar = 0.0
            pendingMultiplicativeOperator = ""
        }
        
        if !pendingAdditiveOperator.isEmpty {
            if !calculate(operand, pendingOperator: pendingAdditiveOperator) {
                abortOperation()
                return
            }
            pendingAdditiveOperator = ""
        } else {
            sumSoFar = operand
        }
        
        displayValue = sumSoFar
        sumSoFar = 0.0
        waitingForOperand = false
    }
}

