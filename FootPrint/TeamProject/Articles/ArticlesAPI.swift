//
//  NewsAPI.swift
//  TeamProject
//
//  Created by 임정우 on 2021/01/14.
//

import Foundation

struct Articles: Codable {
    var src: String?
    var time: String?
    var img: String?
    var title: String?
    var id: Int?
    
    init(src:String?, time:String?, img:String?, title:String?, id:Int?) {
        self.src = src
        self.time = time
        self.img = img
        self.title = title
        self.id = id
    }
}

