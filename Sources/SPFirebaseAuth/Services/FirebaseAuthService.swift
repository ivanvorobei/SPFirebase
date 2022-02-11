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

import FirebaseAuth

class FirebaseAuthService {
    
    // MARK: - Data
    
    static var userID: String? { Auth.auth().currentUser?.uid }
    static var userName: String? { Auth.auth().currentUser?.displayName }
    static var userEmail: String? { Auth.auth().currentUser?.email }
    static var isAnonymous: Bool? { Auth.auth().currentUser?.isAnonymous }
    
    // MARK: - Init
    
    static func configure(authDidChangedWork: @escaping ()->Void) {
        if let observer = shared.observer {
            Auth.auth().removeStateDidChangeListener(observer)
        }
        shared.observer = Auth.auth().addStateDidChangeListener { auth, user in
            authDidChangedWork()
        }
    }
    
    // MARK: - Actions
    
    static func signInApple(token: String, completion: @escaping (Error?) -> Void) {
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: token, rawNonce: nil)
        Auth.auth().signIn(with: credential) { (result, error) in
            completion(error)
        }
    }
    
    static func signInAnonymously (comlection: @escaping (Error?) -> Void) {
        Auth.auth().signInAnonymously { authResult, error in
            comlection(error)
        }
    }
    
    static func signOut(completion: @escaping (Error?)->Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    static func delete(completion: @escaping (Error?)->Void) {
        let user = Auth.auth().currentUser
        user?.delete(completion: { error in
            completion(error)
        })
    }
    
    // MARK: - Singltone
    
    private var observer: AuthStateDidChangeListenerHandle?
    private static let shared = FirebaseAuthService()
    
    private init() {}
}
