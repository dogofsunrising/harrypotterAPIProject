import RealmSwift
import UIKit

class Result: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var harryPotterJSON: String?
    @Persisted var user_image: String
}

struct LocalService {
    let realm = try! Realm()
    func storeResult(_ resultModel: ResultModel) {
        let result = Result()
        result.id = resultModel.id
        
        // JSONへエンコード（HarryPotterModel）
        if let harryPotter = resultModel.harryPotter,
           let jsonData = try? JSONEncoder().encode(harryPotter),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            result.harryPotterJSON = jsonString
        }

        // UIImageをファイルに保存
        if let image = resultModel.userImage {
            let fileName = "\(resultModel.id).jpg"
            if let _ = saveImage(image, as: fileName) {
                result.user_image = fileName
            }
        }

        try? realm.write {
            realm.add(result, update: .modified)
        }
    }
    
    // MARK: - 読み込み
    func loadResults() -> [ResultModel] {
        let results = realm.objects(Result.self)

        return results.compactMap { result in
            // JSONからHarryPotterModelにデコード
            var model: HarryPotterModel? = nil
            if let json = result.harryPotterJSON,
               let data = json.data(using: .utf8) {
                model = try? JSONDecoder().decode(HarryPotterModel.self, from: data)
            }

            // ファイル名からUIImageを読み込み
            let image = loadImage(fileName: result.user_image)

            return ResultModel(id: result.id, harryPotter: model, userImage: image)
        }
    }
    
    // MARK: - UIImageをファイル保存
    func saveImage(_ image: UIImage, as fileName: String) -> URL? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            try data.write(to: url)
            return url
        } catch {
            print("❌ 画像保存失敗: \(error)")
            return nil
        }
    }

    // MARK: - UIImageを読み込み
    func loadImage(fileName: String) -> UIImage? {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        return UIImage(contentsOfFile: url.path)
    }
    
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
