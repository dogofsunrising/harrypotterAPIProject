import Foundation

class APIViewModel: ObservableObject {
    @Published var APIisLoaded: Bool = false
    @Published var LocalisLoaded: Bool = false
    
    func fetchAPI() {
        guard !APIisLoaded else { return } // 2回目以降はスキップ
        APIisLoaded = true
        
        // ここにAPI通信処理を実装
        Task {
            do {
                let url = URL(string: "https://your-api-endpoint.com/spells")!
                let (data, _) = try await URLSession.shared.data(from: url)
                
               
            } catch {
                print("通信エラー: \(error)")
            }
        }
    }
    
    func fetchLocalData() {
        guard !LocalisLoaded else { return } // 2回目以降はスキップ
        LocalisLoaded = true
        
        // ここにローカルデータのフェッチ
        Task {
           
        }
    }
    

    // 明示的にリフレッシュしたいとき
    func refresh() {
        APIisLoaded = false
        LocalisLoaded = false
        fetchAPI()
        fetchLocalData()
        
    }
}
