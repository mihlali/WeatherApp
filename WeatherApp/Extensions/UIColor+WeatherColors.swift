//
//  UIColor+WeatherColors.swift
//  WeatherApp
//
//  Created by Mihlali Mazomba on 2023/05/06.
//

import UIKit
import SwiftUI

extension Color {
    
   static let weatherColor = WeatherColor()
    
}

struct WeatherColor {
    
    let cloudy = Color("Cloudy")
    let rainy = Color("Rainy")
    let sunny = Color("Sunny")
}
