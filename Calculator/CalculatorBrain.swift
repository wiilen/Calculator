//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by LinWiilen on 15/4/17.
//  Copyright (c) 2015年 LinWiilen. All rights reserved.
//

import Foundation

class CalculationBrain {
    
    private enum Op
    {
        case Operand(Double)
        case UnaryOperation(String,Double->Double)
        case BinaryOperation(String,(Double,Double)->Double)
        
        var description:String{
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symble, _):
                    return symble
                case .BinaryOperation(let symble, _):
                    return symble
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps=[String:Op]()
    
    init(){
        knownOps["×"]=Op.BinaryOperation("×",*)
        knownOps["÷"]=Op.BinaryOperation("÷"){$1 / $0}
        knownOps["+"]=Op.BinaryOperation("+",+)
        knownOps["−"]=Op.BinaryOperation("−"){$1 - $0}
        knownOps["√"]=Op.UnaryOperation("√", sqrt)
    }
    
    var programe:AnyObject{
        get {
            return opStack.map{ $0.description }
        }
        set {
            if let opSymbles = newValue as? Array<String> {
                var newOpStack = [Op]()
                for opSymble in opSymbles{
                    if let op = knownOps[opSymble]{
                        newOpStack.append(op)
                    } else if let operand = NSNumberFormatter().numberFromString(opSymble)?.doubleValue {
                        newOpStack.append(.Operand(operand))
                    }
                }
            }
        }
    }
    
    private func evaluate(ops:[Op]) -> (result: Double?,remainingOps: [Op]){
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op{
            case .Operand(let operand):
                return (operand,remainingOps)
            
            case .UnaryOperation(_,let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result{
                    return (operation(operand),operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result{
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                        return (operation(operand1,operand2),op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil,ops)
    }
    
    func evaluate() -> Double? {
        let (result,remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over ")
        return result
    }
    
    func clear(){
        opStack=[Op]()
    }
    
    func pushOperand(operand:Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symble:String)->Double?{
        if let operation = knownOps[symble] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
}