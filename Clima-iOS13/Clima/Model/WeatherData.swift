//
//  WeatherData.swift
//  Clima
//
//  Created by Галина Збитнева on 21.09.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    var name: String
    var main: Main
    var weather: [Weather]

}

struct Main: Decodable {
    var temp: Double
}

struct Weather: Decodable {
    var id: Int
}
