//
//  BaseOperation.swift
//  AWSFileUploadDemo
//
//  Created by Abhyankar Bhushan on 29/10/20.
//

import Foundation


class BaseOperation : Operation
{
    var _finished = false
    var _executing = false
    
    override init() {
        super.init()
    }
    
    override var isExecuting: Bool {
        get { return _executing }
        set {
            willChangeValue(forKey: "isExecuting")
            _executing = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override var isFinished: Bool {
        get { return _finished }
        set {
            willChangeValue(forKey: "isFinished")
            _finished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override func start() {
        
        isExecuting = true
        isFinished = false
    }
    
    func finish() {
        isExecuting = false
        isFinished = true
    }
}
