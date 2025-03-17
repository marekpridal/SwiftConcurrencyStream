//
//  ContentView.swift
//  SwiftConcurrencyStream
//
//  Created by Marek Pridal on 17.03.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            NavigationLink("Go to Detail") {
                DetailView()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
