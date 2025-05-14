import UIKit

struct LocalService {
    private let userDefaultsKey = "storedResults"

    // 保存
    func storeResult(_ resultModel: ResultModel) {
        var savedResults = loadRawResults()

        // 画像保存
        var fileName = ""
        if let image = resultModel.userImage {
            fileName = "\(resultModel.id).jpg"
            _ = saveImage(image, as: fileName)
        }

        // JSONにエンコード（harryPotterだけ）
        var harryPotterJSON: String? = nil
        if let harryPotter = resultModel.harryPotter,
           let data = try? JSONEncoder().encode(harryPotter),
           let json = String(data: data, encoding: .utf8) {
            harryPotterJSON = json
        }

        // 保存用データ構造
        let raw = RawResult(id: resultModel.id,
                            harryPotterJSON: harryPotterJSON,
                            imageFileName: fileName)

        // 上書き用に古い同一IDは除去
        savedResults.removeAll { $0.id == raw.id }

        // 最大10件制限 → 古い順に削除
        while savedResults.count >= 10 {
            savedResults.removeFirst() // 一番古いものを削除
        }

        // 新しい結果を追加
        savedResults.append(raw)

        // 保存
        if let data = try? JSONEncoder().encode(savedResults) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }


    // 読み込み
    func loadResults() -> [ResultModel] {
        let rawResults = loadRawResults()

        return rawResults.compactMap { raw in
            var model: HarryPotterModel? = nil
            if let json = raw.harryPotterJSON,
               let data = json.data(using: .utf8) {
                model = try? JSONDecoder().decode(HarryPotterModel.self, from: data)
            }

            let image = loadImage(fileName: raw.imageFileName)

            return ResultModel(id: raw.id, harryPotter: model, userImage: image)
        }
    }

    // 読み込み補助
    private func loadRawResults() -> [RawResult] {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let rawResults = try? JSONDecoder().decode([RawResult].self, from: data) else {
            return []
        }
        return rawResults
    }

    // 画像保存
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

    // 画像読み込み
    func loadImage(fileName: String) -> UIImage? {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        return UIImage(contentsOfFile: url.path)
    }

    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

// 保存専用の軽量構造体
struct RawResult: Codable {
    let id: String
    let harryPotterJSON: String?
    let imageFileName: String
}
