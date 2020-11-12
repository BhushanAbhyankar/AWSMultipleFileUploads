//
//  ViewController.swift
//  AWSFileUploadDemo
//
//  Created by Abhyankar Bhushan on 27/10/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var labelUploadUrl: UILabel!
    @IBOutlet weak var labelProgressPercentage: UILabel!
    
    var uploadedPath = ""
    let kFractionCompletedKeyPath = "fractionCompleted"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.progressView.progress = Float(0.0)
        copyFilesFromBundleToDocumentsFolderWith(fileExtension: ".png")
                copyFilesFromBundleToDocumentsFolderWith(fileExtension: ".rtf")
                copyFilesFromBundleToDocumentsFolderWith(fileExtension: ".png")
                copyFilesFromBundleToDocumentsFolderWith(fileExtension: ".jpg")
                copyFilesFromBundleToDocumentsFolderWith(fileExtension: ".webp")
                copyFilesFromBundleToDocumentsFolderWith(fileExtension: ".jpeg")
    }

    @IBAction func buttonCheckUploadedFile(_ sender: Any) {
        if self.labelUploadUrl.text!.count > 0 {
            checkUploadedFile()
        }
    }
    @IBAction func buttonUploadFiles(_ sender: Any) {
        // Upload files like Text, Zip, etc from local path url

        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])

            // Print the urls of the files contained in the documents directory
            print(directoryContents)
//            uploadFileToS3FromArrayPaths(pathArray: directoryContents)
            uploadFileToS3FromArrayPathsViaOperations(pathArray: directoryContents)
        } catch {
            print("Could not search for urls of files in documents directory: \(error)")
        }

    }
   
    func uploadFileToS3FromArrayPaths(pathArray:Array<URL>)  {
        for path in pathArray {
            let manager = FileManager.default
            if (manager.fileExists(atPath: path.relativePath)) {
                // it's here!!
                uploadFileToS3(uploadPath: path)
            }
        }
    }
    func uploadFileToS3FromArrayPathsViaOperations(pathArray:Array<URL>)  {
        let fileUploadOperationManager = FileUploadOperationManager.sharedInstance
        let totalNOOfOperations:Int = pathArray.count
        let multiPartTotalProgress:Progress = Progress(totalUnitCount: Int64(totalNOOfOperations))

        for path in pathArray {

            let manager = FileManager.default
            if (manager.fileExists(atPath: path.relativePath)) {
                // it's here!!
                var uploadOperations: UploadNetworkOperation!

                uploadOperations = UploadNetworkOperation.init(uploadPath: path, completion: { (uploadedURL, error) in
                    DispatchQueue.main.async(execute: {
                        multiPartTotalProgress.completedUnitCount = multiPartTotalProgress.completedUnitCount + 1

                       let  percentage = Float(multiPartTotalProgress.completedUnitCount) / Float(multiPartTotalProgress.totalUnitCount) * 100
                        let per = percentage/100.0
                        self.progressView.progress = Float(per)
                        
                        let aStr = String(format: "Completed %d Of %d", multiPartTotalProgress.completedUnitCount,multiPartTotalProgress.totalUnitCount)
                        self.labelProgressPercentage.text = aStr
                    })
                })
                multiPartTotalProgress.addChild(uploadOperations.progress, withPendingUnitCount:1)
                fileUploadOperationManager.addOperation(operation: uploadOperations)
            }
        }
    }
    
    func uploadFileToS3(uploadPath:URL)  {
        let type: String = uploadPath.lastPathComponent.components(separatedBy: ".").last ?? "" //""jpeg"

        let fileUrlMain = URL.init(fileURLWithPath: uploadPath.relativePath)
        AWSS3FileUploadManager.shared.uploadOtherFile(fileUrl: fileUrlMain, conentType: type, progress: { [weak self] (progress) in

            guard let strongSelf = self else { return }
            strongSelf.progressView.progress = Float(progress)
            let aStr = String(format: "Completed : %.0f %", strongSelf.progressView.progress*100)
            strongSelf.labelProgressPercentage.text = aStr

        }, completion: { [weak self] (uploadedFileUrl, error) in

            guard let strongSelf = self else { return }
            if let finalPath = uploadedFileUrl as? String {
                self?.uploadedPath  = finalPath
                strongSelf.labelUploadUrl.text = "Uploaded file url: " + finalPath
            } else {
                print("\(String(describing: error?.localizedDescription))")
            }
        })
    }
    
    func checkUploadedFile()  {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UploadCheckViewControllerID") as? UploadCheckViewController {
            viewController.originalSiteUrl =  self.uploadedPath
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
   
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0];
        return documentsDirectory
    }
    
    func copyFilesFromBundleToDocumentsFolderWith(fileExtension: String) {
        if let resPath = Bundle.main.resourcePath {
            do {
                let dirContents = try FileManager.default.contentsOfDirectory(atPath: resPath)
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                let filteredFiles = dirContents.filter{ $0.contains(fileExtension)}
                for fileName in filteredFiles {
                    if let documentsURL = documentsURL {
                        let sourceURL = Bundle.main.bundleURL.appendingPathComponent(fileName)
                        let destURL = documentsURL.appendingPathComponent(fileName)
                        do { try FileManager.default.copyItem(at: sourceURL, to: destURL) } catch { }
                    }
                }
            } catch { }
        }
    }
}

