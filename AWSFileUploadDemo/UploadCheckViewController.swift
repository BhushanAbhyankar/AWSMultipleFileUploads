//
//  UploadCheckViewController.swift
//  AWSFileUploadDemo
//
//  Created by Abhyankar Bhushan on 28/10/20.
//

import UIKit
import WebKit

class UploadCheckViewController: UIViewController,WKUIDelegate {

    var wkWebView: WKWebView!
    var originalSiteUrl:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let webConfiguration = WKWebViewConfiguration()
        wkWebView = WKWebView(frame: CGRect.init(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height-64), configuration: webConfiguration)
        wkWebView.uiDelegate = self
        self.view.addSubview(wkWebView)
        loadUrlIntoWebView()
    }
    func loadUrlIntoWebView()  {
        let url = URL.init(string: originalSiteUrl)
            DispatchQueue.main.async {
                let request = URLRequest(url: url ?? URL(string:"")!)
                self.wkWebView.load(request)
                // add activity
            }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
