//
//  NewsInfo.swift
//  ReignMobileTest
//
//  Created by Sebastian Villahermosa on 26/11/2022.
//

import Foundation

struct NewsInfo: Codable {
    var hits: [Hits]?
    let page: Int?
}

struct Hits: Equatable, Codable {
    let createdAt: String?
    let story_title: String?
    let story_url: String?
    let author: String?
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case story_title
        case story_url
        case author
    }
    
}
