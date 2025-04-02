import Foundation
import Combine

final class DetailViewModel: ObservableObject, @unchecked Sendable {
    @MainActor @Published var inputText: String = ""
    @MainActor @Published var labelText: String = ""

    private let useCase: DetailUseCase

    init(useCase: DetailUseCase) {
        self.useCase = useCase
    }

    deinit {
        print("Deinit of \(self)")
    }

    // Needs to be `@MainActor` as it's called from isolated context in View
    // But can be bypassed by @unchecked Sendable and then used without `@MainActor`
    //@MainActor
    func setupBindingAsync() async {
        print("setupBindingAsync")
        for await value in $inputText.debounce(for: .seconds(0.5), scheduler: DispatchQueue.global()).removeDuplicates().drop(while: { $0.isEmpty }).values {
            print("Called with value \(value)")
            await useCase.update(value: value)
        }
    }

    func setupRepositoryObservation() async {
        print("setupRepositoryObservation")
        for await value in await useCase.subscribe().map({ $0 ?? "No Value" }) {
            print("Received value \(value)")
            await MainActor.run {
                labelText = value
            }
        }
    }
}
