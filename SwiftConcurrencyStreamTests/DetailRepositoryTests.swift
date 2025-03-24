//
//  DetailRepositoryTests.swift
//  SwiftConcurrencyStreamTests
//
//  Created by Marek Pridal on 24.03.2025.
//

import Testing
@testable import SwiftConcurrencyStream

struct DetailRepositoryTests {

    @Test func givenSUT_whenConnectToStream_thenNilReceived() async throws {
        let sut = DetailRepositoryImp()

        let value = await sut.stream().first(where: { _ in true })??.compactMap { $0 }
        #expect(value == nil)
    }

    @Test func givenInitialData_whenConnectToStream_thenInitialDataReceived() async throws {
        let sut = DetailRepositoryImp(dataStream: CurrentValueAsyncStream<String?>.init("String"))

        let value = await sut.stream().first(where: { _ in true })
        #expect(value == "String")
    }

    @Test func givenConnectedStream_whenSave_thenStreamIsCalled() async throws {
        let sut = DetailRepositoryImp()
        let originalValue = await sut.stream().first(where: { _ in true })??.compactMap { $0 }

        await sut.save(value: "New value")

        let newValue = await sut.stream().first(where: { _ in true })
        #expect(originalValue == nil)
        #expect(newValue == "New value")
    }
}
