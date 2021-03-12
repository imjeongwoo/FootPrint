//
//  MapViewController.swift
//  TeamProject
//
//  Created by 홍화형 on 2021/01/14.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    @IBOutlet var brandChoiceSegmentedControl: UISegmentedControl!
    @IBOutlet var mapView: GMSMapView!
    private var searchedTypes = ["나이키"]
    private let locationManager = CLLocationManager()
    private let dataProvider = GoogleDataProvider()
    private let dataProviderNike = GoogleDataProvider()
    private let dataProviderNewbalance = GoogleDataProvider()
    private let searchRadius: Double = 5000
    let brandArray = ["나이키", "뉴발란스"]
    var brandArrayIndexNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        mapView.delegate = self
        firstSet(at: locationManager.location?.coordinate)
    }
    
    @IBAction func brandChoiceSegmentedAction(_ sender: Any) {
        if brandChoiceSegmentedControl.selectedSegmentIndex == 0 {
            self.searchedTypes = [brandArray[0]]
            fetchPlacesNike(near: mapView.camera.target)
        }else {
            self.searchedTypes = [brandArray[1]]
            fetchPlacesNewbalance(near: mapView.camera.target)
        }
    }
    
    func firstSet(at coordinate: CLLocationCoordinate2D?) {
        guard let coordinate = coordinate else { return }
        let myCamera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 15.0)
        mapView.camera = myCamera
        brandChoiceSegmentedControl.selectedSegmentIndex = 0 //세그먼트 컨트롤 처음 인덱스 0으로 설정
        fetchPlacesNike(near: (locationManager.location?.coordinate)!)
    }
}

// MARK: - Actions
extension MapViewController {
    
    func fetchPlacesNike(near coordinate: CLLocationCoordinate2D) {
      mapView.clear()
      dataProvider.fetchPlaces(
        near: coordinate,
        radius: searchRadius,
        types: searchedTypes
      ) { places in
        places.forEach { place in
          let marker = NikePlaceMarker(place: place, availableTypes: self.searchedTypes)
          marker.map = self.mapView
        }
      }
    }
    func fetchPlacesNewbalance(near coordinate: CLLocationCoordinate2D) {
      mapView.clear()
      dataProvider.fetchPlaces(
        near: coordinate,
        radius: searchRadius,
        types: searchedTypes
      ) { places in
        places.forEach { place in
          let marker = NewbalancePlaceMarker(place: place, availableTypes: self.searchedTypes)
          marker.map = self.mapView
        }
      }
    }
  
  func reverseGeocode(coordinate: CLLocationCoordinate2D) {
    let geocoder = GMSGeocoder()

    geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
      guard
        let address = response?.firstResult(),
        let lines = address.lines
        else {
          return
      }
    }
  }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    guard status == .authorizedWhenInUse else {
      return
    }
    
    locationManager.requestLocation()
    mapView.isMyLocationEnabled = true
    mapView.settings.myLocationButton = true
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }
    
    mapView.camera = GMSCameraPosition(
      target: location.coordinate,
      zoom: 15,
      bearing: 0,
      viewingAngle: 0)
      //fetchPlacesNike(near: location.coordinate)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }
}

// MARK: - GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {
  func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    reverseGeocode(coordinate: position.target)
  }
  
  func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
    
    if gesture {
      mapView.selectedMarker = nil
    }
  }
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        if brandChoiceSegmentedControl.selectedSegmentIndex == 0 {
            guard let nikePlaceMarker = marker as? NikePlaceMarker else { return nil }
            guard let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView else { return nil }
            infoView.nameLabel.text = nikePlaceMarker.place.name
            infoView.addressLabel.text = nikePlaceMarker.place.address
            return infoView
        }else {
            guard let newbalancePlaceMarker = marker as? NewbalancePlaceMarker else { return nil }
            guard let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView else { return nil }
            infoView.nameLabel.text = newbalancePlaceMarker.place.name
            infoView.addressLabel.text = newbalancePlaceMarker.place.address
            return infoView
        }
    }
}
