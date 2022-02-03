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

import UIKit

public enum SPFirebaseAuth {
    
    // MARK: - Data
    
    public static var userID: String? { FirebaseAuthService.userID }
    public static var userName: String? { FirebaseAuthService.userName }
    public static var userEmail: String? { FirebaseAuthService.userEmail }
    public static var isAnonymous: Bool? { FirebaseAuthService.isAnonymous }
    
    // MARK: - Init
    
    public static func configure(authDidChangedWork: @escaping ()->Void) {
        debug("Start configure.")
        // Save cached userID.
        cached_user_id = self.userID
        // Listner Events
        FirebaseAuthService.configure(authDidChangedWork: {
            if let newUserID = self.userID {
                if cached_user_id != newUserID {
                    debug("Event, new userID is \(newUserID).")
                    cached_user_id = newUserID
                    authDidChangedWork()
                }
            } else {
                if cached_user_id != nil {
                    debug("Event, user not authed now.")
                    cached_user_id = nil
                    authDidChangedWork()
                }
            }
        })
        
        if let userID = self.userID {
            debug("Current userID is \(userID).")
        } else {
            debug("User not authed.")
        }
    }
    
    @available(iOS 13.0, *)
    public static func signInApple(on controller: UIViewController, completion: @escaping (SPFirebaseAuthData?, SPFirebaseAuthError?) -> Void) {
        guard let window = controller.view.window else {
            completion(nil, .cantPresent)
            return
        }
        AppleAuthService.signIn(on: window) { data in
            guard var authData = data else {
                completion(nil, .canceled)
                return
            }
            FirebaseAuthService.signInApple(token: authData.token, completion: { error in
                if let error = error {
                    debug("Sign In with Apple faild with error: \(error.localizedDescription).")
                    completion(nil, .faild)
                } else {
                    debug("Sign In with Apple success with name: \(authData.name ?? "Can't get name").")
                    // Set email if Apple can't return it.
                    if authData.email == nil {
                        authData.email = FirebaseAuthService.userEmail
                    }
                    // Set name if Apple can't return it.
                    if authData.name == nil {
                        authData.name = FirebaseAuthService.userName
                    }
                    completion(authData, nil)
                }
            })
        }
    }
    
    public static func signInAnonymously(completion: @escaping (SPFirebaseAuthError?) -> Void) {
        FirebaseAuthService.signInAnonymously(comlection: { error in
            if let error = error {
                debug("Sign In Anonymously faild with error: \(error.localizedDescription).")
                completion(.faild)
            } else {
                debug("Sign In Anonymously success.")
                completion(nil)
            }
        })
    }
    
    public static func signOut(completion: @escaping (SPFirebaseAuthError?)->Void) {
        FirebaseAuthService.signOut(completion: { error in
            if let error = error {
                debug("Sign Out faild with error: \(error.localizedDescription).")
                completion(.faild)
            } else {
                completion(nil)
            }
        })
    }
    
    // MARK: - Private
    
    static func debug(_ text: String) {
        print("SPFirebaseAuth: \(text)")
    }
    
    static var cached_user_id: String? {
        get { UserDefaults.standard.string(forKey: "auth_service_cached_user_id") }
        set { UserDefaults.standard.set(newValue, forKey: "auth_service_cached_user_id") }
    }
}
