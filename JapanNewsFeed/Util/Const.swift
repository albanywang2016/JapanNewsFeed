//
//  Const.swift
//  JapanNewsFeed
//
//  Created by Lei Wang on 12/30/17.
//  Copyright © 2017 Lei Wang. All rights reserved.
//

import UIKit

class Const {

    static let GET_MESSAGE_BY_CHANNEL = "http://japannews.tech/php/get_message_by_channel.php"
    static let GET_MESSAGE_BY_NEWS = "http://japannews.tech/php/get_message_by_news.php"
    static let GET_MESSAGE_BY_ENTERTAINMENT = "http://japannews.tech/php/get_message_by_entertainment.php"
    static let GET_MESSAGE_BY_MAGAZINE = "http://japannews.tech/php/get_message_by_magazine.php"
    static let GET_MESSAGE_BY_VIDEO = "http://japannews.tech/php/get_message_by_video.php"
    static let screenSize = UIScreen.main.bounds
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    var pub_date = "" as String
    
    func transformDay(input_date: String) -> String {
        
        print("input_date = \(input_date)")
        if(input_date.contains("Mon")){
            pub_date = input_date.replacingOccurrences(of: "Mon", with: "月")
        }else if(pub_date.contains("Tue")) {
            pub_date = input_date.replacingOccurrences(of: "Tue", with: "火")
        }else if(pub_date.contains("Wed")) {
            pub_date = input_date.replacingOccurrences(of: "Wed", with: "水", options: .regularExpression)
        }else if(pub_date.contains("Thu")){
            pub_date = input_date.replacingOccurrences(of: "Thu", with: "木")
        }else if(pub_date.contains("Fri")){
            pub_date = input_date.replacingOccurrences(of: "Fri", with: "金")
        }else if(pub_date.contains("Sat")){
            pub_date = input_date.replacingOccurrences(of: "Sat", with: "土")
        }else if(pub_date.contains("Sun")){
            pub_date = input_date.replacingOccurrences(of: "Sun", with: "日")
        }else{
            //do nnothing
        }
        print("replaced = \(pub_date)")
        return pub_date
    }
    
}
