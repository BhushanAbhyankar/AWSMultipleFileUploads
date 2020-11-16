//
//  FileUploadOperation.swift
//  AWSFileUploadDemo
//
//  Created by Abhyankar Bhushan on 29/10/20.
//

import Foundation

class UploadNetworkOperation: BaseOperation {
    typealias completionBlock = (_ response: Any?, _ error: Error?) -> Void

    fileprivate var uploadPath: URL
    let progress = Progress(totalUnitCount: 1)
    let completion : completionBlock?
    
    init(uploadPath:URL,completion:completionBlock?) {
        self.uploadPath = uploadPath
        self.completion = completion
    }
    
    override func start() {
        
        if(self.isCancelled) {
            self.finish()
            return
        }
        
        uploadFileToS3()
        
    }
    
    override func cancel() {
        self.cancel()
        self.finish()
    }
}
private extension UploadNetworkOperation {
    
    func uploadFileToS3()  {

        let type: String = uploadPath.lastPathComponent.components(separatedBy: ".").last ?? "" //""jpeg"

        let fileUrlMain = URL.init(fileURLWithPath: uploadPath.relativePath)
        AWSS3FileUploadManager.shared.uploadOtherFile(fileUrl: fileUrlMain, conentType: type, progress: { [weak self] (progress) in
            let aStr = String(format: "Completed : %.0f %", Float(progress)*100)
            print(aStr)

        }, completion: { [weak self] (uploadedFileUrl, error) in
            guard let strongSelf = self else { return }
            if(strongSelf.isCancelled) {
                strongSelf.finish()
                return
            }
            
            if (error != nil) {
                print("\(String(describing: error?.localizedDescription))")
                if let completionBlock = strongSelf.completion {
                    completionBlock(uploadedFileUrl, error)
                }
                self?.cancel()
            }else{
                if let finalPath = uploadedFileUrl as? String {
                    print(finalPath)
                    if let completionBlock = strongSelf.completion {
                        completionBlock(uploadedFileUrl, error)
                    }
                    self?.finish()
                } else {
                    if let completionBlock = strongSelf.completion {
                        completionBlock(uploadedFileUrl, error)
                    }
                    print("\(String(describing: error?.localizedDescription))")
                    self?.cancel()
                }
            }
        })
    }
    
}
