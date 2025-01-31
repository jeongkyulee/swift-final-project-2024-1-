import SwiftUI
import CoreLocationUI

struct FirstView: View {
    @EnvironmentObject var locationManager: LocationManager
    @State private var currentWeather: OpenWeatherResponse?
    
    var body: some View {
        VStack {
            Text("Safety App")
                .font(.largeTitle)
                .padding()
                .multilineTextAlignment(.center)
                .padding(.top)
            
            VStack {
                if let weather = currentWeather {
                    Text(weather.name)
                        .font(.largeTitle)
                        .padding()
                        .foregroundColor(
                            weather.main.temp > 24 || ["Drizzle", "Thunderstorm", "Rain", "Snow"].contains(weather.weather.first?.main ?? "") ? .red : .black
                        )
                    Text(String(format: "%.0f", weather.main.temp))
                        .font(.system(size: 75))
                        .fontWeight(.bold)
                        .foregroundColor(
                            weather.main.temp > 24 || ["Drizzle", "Thunderstorm", "Rain", "Snow"].contains(weather.weather.first?.main ?? "") ? .red : .black
                        )
                    Text(iconList[weather.weather.first?.main ?? ""] ?? "")
                        .font(.largeTitle)
                        .padding()
                        .foregroundColor(
                            weather.main.temp > 24 || ["Drizzle", "Thunderstorm", "Rain", "Snow"].contains(weather.weather.first?.main ?? "") ? .red : .black
                        )
                    Text(weather.weather.first?.description ?? "")
                        .font(.largeTitle)
                        .padding()
                        .padding(.top, 20)
                        .foregroundColor(
                            weather.main.temp > 24 || ["Drizzle", "Thunderstorm", "Rain", "Snow"].contains(weather.weather.first?.main ?? "") ? .red : .black
                        )
                } else {
                    Text("Loading...")
                }
            }
            
            HStack {
                LocationButton(.shareCurrentLocation) {
                    locationManager.requestLocation()
                }
                .frame(maxWidth: .infinity)
                .cornerRadius(3)
                .foregroundColor(.white)
            }
            .padding()
            .onAppear {
                fetchWeatherData()
            }
        }
    }
    
    private func fetchWeatherData() {
        WeatherDataDownload2.shared.fetchCurrentWeather(for: "Tokyo") { result in
            switch result {
            case .success(let weather):
                self.currentWeather = weather
            case .failure(let error):
                print("Failed to fetch weather data: \(error)")
            }
        }
    }
    
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
}


