import SwiftUI
import CoreML
import Foundation

// 이미지 분류에 사용될 ViewModel
class ImageViewModel: ObservableObject {
    let images = ["construction2", "construction3", "4", "5"]
    @Published var classificationLabel = ""
    @Published var currentIndex: Int

    @Published var showAlert = false // 팝업 알림을 표시할지 여부를 나타내는 상태 변수

    init() {
        currentIndex = 0
        classifyImage()
    }

    let model: MobileNetV2 = {
        do {
            let config = MLModelConfiguration()
            return try MobileNetV2(configuration: config)
        } catch {
            fatalError("Couldn't create MobileNetV2 model")
        }
    }()

    public func classifyImage() {
        let currentImageName = images[currentIndex]

        guard let image = UIImage(named: currentImageName),
              let resizedImage = image.resizeImageTo(size: CGSize(width: 224, height: 224)),
              let buffer = resizedImage.convertToBuffer() else {
            return
        }

        if let output = try? model.prediction(image: buffer) {
            let results = output.classLabelProbs.sorted { $0.1 > $1.1 }

            // Find the probability of "crash helmet"
            if let helmetResult = results.first(where: { $0.key == "crash helmet" }) {
                let probability = helmetResult.value * 100
                let result = probability >= 1.0 ? "ok" : "NO"
                classificationLabel = result

                // "NO"로 분류되면 위험 팝업 알림을 표시하도록 showAlert 상태 변수를 true로 설정
                showAlert = result == "NO"
            } else {
                // If crash helmet is not found, set an empty label
                classificationLabel = ""
            }
        }
    }
}



// Image resizing 및 buffer 변환에 사용될 UIImage extension
extension UIImage {
    func resizeImageTo(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }

    func convertToBuffer() -> CVPixelBuffer? {
        let attributes = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
        ] as CFDictionary

        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault, Int(self.size.width),
            Int(self.size.height),
            kCVPixelFormatType_32ARGB,
            attributes,
            &pixelBuffer)

        guard (status == kCVReturnSuccess) else {
            return nil
        }

        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()

        let context = CGContext(
            data: pixelData,
            width: Int(self.size.width),
            height: Int(self.size.height),
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!),
            space: rgbColorSpace,
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)

        UIGraphicsPushContext(context!)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        UIGraphicsPopContext()

        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

