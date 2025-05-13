import SwiftUI
import UIKit

struct OOCameraView :View {
    @Binding var router:Router
    var body: some View {
        VStack {
            CameraView(router: $router)
        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var router:Router
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
                LocalService().storeResult(ResultModel(id: "aaa", harryPotter: sampleHarryPotterModel, userImage: pickedImage))
                
                parent.presentationMode.wrappedValue.dismiss()
                parent.router = .launch
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
