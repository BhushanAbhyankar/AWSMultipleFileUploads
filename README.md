# AWSMultipleFileUploads
This demo project s3explains functionality of uploading files to AWS S3

Upload Images, video, audio, or any type of files to AWS S3 Bucket using Swift.

This demo explains how to use AWS to upload file from yous iOS app.
Here I have used AWS iOS SDK and created an AWSS3TransferUtility class, using this manager class, we will upload any files.

Steps;
1.Setting up Xcode project for uploading.

*Add Cocoapods so that we can access all the services by AWSS3 and Cognito.
*Add the following in the podfile file and save it.

pod 'AWSS3'
pod 'AWSCognito'
pod 'AWSCore'

2.Go to terminal and type pod install and let the Terminal install/update all the pods in the project. once done head back to the project directory. 
  Open the <project_name>.xcworkspace to do any further changes to the project, this is the file we will be working with now.
  
3. Setting up credentials and giving the project access to talk with the S3 bucket.

    a. We will need poolID and buckect which you can get from AWS console of your Amazon account.
    b.In AppDelegate.swift file and add the following function at the end but inside the class.

    func initializeS3() {
            let poolId = "***** your poolId *****"
            let credentialsProvider = AWSCognitoCredentialsProvider(
                regionType: .APSouth1, //other regionType according to your location.
                identityPoolId: poolId
            )
            let configuration = AWSServiceConfiguration(region: .APSouth1, credentialsProvider: credentialsProvider)
            AWSServiceManager.default().defaultServiceConfiguration = configuration
        }
     c.Once done call the function inside didFinishLaunchingWithOptions and call self.initializeS3() before return true.
    This gives a configuration to the AWSServiceManager which sets the region and gives your poolID access to interact further for more services.   

4. Uploading files to AWSS3 using AWSS3TransferUtility:
  
  AWSS3FileUploadManager is the class which will responsible for actutlly uploading files.
  Check the implementaion of this class, it all basic amd simple code of file upload.
  
5.Setting up permissions for Internet access to upload files to AWS S3.
  It is important to give the application Internet access permission or even after building it will give errors and won’t be upload files.
  So in your projects info.plist Add the following code in the file to give it permission, make sure to change the poolID and region according to the bucket set up in previous steps.
   * Add key values to info.plist under NSAppTransportSecurity. AWS section in plist. For refrence check this projects info.plist
   
    
  And that’s It you can now launch your app and start uploading all types of content you want, just make sure to keep the “type” as the extension of the file type you are uploading.
  Call uploadOtherFile from AWSS3FileUploadManager class from your viewcontroller to upload files.
  
  6.For more optimization I have used Operation and OperationQueue here in the demo for serial multiple file uploads.
  Also it shows progress of file uploads in UI.
  
  
