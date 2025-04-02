import Combine
@testable import SwiftConcurrencyStream
import XCTest

@MainActor
final class DetailViewModelTests: XCTestCase {
    func test_givenStreamEstablished_whenInputTextChanges_thenUseCaseCalled() async {
        let useCase = DetailUseCaseSpy()
        let sut = makeSUT(useCase: useCase)
        Task {
            await sut.setupBindingAsync()
        }

        sut.inputText = "AAA"

        await fulfillment(of: [useCase.updateExpectation], timeout: 2)
        XCTAssertEqual(useCase.updateCalled, 1)
        XCTAssertEqual(useCase.updatedValues, ["AAA"])
    }

    func test_givenStreamEstablished_andValueReceived_whenInputTextChangesAfterDebounce_thenUseCaseCalledAgain() async throws {
        let useCase = DetailUseCaseSpy()
        useCase.updateExpectation.expectedFulfillmentCount = 2
        let sut = makeSUT(useCase: useCase)
        Task {
            await sut.setupBindingAsync()
        }
        sut.inputText = "AAA"

        try await Task.sleep(for: .seconds(1))
        sut.inputText = "BBB"

        await fulfillment(of: [useCase.updateExpectation], timeout: 2)
        XCTAssertEqual(useCase.updateCalled, 2)
        XCTAssertEqual(useCase.updatedValues, ["AAA", "BBB"])
    }

    func test_givenStreamEstablished_andValueReceived_whenInputTextChangesBeforeDebounce_thenUseCaseCalledOnce() async {
        let useCase = DetailUseCaseSpy()
        let sut = makeSUT(useCase: useCase)
        Task {
            await sut.setupBindingAsync()
        }

        sut.inputText = "AAA"
        sut.inputText = "BBB"

        await fulfillment(of: [useCase.updateExpectation], timeout: 2)
        XCTAssertEqual(useCase.updateCalled, 1)
        XCTAssertEqual(useCase.updatedValues, ["BBB"])
    }

    func test_givenViewModel_whenSetupRepositoryObservation_thenUseCaseSubscribeCalled() async {
        let useCase = DetailUseCaseSpy()
        let sut = makeSUT(useCase: useCase)

        Task {
            await sut.setupRepositoryObservation()
        }

        await fulfillment(of: [useCase.subscribeExpectation], timeout: 2)
        XCTAssertEqual(useCase.subscribeCalled, 1)
    }

    func test_givenObservationEstablished_whenUseCaseSendsValue_thenLabelTextUpdated() async {
        let useCase = DetailUseCaseSpy()
        let sut = makeSUT(useCase: useCase)
        Task {
            await sut.setupRepositoryObservation()
        }
        await fulfillment(of: [useCase.subscribeExpectation], timeout: 1.0)

        await useCase.stream.update("New Value")

        let expectedResult = await sut.$labelText.values.first(where: { $0 == "New Value" })
        XCTAssertEqual(expectedResult, "New Value")
    }
}

private extension DetailViewModelTests {
    private func makeSUT(useCase: DetailUseCase) -> DetailViewModel {
        let sut = DetailViewModel(useCase: useCase)
        return sut
    }
}
