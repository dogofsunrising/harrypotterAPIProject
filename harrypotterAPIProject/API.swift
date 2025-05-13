import Foundation
import Alamofire

struct APIService {
    let baseURL = "https://hp-api.onrender.com/api/character"

    func request() async throws -> [harrypotterModel] {
        let response = try await AF.request(baseURL)
            .serializingDecodable([harrypotterModel].self)
            .value

        return response
    }
}

