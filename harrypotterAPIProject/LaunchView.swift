//
//  ContentView.swift
//  harrypotterAPIProject
//
//  Created by 藤本皇汰 on 2025/05/02.
//
import SwiftUI

struct LaunchView: View {
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
