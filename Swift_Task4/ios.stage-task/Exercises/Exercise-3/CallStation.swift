import Foundation

final class CallStation {
    private var addedUsers:Set<User> = Set()
    private var allCalls = [CallID:Call]()
}

extension CallStation: CallErrorAble {
    
    internal  func startCallError (_ user1: User, _ user2: User) throws {
        guard addedUsers.isSuperset(of: [user1,user2]) else {
            throw CallEndReason.error
        }
        guard !calls(user: user2).contains(where: {($0.status == .talk || $0.status == .calling)}) else {
            throw CallEndReason.userBusy
        }
    }
    
    internal  func answerCallError (_ user: User) throws {
        guard !allCalls.isEmpty  else {
            throw CallEndReason.error
        }
        guard allCalls.values.contains(where: {$0.outgoingUser == user}) else {
            throw CallEndReason.error
        }
    }
    
    internal   func endCallError(_ user: User) throws {
        guard !allCalls.isEmpty else {
            throw CallEndReason.error
        }
        guard allCalls.values.contains(where: {($0.incomingUser == user || $0.outgoingUser == user) && $0.status == .talk}) else {
            throw CallEndReason.cancel
        }
    }
  
}

extension CallStation: Station {
    
    func users() -> [User] {
        return Array(addedUsers)
    }
    
    func add(user: User) {
        addedUsers.insert(user)
    }
    
    func remove(user: User) {
        addedUsers.remove(user)
    }
    
    func execute(action: CallAction) -> CallID? {
        switch action {
        case let .start(from: user1, to: user2):
            guard addedUsers.contains(user1) || addedUsers.contains(user2) else {
                return nil
            }
            do {
                try startCallError(user1, user2)
                let call = Call(id: CallID(), incomingUser: user1, outgoingUser: user2, status: .calling)
                allCalls[call.id] = call
                return call.id
            } catch CallEndReason.error {
                let call = Call(id: CallID(), incomingUser: user1, outgoingUser: user2, status: .ended(reason: .error))
                allCalls[call.id] = call
                return call.id
            } catch CallEndReason.userBusy {
                let call = Call(id: CallID(), incomingUser: user1, outgoingUser: user2, status: .ended(reason: .userBusy))
                allCalls[call.id] = call
                return call.id
            } catch {
                return nil
            }
            
        case let .answer(from: user2):
            guard addedUsers.contains(user2) else {
                for call in allCalls.values {
                    if call.outgoingUser == user2 && call.status == .calling {
                        let newStatus = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: .ended(reason: .error))
                        allCalls[call.id] = newStatus
                    }
                }
                return nil
            }
            do {
                try answerCallError(user2)
                for call in allCalls.values {
                    if call.outgoingUser == user2 {
                        let newStatusCall = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: .talk)
                        allCalls[call.id] = newStatusCall
                        return newStatusCall.id
                    }
                }
            } catch {
                return nil
            }
            
        case let .end(from: user):
            do {
                try endCallError(user)
                for call in allCalls.values {
                   if call.incomingUser == user || call.outgoingUser == user {
                    let newStatusCall = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: .ended(reason: .end))
                    allCalls[call.id] = newStatusCall
                    return newStatusCall.id
                   }
                }
            } catch CallEndReason.cancel {
                for call in allCalls.values {
                   if call.incomingUser == user || call.outgoingUser == user {
                    let newStatusCall = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: .ended(reason: .cancel))
                    allCalls[call.id] = newStatusCall
                    return newStatusCall.id
                   }
                }
            } catch {
                return nil
            }
        }
        return nil
    }
    func calls() -> [Call] {
        return [Call](allCalls.values)
    }
    
    func calls(user: User) -> [Call] {
        var array = [Call]()
        for calls in allCalls.values {
            if calls.incomingUser == user || calls.outgoingUser == user {
                array += [calls]
            }
        }
        return array
    }
    
    func call(id: CallID) -> Call? {
        if let call = allCalls[id] {
            return call
        } else {
            return nil
        }
    }
    
    func currentCall(user: User) -> Call? {
        var call: Call? {
            get { for call in allCalls.values {
                if (call.incomingUser == user || call.outgoingUser == user) && (call.status == .calling || call.status == .talk) {
                    return call
                }
            }
            return nil
            }
        }
        return call
    }
}
