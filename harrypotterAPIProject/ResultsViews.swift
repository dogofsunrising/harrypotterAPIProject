import SwiftUI
import UIKit

struct ResultsViews: View {
    let results: [ResultModel]

    var body: some View {
        ScrollView {
            VStack {
                ForEach(results, id: \.id) { result in
                    ResultView(result: result)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

struct ResultView: View {
    let result: ResultModel

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 20) {
                if let userImage = result.userImage {
                    Image(uiImage: userImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                }

                if let urlString = result.harryPotter?.image,
                   let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        case .failure:
                            Image(systemName: "person.fill.xmark")
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }

            if let name = result.harryPotter?.name {
                Text("You're \(name)")
                    .font(.headline)
            } else {
                Text("Unknown character")
                    .foregroundColor(.gray)
            }
        }
    }
}
