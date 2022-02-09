import Foundation
import Firebase

public enum SPFirebaseFirestoreSource {
    
    // Get actually, if faild ge cached
    case `default`
    
    // Get actually, if faild error
    case actuallyOnly
    
    // Get cached, if no cached error
    case cachedOnly
    
    // Gey cached, if faild get actually
    case cachedFirst
    
    public var firestore: FirestoreSource {
        switch self {
        case .`default`: return .`default`
        case .actuallyOnly: return .server
        case .cachedOnly: return .cache
        case .cachedFirst: return .cache
        }
    }
}
