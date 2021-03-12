//
//  ShoesAPI.swift
//  TeamProject
//
//  Created by 홍화형 on 2021/01/21.
//

import Foundation

struct Shoes: Codable {
    var brand: String?
    var discountPrice: Int?
    var img: String?
    var like: Bool?
    var name: String?
    var originPrice: Int?
    var rank: Int?
    var src: String?
    
    init(brand:String?, discountPrice:Int?, img:String?, like:Bool?, name: String?, originPrice:Int?, rank:Int?, src:String?) {
        self.brand = brand
        self.discountPrice = discountPrice
        self.img = img
        self.like = like
        self.name = name
        self.originPrice = originPrice
        self.rank = rank
        self.src = src
    }
}

//struct Nike: Codable {
//    var brand: String?
//    var discountPrice: Int?
//    var img: String?
//    var like: Bool?
//    var name: String?
//    var originPrice: Int?
//    var rank: Int?
//    var src: String?
//
//    init(brand:String?, discountPrice:Int?, img:String?, like:Bool?, name: String?, originPrice:Int?, rank:Int?, src:String?) {
//        self.brand = brand
//        self.discountPrice = discountPrice
//        self.img = img
//        self.like = like
//        self.name = name
//        self.originPrice = originPrice
//        self.rank = rank
//        self.src = src
//    }
//}
//
//struct Newbalance: Codable {
//    var brand: String?
//    var discountPrice: Int?
//    var img: String?
//    var like: Bool?
//    var name: String?
//    var originPrice: Int?
//    var rank: Int?
//    var src: String?
//
//    init(brand:String?, discountPrice:Int?, img:String?, like:Bool?, name: String?, originPrice:Int?, rank:Int?, src:String?) {
//        self.brand = brand
//        self.discountPrice = discountPrice
//        self.img = img
//        self.like = like
//        self.name = name
//        self.originPrice = originPrice
//        self.rank = rank
//        self.src = src
//    }
//
//}
