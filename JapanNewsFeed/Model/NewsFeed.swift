//
//  NewsFeed2.swift
//  JapanNewsFeed
//
//  Created by Lei Wang on 12/31/17.
//  Copyright © 2017 Lei Wang. All rights reserved.
//

import UIKit

struct NewsFeed {
    let id: Int?
    let source_name: String
    let channel: String
    let title: String
    let link: String
    let content: String?
    var has_image: Bool
    let pub_date: String
    let image_url: String?
    let image_width: Int?
    let image_height: Int!
}
