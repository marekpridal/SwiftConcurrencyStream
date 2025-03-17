//
//  DetailViewModel.swift
//  SwiftConcurrencyStream
//
//  Created by Marek Pridal on 17.03.2025.
//

import Combine

final class DetailViewModel: ObservableObject, @unchecked Sendable {
    @MainActor @Published var inputText: String = ""
    @MainActor @Published var labelText: String = ""

    init() {
        //setupBinding()
    }

    deinit {
        print("Deinit of \(self)")
    }

    // Needs to be `@MainActor` as it's called from isolated context in View
    // But can be bypassed by @unchecked Sendable and then used without `@MainActor`
    //@MainActor
    func setupBindingAsync() async {
        for await value in $inputText.removeDuplicates().values {
            print("Called with value \(value)")
            await MainActor.run {
                labelText = value.uppercased()
            }
            //labelText = value.uppercased()
        }
    }

    // Requires manual task cancellation
    // Requires @unchecked Sendable
    /*
    func setupBinding() {
        task = Task {
            for await value in $inputText.values {
                await MainActor.run {
                    labelText = value.uppercased()
                }
            }
        }
    }
    */
}
