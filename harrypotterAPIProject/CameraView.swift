import SwiftUI

struct CameraView :View {
    @Binding var router:Router
    var body: some View {
        VStack {
            Button(action: {
                router = .camera
            }, label: {
                Text("start")
                    .bold()
                    .font(.title)
            })
        }
    }
}
