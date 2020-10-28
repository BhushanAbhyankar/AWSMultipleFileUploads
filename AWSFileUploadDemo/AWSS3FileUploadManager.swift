//
//  AWSS3FileUploadManager.swift
//  AWSFileUploadDemo
//
//  Created by Abhyankar Bhushan on 27/10/20.
//

import Foundation
import UIKit
import AWSS3 //1

typealias progressBlock = (_ progress: Double) -> Void //2
typealias completionBlock = (_ response: Any?, _ error: Error?) -> Void //3

class AWSS3FileUploadManager {
    
    static let shared = AWSS3FileUploadManager() // 4
    private init () { }
    
    //  let bucketName = "newblogbucket"
        let bucketName = "jd-us01-isg-prod-mobile-upload" //5
    

    // Upload files like Text, Zip, etc from local path url
    func uploadOtherFile(fileUrl: URL, conentType: String, progress: progressBlock?, completion: completionBlock?) {
//      let fileName = self.getUniqueFileName(fileUrl: fileUrl)
        let fileName = fileUrl.lastPathComponent
        self.uploadfile(fileUrl: fileUrl, fileName: fileName, contenType: conentType, progress: progress, completion: completion)
    }
    
    // Get unique file name
    func getUniqueFileName(fileUrl: URL) -> String {
        let strExt: String = "." + (URL(fileURLWithPath: fileUrl.absoluteString).pathExtension)
        return (ProcessInfo.processInfo.globallyUniqueString + (strExt))
    }
    
    //MARK:- AWS file upload
    // fileUrl :  file local path url
    // fileName : name of file, like "myimage.jpeg" "video.mov"
    // contenType: file MIME type
    // progress: file upload progress, value from 0 to 1, 1 for 100% complete
    // completion: completion block when uplaoding is finish, you will get S3 url of upload file here
    private func uploadfile(fileUrl: URL, fileName: String, contenType: String, progress: progressBlock?, completion: completionBlock?) {
        // Upload progress block
        let expression = AWSS3TransferUtilityUploadExpression()

        expression.progressBlock = {(task, awsProgress) in
            guard let uploadProgress = progress else { return }
            DispatchQueue.main.async {
                print(awsProgress.fractionCompleted)   //2
                uploadProgress(awsProgress.fractionCompleted)
            }
        }
        // Completion block
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                if error == nil {
                    let url = AWSS3.default().configuration.endpoint.url
                    let publicURL = url?.appendingPathComponent(self.bucketName).appendingPathComponent(fileName)
                    print("Uploaded to:\(String(describing: publicURL))")
                    if let completionBlock = completion {
                        completionBlock(publicURL?.absoluteString, nil)
                    }
                } else {
                    if let completionBlock = completion {
                        completionBlock(nil, error)
                    }
                }
            })
        }
        // Start uploading using AWSS3TransferUtility
        let awsTransferUtility = AWSS3TransferUtility.default()
        awsTransferUtility.uploadFile(fileUrl, bucket: bucketName, key: fileName, contentType: contenType, expression: expression, completionHandler: completionHandler).continueWith { (task) -> Any? in
            if let error = task.error {
                print("error is: \(error)")
            }
            if let _ = task.result {
                // your uploadTask
                print("Starting upload...")
            }
            return nil
        }
    }
}
