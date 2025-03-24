protocol DetailRepository {
    func stream() async -> AsyncStream<String?>
    func save(value: String?) async
}

actor DetailRepositoryImp: DetailRepository {
    private let dataStream = CurrentValueAsyncStream<String?>(nil)

    deinit {
        print("Deinit of \(self)")
    }

    func save(value: String?) async {
        print("Repository called, updating stream with new value")
        await dataStream.update(value)
    }

    func stream() async -> AsyncStream<String?> {
        await dataStream.stream()
    }
}
