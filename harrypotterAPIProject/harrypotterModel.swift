import Foundation

struct HarryPotterModel: Codable, Identifiable {
    let id: String
    let name: String
    let image: String
    let featureVector: [Float]?
}
