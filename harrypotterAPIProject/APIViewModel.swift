import UIKit
import Vision

@MainActor
class APIViewModel: ObservableObject {
    @Published var APIisLoaded: Bool = false
    @Published var LocalisLoaded: Bool = false
    
    var harryList: [HarryPotterModel] = []
    @Published var resultList: [ResultModel] = []
    
    func fetchAPI() {
        guard !APIisLoaded else { return } // 2回目以降はスキップ
        APIisLoaded = true
        
        // ここにAPI通信処理を実装
        Task {
            do {
                let result = try await APIService().request()
                harryList = result
            } catch {
                print("❌ 通信失敗: \(error)")
            }
        }
    }
    
    func fetchLocalData() {
        guard !LocalisLoaded else { return } // 2回目以降はスキップ
        LocalisLoaded = true
        
        // ここにローカルデータのフェッチ
        Task {
            let result = LocalService().loadResults()
            resultList = result
        }
    }
    

    // 明示的にリフレッシュしたいとき
    func refresh() {
        APIisLoaded = false
        LocalisLoaded = false
        fetchAPI()
        fetchLocalData()
        
    }
    
    func featuringData(userImage: UIImage?) async -> ResultModel? {
        
        guard let userImage = userImage,
              let userVector = await extractImageFeatureVector(from: resizedImage(userImage)) else {
            return nil
        }

        var results: [(HarryPotterModel, Float)] = []

        await withTaskGroup(of: (HarryPotterModel, Float)?.self) { group in
            for harry in harryList {
                group.addTask {
                    guard let url = URL(string: harry.image) else { return nil }
                    do {
                        let (data, _) = try await URLSession.shared.data(from: url)
                        guard let image = UIImage(data: data) else { return nil }
                        let resized = await self.resizedImage(image)
                        guard let harryVector = await self.extractImageFeatureVector(from: resized) else { return nil }

                        let distance = await self.distanceBetween(userVector, harryVector)
                        return (harry, distance)
                    } catch {
                        return nil
                    }
                }
            }

            for await result in group {
                if let result = result {
                    results.append(result)
                }
            }
        }

        guard let (best, _) = results.min(by: { $0.1 < $1.1 }) else { return nil }

        return ResultModel(id: UUID().uuidString, harryPotter: best, userImage: userImage)
    }

    
    func distanceBetween(_ v1: [Float], _ v2: [Float]) -> Float {
        guard v1.count == v2.count else { return Float.greatestFiniteMagnitude }
        return zip(v1, v2).map { pow($0 - $1, 2) }.reduce(0, +).squareRoot()
    }
    
    func extractImageFeatureVector(from image: UIImage) async -> [Float]? {
        guard let cgImage = image.cgImage else { return nil }

        return await withCheckedContinuation { continuation in
            let request = VNGenerateImageFeaturePrintRequest { request, error in
                guard let result = request.results?.first as? VNFeaturePrintObservation else {
                    continuation.resume(returning: nil)
                    return
                }
                let data = result.data

                let floatArray = data.withUnsafeBytes { buffer in
                    let floatBuffer = buffer.bindMemory(to: Float.self)
                    return Array(floatBuffer)
                }

                continuation.resume(returning: floatArray)
            }

            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                print("❌ Vision request failed: \(error)")
                continuation.resume(returning: nil)
            }
        }
    }
    
    func resizedImage(_ image: UIImage, maxLength: CGFloat = 224) -> UIImage {
        let scale = min(maxLength / image.size.width, maxLength / image.size.height)
        let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resized ?? image
    }
}
