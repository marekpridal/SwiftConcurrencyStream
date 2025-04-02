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

    func setupBindingAsync() async {
        print(#function)
        for await value in $inputText.debounce(for: .seconds(0.5), scheduler: DispatchQueue.global()).removeDuplicates().drop(while: { $0.isEmpty }).values {
            print("Called with value \(value)")
            await useCase.update(value: value)
        }
    }

    func setupRepositoryObservation() async {
        print(#function)
        for await value in await useCase.subscribe().map({ $0 ?? "No Value" }) {
            print("Received value \(value)")
            await MainActor.run {
                labelText = value
            }
        }
    }

    func setupTimerObservation() async {
        print(#function)
        for await value in await useCase.timerStream() {
            print("Received timer value \(value)")
        }
    }
}
