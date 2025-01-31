//
//  WeatherDataDownload2.swift
//  NewWeather
//
//  Created by 이정규 on 6/8/24.
//

import Foundation
import CoreLocation

class WeatherDataDownload2 {
    
    static let shared = WeatherDataDownload2() // shared 인스턴스 추가

    private let API_KEY = ""

    // 다른 메서드들...
    
    // 싱글톤 패턴을 위한 private init() 추가
    private init() {}
    
    func fetchCurrentWeather(for location: String, completion: @escaping (Result<OpenWeatherResponse, Error>) -> Void) {
        guard let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(location)&appid=\(API_KEY)&units=metric"
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "URL string not located", code: -1, userInfo: nil)))
            return
        }

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "URL not located", code: -1, userInfo: nil)))
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(OpenWeatherResponse.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
