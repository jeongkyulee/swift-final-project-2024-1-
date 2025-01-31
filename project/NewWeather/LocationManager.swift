//
//  LocationManager.swift
//  NewWeather
//
//  Created by 김형관 on 2023/04/25.
//

import Foundation
import CoreLocation

// LocationManager는 위치 관련 작업을 수행하는 클래스입니다.
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()  // CLLocationManager 인스턴스를 생성합니다.
    @Published var location: CLLocationCoordinate2D?  // 위치 좌표를 저장하는 변수입니다.
    @Published var placemark: CLPlacemark?  // 위치의 지명 정보를 저장하는 변수입니다.
    @Published var isLoading = false  // 위치 요청 중인지 여부를 나타내는 변수입니다.
    
    override init() {
        super.init()
        manager.delegate = self  // LocationManager를 CLLocationManager의 델리게이트로 설정합니다.
        manager.desiredAccuracy = kCLLocationAccuracyBest  // 위치 정확도를 최대로 설정합니다.
    }
    
    // 위치 요청을 시작하는 메서드입니다.
    func requestLocation() {
        isLoading = true  // 로딩 상태로 설정합니다.
        manager.requestLocation()  // 위치 요청을 시작합니다.
    }
    
    // 위치 업데이트 시 호출되는 델리게이트 메서드입니다.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.location = location.coordinate  // 위치 좌표를 업데이트합니다.
            self.fetchCityAndCountry(from: location)  // 지명 정보를 가져옵니다.
        }
        isLoading = false  // 로딩 상태를 해제합니다.
    }

    // 위치 요청 실패 시 호출되는 델리게이트 메서드입니다.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location", error)  // 오류 메시지를 출력합니다.
        isLoading = false  // 로딩 상태를 해제합니다.
    }
    
    // 주어진 위치에서 지명 정보를 가져오는 메서드입니다.
    private func fetchCityAndCountry(from location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Error in reverse geocoding: \(error.localizedDescription)")  // 오류 메시지를 출력합니다.
                return
            }
            self.placemark = placemarks?.first  // 지명 정보를 업데이트합니다.
        }
    }
}
