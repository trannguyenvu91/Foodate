import Alamofire
import Combine
import Foundation

var cancellables = Set<AnyCancellable>()

let randomNumberGenerator = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
        .map { _ in Int.random(in: 1...100) }
        .share()

randomNumberGenerator
    .sink { number in
        print(number)
    }
    .store(in: &cancellables)

randomNumberGenerator
    .sink { number in
        print(number)
    }
    .store(in: &cancellables)

