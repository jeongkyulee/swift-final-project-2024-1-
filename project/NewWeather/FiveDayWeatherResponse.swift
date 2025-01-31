//
//  FiveDayWeatherResponse.swift
//  NewWeather
//
//  Created by 이정규 on 6/7/24.
//

import Foundation

// FiveDayWeatherResponse는 5일치 날씨 데이터를 디코딩하기 위한 구조체입니다.
struct FiveDayWeatherResponse: Codable {
    let list: [WeatherEntry]  // 날씨 항목 배열입니다.
    
    // WeatherEntry는 각 날씨 항목을 나타내는 구조체입니다.
    struct WeatherEntry: Codable {
        let dt: Int  // 타임스탬프입니다.
        let main: Main  // 메인 날씨 정보를 포함합니다.
        let weather: [Weather]  // 날씨 상태 정보를 포함합니다.
        
        struct Main: Codable {
            let temp: Double  // 온도입니다.
        }
        
        struct Weather: Codable {
            let description: String  // 날씨 설명입니다.
            let main: String  // 날씨 상태입니다.
        }
    }
}
