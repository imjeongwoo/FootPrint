//
//  CLLocationCoordinate+Extension.swift
//  TeamProject
//
//  Created by 홍화형 on 2021/01/19.
//

import CoreLocation

extension CLLocationCoordinate2D: CustomStringConvertible {
  public var description: String {
    let lat = String(format: "%.6f", latitude)
    let lng = String(format: "%.6f", longitude)
    return "\(lat),\(lng)"
  }
}
