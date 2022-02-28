// The MIT License (MIT)
// Copyright © 2022 Ivan Vorobei (hello@ivanvorobei.io)
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

import FirebaseMessaging

public enum SPFirebaseMessaging {
    
    public static func addFCMTokenDidChangeListener(_ listner: @escaping ( _ fcmToken: String?) -> Void) {
        MessagingService.shared.listenerClouser = listner
    }
    
    public static func removeFCMTokenDidChangeListener() {
        MessagingService.shared.listenerClouser = nil
    }
    
    private class MessagingService: NSObject, MessagingDelegate {
        
        // MARK: - MessagingDelegate
        
        func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
            listenerClouser?(fcmToken)
        }
        
        // MARK: - Singltone
        
        internal var listenerClouser: ((String?) -> Void)? = nil {
            didSet {
                if listenerClouser == nil {
                    Messaging.messaging().delegate = nil
                } else {
                    Messaging.messaging().delegate = MessagingService.shared
                }
            }
        }
        
        internal static var shared = MessagingService()
        private override init() { super.init() }
    }
    
}
