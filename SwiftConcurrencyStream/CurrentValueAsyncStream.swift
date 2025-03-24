import Foundation

actor CurrentValueAsyncStream<T: Sendable> {
    private var currentValue: T
    private var continuations: [AsyncStream<T>.Continuation] = []
    
    init(_ initialValue: T) {
        self.currentValue = initialValue
    }

    deinit {
        print("Deinit of \(self)")
    }

    func update(_ value: T) {
        currentValue = value
        for continuation in continuations {
            continuation.yield(value)
        }
    }
    
    func stream() -> AsyncStream<T> {
        return AsyncStream { continuation in
            self.continuations.append(continuation)
            continuation.yield(currentValue) // Emit current value immediately
            
            // Handle cleanup when the consumer finishes
            continuation.onTermination = { [weak self] _ in
                Task { await self?.removeContinuation(continuation) }
            }
        }
    }
    
    private func removeContinuation(_ continuation: AsyncStream<T>.Continuation) {
        // Referencing operator function '==' on 'Equatable' requires that 'AsyncStream<T>.Continuation' conform to 'Equatable'
        //continuations.removeAll { $0 == continuation }
    }
}
