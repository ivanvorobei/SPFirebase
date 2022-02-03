// The MIT License (MIT)
// Copyright © 2022 Ivan Vorobei (hello@ivanvorobei.by)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import FirebaseFirestore

public enum SPFirebaseFirestoreError {
    
    case OK
    case cancelled
    case unknown
    case invalidArgument
    case deadlineExceeded
    case notFound
    case alreadyExists
    case permissionDenied
    case resourceExhausted
    case failedPrecondition
    case aborted
    case outOfRange
    case unimplemented
    case `internal`
    case unavailable
    case dataLoss
    case unauthenticated
    
    public static func get(by error: Error) -> SPFirebaseFirestoreError {
        let error = error as NSError
        guard error.domain == FirestoreErrorDomain else{
            return .unknown
        }
        let code = FirestoreErrorCode(rawValue: error.code)!
        switch code {
        case .OK: return .OK
        case .cancelled: return .cancelled
        case .unknown: return .unknown
        case .invalidArgument: return .invalidArgument
        case .deadlineExceeded: return .deadlineExceeded
        case .notFound: return .notFound
        case .alreadyExists: return .alreadyExists
        case .permissionDenied: return .permissionDenied
        case .resourceExhausted: return .resourceExhausted
        case .failedPrecondition: return .failedPrecondition
        case .aborted: return .aborted
        case .outOfRange: return .outOfRange
        case .unimplemented: return .unimplemented
        case .internal: return .internal
        case .unavailable: return .unavailable
        case .dataLoss: return .dataLoss
        case .unauthenticated: return .unauthenticated
        @unknown default: return .unknown
        }
    }
}
