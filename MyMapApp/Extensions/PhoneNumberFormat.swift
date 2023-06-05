//
//  PhoneNumberFormat.swift
//  MyMapApp
//
//  Created by João Gabriel Lavareda Ayres Barreto on 05/06/23.
//

import Foundation


extension String {
    
    var formatPhone: String {
        self.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "-", with: "")
    }
}
