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
            // For stream observation we should use `.task` because observation is automatically cancelled on view disappear
            // and needs to be reestablished on next appear.
            await viewModel.setupBindingAsync()
        }
        .task {
            await viewModel.setupRepositoryObservation()
        }
        .onLoadAsync {
            print("OnLoadAsync1")
        }
        .onLoadAsync {
            print("OnLoadAsync2")
        }
        .onLoadAsync {
            print("OnLoadAsync3")
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
