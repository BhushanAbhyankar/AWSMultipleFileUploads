//
//  FileUploadOperationManager.swift
//  AWSFileUploadDemo
//
//  Created by Abhyankar Bhushan on 29/10/20.
//

import UIKit

class FileUploadOperationManager: NSObject {
    private var syncQueue: OperationQueue = OperationQueue()
    static let sharedInstance = FileUploadOperationManager()
    
    override init() {
        super.init()
        syncQueue.maxConcurrentOperationCount = 1 // Configured as per server requirements
        
    }
    
    deinit {
        syncQueue.cancelAllOperations()
    }
    

    func addOperation(operation : Operation ){
        syncQueue.addOperation(operation)
    }
    
}
