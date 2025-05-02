//
//  ContentView.swift
//  harrypotterAPIProject
//
//  Created by 藤本皇汰 on 2025/05/02.
//
import SwiftUI

struct LaunchView: View {
    var body: some View {
        VStack {
            Button(action: {
                print("start")
            }, label: {
                Text("start")
                    .bold()
                    .font(.title)
            })
        }
    }
}
