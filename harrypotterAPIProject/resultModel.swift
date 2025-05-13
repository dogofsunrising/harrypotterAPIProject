import UIKit

struct ResultModel{
    let id: String
    let harryPotter: HarryPotterModel?
    let userImage: UIImage?
    let userFacefeature:[Float]?
}

var sampleHarryPotterModel = HarryPotterModel(id: "9e3f7ce4-b9a7-4244-b709-dae5c1f1d4a8", name: "Harry Potter", image: "https://ik.imagekit.io/hpapi/harry.jpg", featureVector: nil)
