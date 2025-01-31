//
//  WeatherView.swift
//  NewWeather
//
//  Created by 김형관 on 2023/04/25.
//
import SwiftUI

struct WeatherView: View {
    
    var openWeatherResponse: OpenWeatherResponse
    
    private let iconList = [
        "Clear": "☀️",
        "Clouds": "☁️",
        "Mist": "☁️",
        "": "?",
        "Drizzle": "🌧",
        "Thunderstorm": "⛈",
        "Rain": "🌧",
        "Snow": "🌨"
    ]
    
    var body: some View {
        VStack {
            Text(Weather(response: openWeatherResponse).location)
                .font(.largeTitle)
                .padding()
                .foregroundColor(openWeatherResponse.main.temp >= 25 ? .red : .black) // 온도가 25도 이상이면 빨간색, 아니면 검은색
            Text(Weather(response: openWeatherResponse).temperature)
                .font(.system(size: 75))
                .bold()
                .foregroundColor(openWeatherResponse.main.temp >= 25 ? .red : .black) // 온도가 25도 이상이면 빨간색, 아니면 검은색
            Text(iconList[Weather(response: openWeatherResponse).main] ?? "")
                .font(.largeTitle)
                .padding()
            Text(Weather(response: openWeatherResponse).description)
                .font(.largeTitle)
                .padding()
                .foregroundColor(openWeatherResponse.main.temp >= 25 ? .red : .black) // 온도가 25도 이상이면 빨간색, 아니면 검은색
        }
    }
}
