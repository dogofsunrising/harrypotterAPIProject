import SwiftUI
import UIKit

struct CameraView: UIViewControllerRepresentable {
    @Binding var router:Router
    @Binding var loading:Bool
    @ObservedObject var viewModel: APIViewModel
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = .camera
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // 特に更新不要
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView

        init(parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[.originalImage] as? UIImage {
                Task{
                    print("類似推定を開始")
                    parent.loading = true
                    if let result = await parent.viewModel.featuringData(userImage: pickedImage) {
                        LocalService().storeResult(result)
                        // ✅ viewModelに反映
                        parent.viewModel.resultList = LocalService().loadResults()
                        parent.loading = false
                    } else {
                        print("❌ 類似顔推定に失敗しました")
                    }
                }
            }
            parent.presentationMode.wrappedValue.dismiss()
            parent.router = .launch
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
            parent.router = .launch
        }
    }
}
