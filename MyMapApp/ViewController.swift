//
//  ViewController.swift
//  MyMapApp
//
//  Created by João Gabriel Lavareda Ayres Barreto on 22/05/23.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        //map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    lazy var searchTextField: UITextField = {
       let txtField = UITextField()
        txtField.layer.cornerRadius = 10
        txtField.clipsToBounds = true
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
        configureUI()
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
}

