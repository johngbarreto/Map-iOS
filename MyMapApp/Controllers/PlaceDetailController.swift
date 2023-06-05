//
//  PlaceDetailController.swift
//  MyMapApp
//
//  Created by João Gabriel Lavareda Ayres Barreto on 05/06/23.
//

import Foundation
import UIKit 

class PlaceDetailController: UIViewController {
   
    let place: PlaceAnnotation
    
    lazy var nameLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.alpha = 0.4
        return label
    }()
    
     var directionsBtn: UIButton = {
         var config = UIButton.Configuration.bordered()
         let button = UIButton(configuration: config)
         button.translatesAutoresizingMaskIntoConstraints = false
         button.setTitle("Directions", for: .normal)
         return button
    }()
    
    @objc func directionsTapped(_ sender: UIButton) {
        
        let coordinates = place.location.coordinate
        guard let url = URL(string: "http://maps.apple.com/?daddr=\(coordinates.latitude),\(coordinates.longitude)") else {return}
        
        UIApplication.shared.open(url)
    }
    
    var callBtn: UIButton = {
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Call", for: .normal)
        return button
   }()
    
    @objc func callTapped(_ sender: UIButton) {
        
        guard let url = URL(string: "tel://\(place.phone.formatPhone)") else { return }
        UIApplication.shared.open(url)
    }
    
    init(place: PlaceAnnotation) {
        self.place = place
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPurple
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        nameLabel.text = place.name
        addressLabel.text = place.address
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(addressLabel)
        
        nameLabel.widthAnchor.constraint(equalToConstant: view.bounds.width - 20).isActive = true
        
        
        let contactStackView = UIStackView()
        contactStackView.alignment = .leading
        contactStackView.axis = .horizontal
        contactStackView.spacing = UIStackView.spacingUseSystem
        
        contactStackView.addArrangedSubview(directionsBtn)
        contactStackView.addArrangedSubview(callBtn)
        
        directionsBtn.addTarget(self, action: #selector(directionsTapped), for: .touchUpInside)
        callBtn.addTarget(self, action: #selector(callTapped), for: .touchUpInside)

        callBtn.addTarget(self, action: #selector(callTapped), for: .touchUpInside)
        
        stackView.addArrangedSubview(contactStackView)
        
        view.addSubview(stackView)

    }
    
}
