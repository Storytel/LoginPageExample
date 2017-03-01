//
//  LoginViewController.swift
//  storytel-ios
//
//  Created by Marina Gornostaeva on 15/11/2016.
//  Copyright © 2016 Storytel. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let viewModel: LoginViewModel
    
    var onLoginSucceeded: (() -> Void)?

    fileprivate let emailTextField: UITextField = UITextField()
    fileprivate let passwordTextField: UITextField = UITextField()
    fileprivate let loginButton = UIButton(type: UIButtonType.system)
        
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.emailTextField.translatesAutoresizingMaskIntoConstraints = false
        self.passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false

        self.emailTextField.placeholder = "Enter your email"
        self.emailTextField.keyboardType = UIKeyboardType.emailAddress
        self.emailTextField.returnKeyType = .next
        self.emailTextField.autocapitalizationType = .none
        self.emailTextField.autocorrectionType = .no
        self.emailTextField.borderStyle = .roundedRect
        self.emailTextField.addTarget(self, action: #selector(LoginViewController.emailChanged(sender:)), for: UIControlEvents.editingChanged)
        self.emailTextField.delegate = self

        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.placeholder = "Enter your password"
        self.passwordTextField.keyboardType = UIKeyboardType.default
        self.passwordTextField.returnKeyType = .go
        self.passwordTextField.borderStyle = .roundedRect
        self.passwordTextField.addTarget(self, action: #selector(LoginViewController.passwordChanged(sender:)), for: UIControlEvents.editingChanged)
        self.passwordTextField.delegate = self

        self.loginButton.setTitle("Log In", for: UIControlState.normal)
        self.loginButton.addTarget(self, action: #selector(LoginViewController.logInPressed(sender:)), for: UIControlEvents.touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [self.emailTextField, self.passwordTextField, self.loginButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 7
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        self.view.addSubview(stackView)
        
        let margins = self.view.layoutMarginsGuide
        stackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 15).isActive = true
        stackView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomLayoutGuide.topAnchor, constant: -15).isActive = true
        
        self.emailTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.passwordTextField.heightAnchor.constraint(equalTo: self.emailTextField.heightAnchor).isActive = true
        self.loginButton.heightAnchor.constraint(equalToConstant: 44).isActive = true

        self.updateUIState()
    }
    
    func emailChanged(sender: UITextField) {
        self.viewModel.emailChanged(email: sender.text)
    }
    
    func passwordChanged(sender: UITextField) {
        self.viewModel.passwordChanged(password: sender.text)
    }
    
    func logInPressed(sender: UIButton) {
        self.viewModel.login()
    }
    
    func updateUIState() {
        switch self.viewModel.state {
        case .idle:
            self.emailTextField.isEnabled = true
            self.passwordTextField.isEnabled = true
            self.loginButton.isEnabled = self.viewModel.isLoginEnabled
            self.loginButton.setTitle("Log In", for: UIControlState.normal)
        case .inProgress:
            self.emailTextField.isEnabled = false
            self.passwordTextField.isEnabled = false
            self.loginButton.isEnabled = false
            self.loginButton.setTitle("Logging In...", for: UIControlState.normal)
        case .done:
            self.emailTextField.isEnabled = true
            self.passwordTextField.isEnabled = true
            self.loginButton.isEnabled = self.viewModel.isLoginEnabled
            self.loginButton.setTitle("Logged In OK", for: UIControlState.normal)
            self.onLoginSucceeded?()
        }
    }
    
    func presentError(_ error: LoginError) {
        let alert = UIAlertController(title: error.title,
                                      message: error.message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertActionStyle.default,
                                      handler: { [weak alert] (action: UIAlertAction) in
                                        alert?.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController: LoginViewModelDelegate {
    func isLoginEnabledChanged(in viewModel: LoginViewModel) {
        self.updateUIState()
    }
    func stateChanged(in viewModel: LoginViewModel) {
        self.updateUIState()
    }
    func loginErrorOccurred(errorToDisplay: LoginError, in viewModel: LoginViewModel) {
        self.presentError(errorToDisplay)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        }
        else if textField == self.passwordTextField  {
            self.loginButton.sendActions(for: UIControlEvents.touchUpInside)
        }
        return false
    }
}

extension LoginError {
    
    var title: String {
        return "Login failed"
    }
    
    var message: String {
        switch self {
        case .badCredentials:
            return "Bad credentials"
        case .failure:
            return "Request failed"
        }
    }
}
