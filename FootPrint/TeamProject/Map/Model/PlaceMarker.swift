//
//  PlaceMarker.swift
//  TeamProject
//
//  Created by 홍화형 on 2021/01/19.
//

import UIKit
import GoogleMaps

class PlaceMarker: GMSMarker {
  let place: GooglePlace
    
  init(place: GooglePlace, availableTypes: [String]) {
    self.place = place
    super.init()
    
    position = place.coordinate
    groundAnchor = CGPoint(x: 0.5, y: 1)
    appearAnimation = .pop
    for type in place.types {
        print(type)
    }
  }
}

class NikePlaceMarker: GMSMarker {
  let place: GooglePlace
    
  init(place: GooglePlace, availableTypes: [String]) {
    self.place = place
    super.init()
    
    position = place.coordinate
    groundAnchor = CGPoint(x: 0.5, y: 1)
    appearAnimation = .pop
    icon = UIImage(named: "nike")
  }
}

class NewbalancePlaceMarker: GMSMarker {
  let place: GooglePlace
    
  init(place: GooglePlace, availableTypes: [String]) {
    self.place = place
    super.init()
    
    position = place.coordinate
    groundAnchor = CGPoint(x: 0.5, y: 1)
    appearAnimation = .pop
    icon = UIImage(named: "newbalance")
  }
}
