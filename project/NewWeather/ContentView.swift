import SwiftUI
import _CoreLocationUI_SwiftUI

struct ContentView: View {
    @EnvironmentObject var locationManager: LocationManager
    var weatherDataDownload = WeatherDataDownload()
    @State var fiveDayWeatherResponse: FiveDayWeatherResponse?
    @State private var showingContentView2 = false // ContentView2 표시 여부를 추적합니다.

    var body: some View {
        VStack {
            if let placemark = locationManager.placemark {
                Text("Location: \(placemark.locality ?? "Unknown")")
                    .font(.headline)
                    .padding(.top)
            }

            if locationManager.isLoading {
                ProgressView()
            } else {
                if let location = locationManager.location {
                    if let fiveDayWeatherResponse = fiveDayWeatherResponse {
                        WeeklyWeatherView(fiveDayWeatherResponse: fiveDayWeatherResponse)
                    } else {
                        ProgressView()
                            .task {
                                do {
                                    fiveDayWeatherResponse = try await weatherDataDownload.get5DayWeather(location: location)
                                } catch {
                                    print("Error downloading weather data: \(error)")
                                }
                            }
                    }
                } else {
                    FirstView()
                }
            }

            // AI Classification 버튼 추가 및 ContentView2 표시 로직
            Button(action: {
                showingContentView2 = true
            }) {
                Text("AI Classification")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $showingContentView2) {
                ContentView2()
                    .environmentObject(ImageViewModel()) // ImageViewModel을 ContentView2에 환경 객체로 전달합니다.
            }
            .padding(.top, 20)
        }
    }
}

struct ContentView2: View {
    @EnvironmentObject var locationManager: LocationManager
    @StateObject var imageViewModel = ImageViewModel()
    @State private var selectedDate = Date()
    @State private var today = Date()

    // 날짜 그룹을 나누는 배열
    private let dateGroups: [[Int]] = [
        Array(1...7),    // 1일부터 7일
        Array(8...14),   // 8일부터 14일
        Array(15...21),  // 15일부터 21일
        Array(22...28),  // 22일부터 28일
        Array(29...31)   // 29일부터 31일 (실제 월마다 달라질 수 있음)
    ]

    var body: some View {
        VStack {
            Text("Safety App")
                .font(.largeTitle)
                .padding()
                .multilineTextAlignment(.center)
                .padding(.top)

            // 이미지 분류 뷰
            VStack {
                Image(imageViewModel.images[imageViewModel.currentIndex])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .onAppear {
                        imageViewModel.classifyImage()
                    }

                Text(imageViewModel.classificationLabel)
                    .font(.largeTitle)
                    .padding()
                    .multilineTextAlignment(.center) // 분류 결과 표시
            }
            .font(.system(size: 20))

            Button(action: {
                nextImage()
            }) {
                Text("NEXT")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            // 캘린더 표시
            VStack {
                Text("날짜 선택")
                    .font(.headline)
                    .padding(.bottom, 10)

                // 일자 그룹을 가로로 표시
                ForEach(dateGroups, id: \.self) { group in
                    HStack(spacing: 10) {
                        ForEach(group, id: \.self) { day in
                            Text("\(day)")
                                .frame(width: 30, height: 30)
                                .background(day == Calendar.current.component(.day, from: today) ? (imageViewModel.classificationLabel == "NO" ? Color.red : Color.blue) : Color.clear)
                                .foregroundColor(.primary)
                                .cornerRadius(15)
                        }
                    }
                    .padding(.bottom, 10)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding()
        }
        .alert(isPresented: $imageViewModel.showAlert) {
            Alert(title: Text("위험"), message: Text("안전모를 착용하세요!"), dismissButton: .default(Text("OK")))
        }
    }

    // 다음 이미지로 이동하는 함수
    private func nextImage() {
        if imageViewModel.currentIndex < imageViewModel.images.count - 1 {
            imageViewModel.currentIndex += 1
        } else {
            imageViewModel.currentIndex = 0
        }
        imageViewModel.classifyImage() // 새로운 이미지를 로드할 때마다 분류 수행
    }
}

