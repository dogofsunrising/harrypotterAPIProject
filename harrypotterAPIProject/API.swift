import Foundation
import Alamofire

struct APIService {
    let url = "https://hp-api.onrender.com/api/characters"

    func request() async throws -> [HarryPotterModel] {
        let response = try await AF.request(url)
            .serializingDecodable([HarryPotterModel].self)
            .value

        return response
    }
}

