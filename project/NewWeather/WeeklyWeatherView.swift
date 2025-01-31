//
//  WeeklyWeatherView.swift
//  NewWeather
//
//  Created by 이정규 on 6/7/24.
//

import SwiftUI
import CoreLocationUI

struct WeeklyWeatherView: View {
    var fiveDayWeatherResponse: FiveDayWeatherResponse
    
    var body: some View {
        ScrollView {
            VStack {
                // 각 날씨 항목을 표시합니다.
                ForEach(fiveDayWeatherResponse.list.prefix(40), id: \.dt) { weatherEntry in
                    let date = Date(timeIntervalSince1970: TimeInterval(weatherEntry.dt))
                    let calendar = Calendar.current
                    let hour = calendar.component(.hour, from: date)
                    
                    if hour >= 6 && hour <= 18 {
                        if weatherEntry.main.temp > 30 ||
                            ["Drizzle", "Thunderstorm", "Rain", "Snow"].contains(weatherEntry.weather.first?.main ?? "") {
                            HStack {
                                Text(formattedDate(timeInterval: TimeInterval(weatherEntry.dt)))  // 날짜와 시간을 표시합니다.
                                    .font(.title3)
                                Spacer()
                                VStack {
                                    Text("\(Int(weatherEntry.main.temp))°C")  // 온도를 표시합니다.
                                        .bold()
                                    Text(iconList[weatherEntry.weather.first?.main ?? ""] ?? "")  // 날씨 아이콘을 표시합니다.
                                        .font(.title)
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(10)
                            .padding()
                        } else if weatherEntry.main.temp > 25  {
                            HStack {
                                Text(formattedDate(timeInterval: TimeInterval(weatherEntry.dt)))  // 날짜와 시간을 표시합니다.
                                    .font(.title3)
                                Spacer()
                                VStack {
                                    Text("\(Int(weatherEntry.main.temp))°C")  // 온도를 표시합니다.
                                        .bold()
                                    Text(iconList[weatherEntry.weather.first?.main ?? ""] ?? "")  // 날씨 아이콘을 표시합니다.
                                        .font(.title)
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .cornerRadius(10)
                            .padding()
                        } else if weatherEntry.main.temp > 20  {
                                     HStack {
                                         Text(formattedDate(timeInterval: TimeInterval(weatherEntry.dt)))  // 날짜와 시간을 표시합니다.
                                             .font(.title3)
                                         Spacer()
                                         VStack {
                                             Text("\(Int(weatherEntry.main.temp))°C")  // 온도를 표시합니다.
                                                 .bold()
                                             Text(iconList[weatherEntry.weather.first?.main ?? ""] ?? "")  // 날씨 아이콘을 표시합니다.
                                                 .font(.title)
                                         }
                                     }
                                     .padding()
                                     .frame(maxWidth: .infinity)
                                     .background(Color.yellow)
                                     .cornerRadius(10)
                                     .padding()
                        } else {
                            HStack {
                                Text(formattedDate(timeInterval: TimeInterval(weatherEntry.dt)))  // 날짜와 시간을 표시합니다.
                                    .font(.title3)
                                Spacer()
                                VStack {
                                    Text("\(Int(weatherEntry.main.temp))°C")  // 온도를 표시합니다.
                                        .bold()
                                    Text(iconList[weatherEntry.weather.first?.main ?? ""] ?? "")  // 날씨 아이콘을 표시합니다.
                                        .font(.title)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
        }
    }
    
    // 시간 간격을 받아서 포맷된 날짜 문자열로 반환하는 메서드입니다.
    private func formattedDate(timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, h:mm a"  // 요일, 월 일, 시:분 오전/오후 형식으로 포맷합니다.
        return dateFormatter.string(from: date)
    }
}

struct ContentView3: View {
    @EnvironmentObject var locationManager: LocationManager
    @StateObject var imageViewModel = ImageViewModel()

    var body: some View {
        VStack {
            // WeatherView에 "서울"로 설정된 OpenWeatherResponse 전달
            WeeklyWeatherView(fiveDayWeatherResponse: FiveDayWeatherResponse(list: [])) // 서울 위치를 나타내는 날씨 정보 전달
                .padding()
                .navigationBarTitle("서울 날씨")
        }
    }
}


    


private let iconList = [
        "Clear": "☀️",
        "Clouds": "☁️",
        "Mist": "🌫",
        "": "?",
        "Drizzle": "🌧",
        "Thunderstorm": "⛈",
        "Rain": "🌧",
        "Snow": "🌨"
    ]
