//
//  WeatherService.swift
//  NewWeather
//
//  Created by 김형관 on 2023/04/25.
//

import Foundation
import CoreLocation

// WeatherDataDownload는 날씨 데이터를 다운로드하는 클래스입니다.
class WeatherDataDownload {
    
    private let API_KEY = ""  // API 키를 설정합니다.

    // 5일치 날씨 데이터를 가져오는 메서드입니다.
    func get5DayWeather(location: CLLocationCoordinate2D) async throws -> FiveDayWeatherResponse {
        // URL 문자열을 생성하고 인코딩합니다.
        guard let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(location.latitude)&lon=\(location.longitude)&appid=\(API_KEY)&units=metric"
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw URLError(.badURL)
        }

        // URL 객체를 생성합니다.
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        print("Fetching URL: \(urlString)")

        let urlRequest = URLRequest(url: url)
        
        // URLSession을 사용하여 데이터와 응답을 받습니다.
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Response Status Code: \(httpResponse.statusCode)")
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 401 {
                    print("Error: Unauthorized - Invalid API key")
                }
                throw URLError(.badServerResponse)
            }
        }
        
        // 데이터를 디코딩하여 반환합니다.
        do {
            let decodedData = try JSONDecoder().decode(FiveDayWeatherResponse.self, from: data)
            return decodedData
        } catch {
            print("Error decoding data: \(error)")
            throw error
        }
    }
}
