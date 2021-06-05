import Foundation

protocol Station {
    func users() -> [User] // All added users
    func add(user: User)
    func remove(user: User)

    func execute(action: CallAction) -> CallID?

    func calls() -> [Call] // All calls
    func calls(user: User) -> [Call]

    func call(id: CallID) -> Call?
    func currentCall(user: User) -> Call? // .calling or .talk call
}

protocol CallErrorAble {
    func startCallError (_ user1: User, _ user2: User) throws
    func answerCallError (_ user: User) throws
    func endCallError(_ user: User) throws
}


enum CallAction {
    case start(from: User, to: User)
    case answer(from: User)
    case end(from: User)
}

