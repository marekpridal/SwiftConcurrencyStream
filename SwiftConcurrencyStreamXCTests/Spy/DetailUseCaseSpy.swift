@testable import SwiftConcurrencyStream
import XCTest

final class DetailUseCaseSpy: DetailUseCase {
    var subscribeCalled = 0
    var updateCalled = 0
    var updatedValues: [String] = []

    let updateExpectation = XCTestExpectation(description: "updateExpectation")
    let subscribeExpectation = XCTestExpectation(description: "subscribeCalled")

    let stream = CurrentValueAsyncStream<String?>(nil)

    func subscribe() async -> AsyncStream<String?> {
        subscribeCalled += 1
        subscribeExpectation.fulfill()
        return await stream.stream()
    }
    
    func update(value: String) async {
        updateCalled += 1
        updatedValues.append(value)
        updateExpectation.fulfill()
    }

    func timerStream() async -> TimerStream {
        fatalError()
    }
}
