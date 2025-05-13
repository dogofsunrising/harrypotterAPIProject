import Foundation
import SwiftUI

enum Router {
    case launch
    case camera
}

struct RouterViews: View {
    @State private var router: Router = .launch // ← 状態管理
    @StateObject var viewModel = APIViewModel()
    var body : some View {
        ZStack {
            switch router {
            case .launch:
                LaunchView(router: $router)
            case .camera:
                OOCameraView(router: $router)
            }
        }
    }
}
