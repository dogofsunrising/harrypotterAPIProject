import UIKit

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
    
    func featuringData(userImage:UIImage?) -> ResultModel{
        return ResultModel(id: UUID().uuidString, harryPotter: sampleHarryPotterModel, userImage: userImage)
    }
}
