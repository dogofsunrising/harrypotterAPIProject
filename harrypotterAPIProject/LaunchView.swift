//
//  ContentView.swift
//  harrypotterAPIProject
//
//  Created by 藤本皇汰 on 2025/05/02.
//
import SwiftUI

struct LaunchView: View {
    @Binding var router:Router
    let results:[ResultModel]
    var body: some View {
        VStack {
            Button(action: {
                router = .camera
            }, label: {
                Text("📷Let`s take a picture!!")
                    .bold()
                    .font(.title)
            })
            ResultsViews(results: results)
        }
    }
}
