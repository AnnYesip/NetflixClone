//
//  Extensions.swift
//  Netflix Clone
//
//  Created by Ann Yesip on 20.08.2022.
//

import Foundation

extension String {
    
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
}
