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
import AuthenticationServices

@available(iOS 13.0, *)
class AppleAuthService: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    static func signIn(on window: UIWindow, completion: ((SPFirebaseAuthData?) -> Void)?) {
        shared.completion = completion
        shared.window = window
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = shared
        authorizationController.presentationContextProvider = shared
        authorizationController.performRequests()
    }
    
    // MARK: - ASAuthorizationControllerDelegate
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        guard let identityToken = appleCredential.identityToken else { return }
        guard let token = String(data: identityToken, encoding: .utf8) else { return }
        let name: String? = {
            guard let fullName = appleCredential.fullName else { return nil }
            let familyName = fullName.familyName
            let givenName = fullName.givenName
            if familyName != nil && givenName != nil {
                return givenName! + " " + familyName!
            }
            if familyName != nil {
                return familyName
            }
            if givenName != nil {
                return givenName
            }
            return nil
        }()
        let data = SPFirebaseAuthData(token: token, name: name, email: appleCredential.email)
        completion?(data)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        completion?(nil)
    }
    
    // MARK: - ASAuthorizationControllerPresentationContextProviding
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = self.window else { fatalError("Can't get root window") }
        return window
    }
    
    // MARK: - Singltone
    
    private weak var window: UIWindow?
    private var completion: ((SPFirebaseAuthData?) -> Void)?
    
    static let shared = AppleAuthService()
    private override init() {}
}
