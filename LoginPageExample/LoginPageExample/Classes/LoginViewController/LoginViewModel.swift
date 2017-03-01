//
//  LoginViewModel.swift
//  storytel-ios
//
//  Created by Marina Gornostaeva on 15/11/2016.
//  Copyright © 2016 Storytel. All rights reserved.
//

import Foundation

enum LoginViewState {
    case idle
    case inProgress
    case done
}

protocol LoginViewModelDelegate: class {
    func isLoginEnabledChanged(in viewModel: LoginViewModel)
    func stateChanged(in viewModel: LoginViewModel)
    func loginErrorOccurred(errorToDisplay: LoginError, in viewModel: LoginViewModel)
}

class LoginViewModel {
    
    weak var delegate: LoginViewModelDelegate?
    let dataModel: LoginDataModel
    
    init(dataModel: LoginDataModel) {
        self.dataModel = dataModel
        self.dataModel.loginStateChangeHandler = { [weak self] in
            self?.notifyStateChanged()
        }
    }
    
    private var email: String = "" {
        didSet {
            self.notifyisLoginEnabledChanged()
        }
    }
    private var password: String = "" {
        didSet {
            self.notifyisLoginEnabledChanged()
        }
    }
    
    var state: LoginViewState {
        if self.dataModel.isLoginInProgress == true {
            return .inProgress
        }
        else if self.dataModel.hasFinishedLoggingIn == false {
            return .idle
        }
        else {
            return .done
        }
    }
    
    var isLoginEnabled: Bool {
        return self.email.characters.count > 0 && self.password.characters.count > 0
    }
    
    // MARK: Actions
    
    func emailChanged(email: String?) {
        self.email = email ?? ""
    }
    
    func passwordChanged(password: String?) {
        self.password = password ?? ""
    }
    
    func login() {
        guard self.isLoginEnabled else { return }
        self.dataModel.login(email: self.email, password: self.password, completion: { [weak self] (result: LoginResult) in
            switch result {
            case .failed(let error):
                self?.notifyLoginErrorOccurred(error: error)
            default:
                break
            }
        })
    }
    
    // MARK: Notifying
    
    private func notifyStateChanged() {
        self.delegate?.stateChanged(in: self)
    }
    private func notifyisLoginEnabledChanged() {
        self.delegate?.isLoginEnabledChanged(in: self)
    }
    private func notifyLoginErrorOccurred(error: LoginError) {
        self.delegate?.loginErrorOccurred(errorToDisplay: error, in: self)
    }
}
