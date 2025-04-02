import AsyncAlgorithms

typealias TimerStream = AsyncChain2Sequence<AsyncSyncSequence<[AsyncTimerSequence<ContinuousClock>.Element]>, AsyncTimerSequence<ContinuousClock>>

protocol TimerRepository {
    func stream() async -> TimerStream
}

actor TimerRepositoryImp: TimerRepository {
    deinit {
        print("Deinit of \(self)")
    }

    func stream() -> TimerStream {
        let clock = ContinuousClock()
        let timerSequence = AsyncTimerSequence(interval: .seconds(1), clock: clock)
        let result = chain([clock.now].async, timerSequence)
        return result
    }
}
