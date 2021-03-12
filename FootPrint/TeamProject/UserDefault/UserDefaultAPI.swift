//
//  UserDefaultAPI.swift
//  TeamProject
//
//  Created by 홍화형 on 2021/01/22.
//

import Foundation


struct FootSize: Codable {
    var length: Double?
    var width: Double?
    var recommendSize: Int?
    
    init(length:Double?, width:Double?, recommendSize: Int?) {
        self.length = length
        self.width = width
        self.recommendSize = recommendSize
    }
}
