//
//  WeatherDataModel2.swift
//  NewWeather
//
//  Created by 이정규 on 6/8/24.
//

import Foundation

struct OpenWeatherResponse2: Decodable {
    let name: String
    let main: OpenWeatherMain
    let weather: [OpenWeatherWeather]
    
    init(name: String, main: OpenWeatherMain, weather: [OpenWeatherWeather]) {
        self.name = name
        self.main = main
        self.weather = weather
    }
}

struct OpenWeatherMain2: Decodable {
    let temp: Double
    
    init(temp: Double) {
        self.temp = temp
    }
}

struct OpenWeatherWeather2: Decodable {
    let description: String
    let main: String
    
    init(description: String, main: String) {
        self.description = description
        self.main = main
    }
}

public struct Weather2 {
    let location: String
    let temperature: String
    let description: String
    let main: String
    
    init(response: OpenWeatherResponse) {
        location = response.name
        temperature = "\(Int(response.main.temp))"
        description = response.weather.first?.description ?? ""
        main = response.weather.first?.main ?? ""
    }
}
