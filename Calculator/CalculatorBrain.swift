//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by DevStuff on 2016-11-21.
//  Copyright © 2016 DevStuff. All rights reserved.
//


// One big thing to note here is that since this is a model file
// We are automatically importing Foundation, this is because the model
// is UI independent, if we are importing UIKit and this is a model file then
// we are doing something really really wrong

import Foundation

class CalculatorBrain {
    
    // Accumulate the results up to a point in time
    private var accumulator  = 0.0
    
    
    func setOperand(operand: Double) {
        accumulator = operand
        description = String(operand)
    }
    
    // #2 
    // Here we are storing all of the potential operations our calculator 
    // can do in a dictionary and we are classifying all of those operations 
    // according to the values in the Operation enum type
    // so there can in theory be a tonne of operations but they will all slot 
    // into one of our four enum types. 
    // We store the values in our dictionary via the button title which is a string 
    // and the enum Operation type
    //
    // Based on the associated values from #1 
    // For .Constant we just have to supply the variables that evaluate to that double
    // For .UnaryOperation we have to from #1 we have to provide a function that takes 
    // a Double and returns a double, with square root we provide the function square root
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "±" : Operation.UnaryOperation({ -$0 }),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "sin" : Operation.UnaryOperation(sin),
        "tan" : Operation.UnaryOperation(tan),
        "+" : Operation.BinaryOperation( { $0 + $1 }),
        "−" : Operation.BinaryOperation( { $0 - $1 }),
        "×" : Operation.BinaryOperation( { $0 * $1 }),
        "÷" : Operation.BinaryOperation( { $0 / $1 }),
        "=" : Operation.Equals
    ]
    
    
    // #1: START HERE
    // This is pretty much the start of, at least in my eyes, some 
    // fairly complex mind moulding stuff
    // Below we are just classifying all of the operations that our 
    // calculalor can do into four cases 
    // ie Constant: π = 3.14....
    //    Uniary operation: sin(50) = .....
    //    Binary operation: 2 + 3
    //    Equals: =
    // Also we are using assocaited values here regarding the types 
    // So Constant is of type Double 
    // Also not that in Swift a function is a type, just like an Int, Double, etc
    // So we can pass functions around just like regular variables
    // In the case of UnaryOperation its' associated value is a function that takes
    // a Double and returns a Double
    
    private enum Operation {
        case Constant (Double)
        case UnaryOperation ((Double) -> Double)
        case BinaryOperation ((Double, Double) -> Double)
        case Equals
    }
    
    // #3 
    // Ok we now have the reslts but they are stored in #2, 
    // for example π has the value 3.14.....
    // So the issue now is how to get it out 
    // We do this by creating a local value right after the case value
    // ex. case .Constant (let value): accumulatory = value
    // value essentially attaches itself to the associated value from #2
    // Now we can use value just as a regular variable
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol]{
            description = symbol
            switch operation {
            case .Constant (let value) :
                accumulator = value
            case .UnaryOperation (let function) :
                accumulator = function(accumulator)
            case .BinaryOperation (let function):
                executePendingBinaryOperation()
                pending = pendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
        
    }
    
    private func executePendingBinaryOperation(){
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    // Why is the variable below an optional?
    // The variable pending with only exist if there is an pending Binary Operation
    // If the user hasn't typed one of the binary operations then this won't exist
    private var pending: pendingBinaryOperationInfo?
    
    private struct pendingBinaryOperationInfo {
        var binaryFunction: ((Double, Double) -> Double)
        var firstOperand: Double
    }
    
    
    // Example of read only property
    // Since we are only implementing the get but not the set
    var result:Double {
        get {
            return accumulator
        }
    }
    
    
    var isPartialResult: Bool {
        get {
            if pending == nil {
                return false
            }
            else {
                return true
            }
        }
    }
    
    
    private var desc = ""
    var description: String{
        get {
            return desc
        }
        set {
            if newValue == " " {
                desc = " "
            }
            else {
                if newValue != "=" {
                    desc = description + newValue
                }
            }
        }
    }
}