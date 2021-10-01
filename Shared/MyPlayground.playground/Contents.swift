import Alamofire
import Foundation

func asyncPrint() async throws {
    let _: Int = try await withCheckedThrowingContinuation { continuation in
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            print("Hello")
            continuation.resume(returning: 1)
        }
    }
    print("Vu")
}

Task {
    try await asyncPrint()
}
