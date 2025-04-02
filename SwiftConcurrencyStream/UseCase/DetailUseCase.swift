protocol DetailUseCase {
    func subscribe() async -> AsyncStream<String?>
    func update(value: String) async
    func timerStream() async -> TimerStream
}

struct DetailUseCaseImp: DetailUseCase {
    private let repository: DetailRepository
    private let timerRepository: TimerRepository

    init(repository: DetailRepository, timerRepository: TimerRepository) {
        self.repository = repository
        self.timerRepository = timerRepository
    }

    func subscribe() async -> AsyncStream<String?> {
        await repository.stream()
    }

    func update(value: String) async {
        let transformedString = value.isEmpty ? nil : value.uppercased()
        print("Use Case called and performing transformation from \(value) to \(String(describing: transformedString))")
        await repository.save(value: transformedString)
    }

    func timerStream() async -> TimerStream {
        return await timerRepository.stream()
    }
}
