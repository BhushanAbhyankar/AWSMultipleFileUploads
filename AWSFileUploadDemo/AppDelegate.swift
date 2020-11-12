//
//  AppDelegate.swift
//  AWSFileUploadDemo
//
//  Created by Abhyankar Bhushan on 27/10/20.
//

import UIKit
import AWSS3
@main

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let cognitoPoolID = "ap-south-1:5d993a50-f970-42f4-930e-4ef306c729f0"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.initializeS3() //
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


    //AWS
    func initializeS3() {
            let poolId = cognitoPoolID
            let credentialsProvider = AWSCognitoCredentialsProvider(
                regionType: .APSouth1, //other regionType according to your location.
                identityPoolId: poolId
            )
            let configuration = AWSServiceConfiguration(region: .APSouth1, credentialsProvider: credentialsProvider)
            AWSServiceManager.default().defaultServiceConfiguration = configuration
        }
}

