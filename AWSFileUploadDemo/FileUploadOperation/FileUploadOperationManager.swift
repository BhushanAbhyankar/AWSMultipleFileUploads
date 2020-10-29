//
//  FileUploadOperationManager.swift
//  AWSFileUploadDemo
//
//  Created by Abhyankar Bhushan on 29/10/20.
//

import UIKit
let NSOPERAITON_COUNT_KEY = "operationCount"

class FileUploadOperationManager: NSObject {
    private var syncQueue: OperationQueue = OperationQueue()
    static let sharedInstance = FileUploadOperationManager()
    
    override init() {
        super.init()
        syncQueue.maxConcurrentOperationCount = 1 // Configured as per server requirements
      //  syncQueue.addObserver(self, forKeyPath: NSOPERAITON_COUNT_KEY, options: NSKeyValueObservingOptions.new, context: nil)
        
    }
    
    deinit {
       // syncQueue.removeObserver(self, forKeyPath: NSOPERAITON_COUNT_KEY)
        syncQueue.cancelAllOperations()
    }
    

    func addOperation(operation : Operation ){
        syncQueue.addOperation(operation)
    }
    
}
