//
//  DetailView.swift
//  SwiftConcurrencyStream
//
//  Created by Marek Pridal on 17.03.2025.
//

import SwiftUI

struct DetailView: View {
    @StateObject var viewModel = DetailViewModel(useCase: DetailUseCaseImp(repository: DetailRepositoryImp()))

    var body: some View {
        VStack {
            TextField("Text Input", text: $viewModel.inputText)
            LabeledContent("Provided input", value: viewModel.labelText)
            NavigationLink("Detail 2") {
                Text("Detail 2")
            }
        }
        .task {
            // Seems like a better option
            // Cancels stream when View is deallocated
            // .task is called on every appear, should be solved by ours .onLoadAsync
            await viewModel.setupBindingAsync()
        }
        .task {
            await viewModel.setupRepositoryObservation()
        }
        .onDisappear {
            // Manual task cancellation
            //viewModel.task?.cancel()
        }
    }
}

#Preview {
    DetailView()
}
