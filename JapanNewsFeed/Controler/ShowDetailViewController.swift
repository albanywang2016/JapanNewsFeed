//
//  ShowDetailViewController.swift
//  JapanNewsFeed
//
//  Created by Lei Wang on 1/6/18.
//  Copyright © 2018 Lei Wang. All rights reserved.
//

import UIKit
import Alamofire

class ShowDetailViewController: UIViewController {

    @IBOutlet weak var myWebView: UIWebView!
    var webURL = "" as String
    var spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var loadingView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(webURL)
        loadWebPage()
    }
    
    func loadWebPage(){
        showActivityIndicator()
        let url = URL(string: webURL)
        if let unwrappedURL = url{
            let request = URLRequest(url: unwrappedURL)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (data, response, error) in
                if(error == nil){
                    self.myWebView.loadRequest(request)
                    self.hideActivityIndicator()
                }else{
                    print("Error: \(error)")
                }
            }
            task.resume()
        }
    }

    
    func showActivityIndicator() {
        DispatchQueue.main.async() {
            self.loadingView = UIView()
            self.loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
            self.loadingView.center = self.view.center
            self.loadingView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)  
            self.loadingView.alpha = 0.7
            self.loadingView.clipsToBounds = true
            self.loadingView.layer.cornerRadius = 10

            //self.spinner = UIActivityIndicatorView(activityIndicatorStyle: .blueLarge)
            self.spinner.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
            self.spinner.center = CGPoint(x:self.loadingView.bounds.size.width / 2, y:self.loadingView.bounds.size.height / 2)

            self.loadingView.addSubview(self.spinner)
            self.view.addSubview(self.loadingView)
            self.spinner.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async() {
            self.spinner.stopAnimating()
            self.loadingView.removeFromSuperview()
        }
    }

}
