import SwiftUI

private struct AsyncViewDidLoadModifier: ViewModifier {
    @State private var didLoad = false
    let action: () async -> Void

    func body(content: Content) -> some View {
        content.task {
            guard !didLoad else { return }
            didLoad = true
            await action()
        }
    }
}

extension View {
    func onLoadAsync(perform action: @escaping (() async -> Void)) -> some View {
        modifier(AsyncViewDidLoadModifier(action: action))
    }
}
