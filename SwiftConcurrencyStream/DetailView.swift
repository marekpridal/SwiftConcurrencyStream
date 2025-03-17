//
//  DetailView.swift
//  SwiftConcurrencyStream
//
//  Created by Marek Pridal on 17.03.2025.
//

import SwiftUI

struct DetailView: View {
    @StateObject var viewModel = DetailViewModel()

    var body: some View {
        VStack {
            TextField("Text Input", text: $viewModel.inputText)
            LabeledContent("Provided input", value: viewModel.labelText)
        }
        .task {
            // Seems like a better option
            // Cancels stream when View is deallocated
            //await viewModel.setupBindingAsync()
        }
        .onDisappear {
            // Manual task cancellation
            viewModel.task?.cancel()
        }
    }
}

#Preview {
    DetailView()
}
