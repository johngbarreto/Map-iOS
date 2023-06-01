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
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
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
    
    private func findNearbyPlaces(by query: String) {
        mapView.removeAnnotations(mapView.annotations)
        
        let req = MKLocalSearch.Request()
        req.naturalLanguageQuery = query
        req.region = mapView.region
        
        let search = MKLocalSearch(request: req)
        search.start{ res, error in
            guard let res = res, error == nil else {return}
            print(res.mapItems)
        }
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
