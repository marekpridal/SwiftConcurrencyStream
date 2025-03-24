protocol DetailUseCase {
    func subscribe() async -> AsyncStream<String?>
    func update(value: String) async
}

struct DetailUseCaseImp: DetailUseCase {
    private let repository: DetailRepository

    init(repository: DetailRepository) {
        self.repository = repository
    }

    func subscribe() async -> AsyncStream<String?> {
        await repository.stream()
    }

    func update(value: String) async {
        let transformedString = value.isEmpty ? nil : value.uppercased()
        print("Use Case called and performing transformation from \(value) to \(String(describing: transformedString))")
        await repository.save(value: transformedString)
    }
}
