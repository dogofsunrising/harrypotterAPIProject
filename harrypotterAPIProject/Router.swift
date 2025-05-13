import Foundation
import SwiftUI

enum Router {
    case launch
    case camera
}

struct RouterViews: View {
    @State private var router: Router = .launch // ← 状態管理
    @StateObject var viewModel = APIViewModel()
    @State var image: UIImage?
    var body : some View {
        ZStack {
            switch router {
            case .launch:
                LaunchView(router: $router)
            case .camera:
                OOCameraView(router: $router, image: $image)
            }
        }
        .onAppear{
            viewModel.fetchAPI()
            viewModel.fetchLocalData()
        }
    }
}
