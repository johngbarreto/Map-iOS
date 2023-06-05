//
//  ViewController.swift
//  MyMapApp
//
//  Created by João Gabriel Lavareda Ayres Barreto on 22/05/23.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    var locationManager: CLLocationManager?
    
    private var placesArray: [PlaceAnnotation] = []
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    lazy var searchTextField: UITextField = {
       let txtField = UITextField()
        txtField.layer.cornerRadius = 10
        txtField.clipsToBounds = true
        txtField.delegate = self
        txtField.backgroundColor = UIColor.white
        txtField.placeholder = "Search..."
        txtField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        txtField.leftViewMode = .always
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        locationManagement()
        configureUI()
    }

    func locationManagement() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
    }

    func configureUI() {
        
        view.addSubview(mapView)
        view.addSubview(searchTextField)

        
        view.bringSubviewToFront(searchTextField)
        
        searchTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        searchTextField.widthAnchor.constraint(equalToConstant: view.bounds.size.width/1.3).isActive = true
        searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

    }
    
    private func checkLocationAuth() {
        guard let locationManager = locationManager, let location = locationManager.location else { return }
        
        switch locationManager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 600, longitudinalMeters: 600)
                mapView.setRegion(region, animated: true)
            case .denied:
                print("User needs to enable it again")
            case .notDetermined, .restricted:
                print("Undertemined error or restricted")
            @unknown default:
                print("default error")
            
        }
    }
    
    private func presentePlaces(places: [PlaceAnnotation]) {
        
        guard let locationManager = locationManager,
              let userLocation = locationManager.location
                else {return}
        
        let placesVC = PlacesTableViewController(userLocation: userLocation, places: places)
        placesVC.modalPresentationStyle = .pageSheet
        
        if let sheet = placesVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            present(placesVC, animated: true)
        }
    }


    private func findNearbyPlaces(by query: String) {
        mapView.removeAnnotations(mapView.annotations)
        
        let req = MKLocalSearch.Request()
        req.naturalLanguageQuery = query
        req.region = mapView.region
        
        let search = MKLocalSearch(request: req)
        search.start{ [weak self] res, error in
            guard let res = res, error == nil else {return}
            
            self?.placesArray = res.mapItems.map(PlaceAnnotation.init)
            
            self?.placesArray.forEach{ place in
                self?.mapView.addAnnotation(place)
            }
            
            if let places = self?.placesArray {
                self?.presentePlaces(places: places)
            }
        }
    }
    
}

extension ViewController: MKMapViewDelegate {
    
    private func clearAllSelections() {
        self.placesArray = self.placesArray.map { place in
            place.isSelected = false
            return place
            
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        
        clearAllSelections()
        
        guard let selectedAnnotation = annotation as? PlaceAnnotation else { return }
        
        let placeAnnotation = self.placesArray.first(where: { $0.id == selectedAnnotation.id})
        placeAnnotation?.isSelected = true
        presentePlaces(places: self.placesArray)
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text ?? ""
        if !text.isEmpty {
            textField.resignFirstResponder()
            findNearbyPlaces(by: text)
        }
        return true
    }
    
}

extension ViewController: CLLocationManagerDelegate {

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuth()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
