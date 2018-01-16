//
//  EntertainmentTableViewController.swift
//  JapanNewsFeed
//
//  Created by Lei Wang on 1/7/18.
//  Copyright © 2018 Lei Wang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EntertainmentTableViewController: UITableViewController {

    var newsFeedArray = [NewsFeed]()
    
    let screenSize = UIScreen.main.bounds
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var defaultRowHeight = 340
    var noPicDefaultHeight = 125
    var count:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "エンタメ・スポーツ"
        self.navigationController?.navigationBar.barStyle = .black
        let navBackgroundImage:UIImage! = UIImage(named: "water-drop-title")
        self.navigationController?.navigationBar.setBackgroundImage(navBackgroundImage,
                                                                    for: .default)
        
        defaultRowHeight = Int(screenWidth * 0.9)
        noPicDefaultHeight = Int(screenWidth * 0.35)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = CGFloat(defaultRowHeight)
        self.tableView.separatorStyle = .singleLine
        retrieveData(numberitems: count * 100)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsFeedArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.newsFeedArray[indexPath.row])
        performSegue(withIdentifier: "ShowEntertainmentSegue", sender: newsFeedArray[indexPath.row].link)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let guest = segue.destination as! ShowDetailViewController
        guest.webURL = sender as! String
    }
    
    func retrieveData(numberitems: Int){
        
        let parameters = ["numberitems": numberitems]
        
        Alamofire.request(Const.GET_MESSAGE_BY_ENTERTAINMENT, method: .post, parameters: parameters).responseJSON { response in
            switch response.result{
            case .success(let data):
                self.newsFeedArray.removeAll()
                let jsonArray = JSON(data)
                
                for(index, dict) in jsonArray{
                    var pub_date = dict["pub_date"].stringValue as String
                    
                    if(pub_date.contains("Mon")){
                        pub_date = pub_date.replacingOccurrences(of: "Mon", with: "月")
                    }else if(pub_date.contains("Tue")) {
                        pub_date = pub_date.replacingOccurrences(of: "Tue", with: "火")
                    }else if(pub_date.contains("Wed")) {
                        pub_date = pub_date.replacingOccurrences(of: "Wed", with: "水")
                    }else if(pub_date.contains("Thu")){
                        pub_date = pub_date.replacingOccurrences(of: "Thu", with: "木")
                    }else if(pub_date.contains("Fri")){
                        pub_date = pub_date.replacingOccurrences(of: "Fri", with: "金")
                    }else if(pub_date.contains("Sat")){
                        pub_date = pub_date.replacingOccurrences(of: "Sat", with: "土")
                    }else if(pub_date.contains("Sun")){
                        pub_date = pub_date.replacingOccurrences(of: "Sun", with: "日")
                    }else{
                        //do nnothing
                    }

                    let thisObject = NewsFeed(id: Int(dict["id"].stringValue), source_name: dict["source_name"].stringValue, channel: dict["channel"].stringValue, title: dict["title"].stringValue, link: dict["link"].stringValue, content: dict["content"].stringValue, has_image: dict["has_image"].boolValue, pub_date: pub_date, image_url: dict["image_url"].stringValue, image_width: Int(dict["image_width"].stringValue), image_height: Int(dict["image_height"].stringValue))
                    self.newsFeedArray.append(thisObject)
                }
                print(self.newsFeedArray.count)
                DispatchQueue.main.async(){
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = newsFeedArray.count - 1
        if(indexPath.row == lastElement){
            count += 1
            retrieveData(numberitems: count * 100)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        retrieveData(numberitems: count * 100)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newsFeed = self.newsFeedArray[indexPath.row]
        
        if(newsFeed.has_image){
            let cell = Bundle.main.loadNibNamed("BigPicTableViewCell", owner: self, options: nil)?.first as! BigPicTableViewCell
            cell.titleLabel?.text = newsFeed.title
            cell.pubDateLabel?.text = newsFeed.pub_date
            cell.sourceLabel?.text = newsFeed.source_name
            
            if let url = URL(string: newsFeed.image_url!) {
                cell.bigPicImage.contentMode = .scaleAspectFit
                downloadImage(url: url, imageView: cell.bigPicImage)
            }
            return cell
        }else{
            let cell = Bundle.main.loadNibNamed("NoPicTableViewCell", owner: self, options: nil)?.first as! NoPicTableViewCell
            cell.sourceLabel?.text = newsFeed.source_name
            cell.titleLabel?.text = newsFeed.title
            cell.pubDateLabel?.text = newsFeed.pub_date
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let newsFeed = self.newsFeedArray[indexPath.row]
        if(newsFeed.has_image){
            let height = newsFeed.image_height as Int
            
            if(height != 0){
                if((height + 100) > defaultRowHeight){
                    return CGFloat(defaultRowHeight)
                }else{
                    return CGFloat(height + 100)
                }
            }else{
                return CGFloat(noPicDefaultHeight)
            }
        }else{
            print(newsFeed.title)
            return CGFloat(noPicDefaultHeight)
        }
    }
    
    
    func downloadImage(url: URL, imageView: UIImageView) {
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() {
                imageView.image = UIImage(data: data)
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
}
