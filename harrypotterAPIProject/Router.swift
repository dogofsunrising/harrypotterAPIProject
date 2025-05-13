import Foundation
import SwiftUI

enum Router {
    case launch
    case camera
}

struct RouterViews: View {
    @State private var router: Router = .launch // ← 状態管理
    @State private var loading:Bool = false
    @StateObject var viewModel = APIViewModel()
    var body : some View {
        ZStack {
            switch router {
            case .launch:
                LaunchView(router: $router,results: viewModel.resultList,loading: loading)
            case .camera:
                CameraView(router: $router,loading:$loading, viewModel: viewModel)
            }
        }
        .onAppear{
            viewModel.fetchAPI()
            viewModel.fetchLocalData()
        }
    }
}
