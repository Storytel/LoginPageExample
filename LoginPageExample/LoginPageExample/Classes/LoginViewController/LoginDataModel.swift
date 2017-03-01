//
//  LoginDataModel.swift
//  storytel-ios
//
//  Created by Marina Gornostaeva on 15/11/2016.
//  Copyright © 2016 Storytel. All rights reserved.
//

import Foundation

enum LoginError : Error {
    case badCredentials
    case failure
}

enum LoginResult {
    case finished
    case failed(error: LoginError)
    
    var isFinished: Bool {
        switch self {
        case .finished: return true
        case .failed(_): return false
        }
    }
}

protocol LoginDataModel: class {
    func login(email: String, password: String, completion: @escaping ((_ result: LoginResult) -> Void))
    var isLoginInProgress: Bool { get }
    var hasFinishedLoggingIn: Bool { get }
    var loginStateChangeHandler: (() -> Void)? { get set }
}

class LoginAuthDataModel: LoginDataModel {
    
    var isLoginInProgress: Bool = false
    var hasFinishedLoggingIn: Bool = false
    var loginStateChangeHandler: (() -> Void)?
    
    init() {
    }

    func login(email: String, password: String, completion: @escaping ((_ result: LoginResult) -> Void)) {
        self.startLoggingIn()
        
        let randomRequestDuration = Int(arc4random_uniform(5000) + 300) // random from 300 to 5299
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(randomRequestDuration)) { [weak self] in
            guard let sself = self else { return }
            
            let result: LoginResult
            if email == "test@storytel.com" && password == "test" {
                result = LoginResult.finished
            }
            else {
                result = LoginResult.failed(error: LoginError.badCredentials)
            }

            sself.finishLoggingIn(success: result.isFinished)
            completion(result)
        }
    }
    
    private func startLoggingIn() {
        self.isLoginInProgress = true
        self.loginStateChangeHandler?()
    }
    
    private func finishLoggingIn(success: Bool) {
        self.isLoginInProgress = false
        self.hasFinishedLoggingIn = success
        self.loginStateChangeHandler?()
    }
}
