//
//  AuthorizationViewController.swift
//  NewsBox
//
//  Created by REEMOTTO on 14.02.23.
//

import UIKit
import LocalAuthentication

final class AuthorizationViewController: UIViewController {
    
    // MARK: - Properties
    
    let defaults = UserDefaults.standard
    
    // MARK: - Subviews
    
    private let appIcon = UIImageView()
    private let signInLabel = UILabel()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let visabilityButton = UIButton()
    private let signInButton = UIButton()
    
    lazy var safeArea = view.safeAreaLayoutGuide
    
    // MARK: - Initializers
    
    deinit {
        print("Deinit ViewController")
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = whiteMainColor
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        setup()
        loggedIn()
        
        emailTextField.text = defaults.string(forKey: "email")
        passwordTextField.text = defaults.string(forKey: "password")
    }
    
    // MARK: -  Methods
    
    private func setup() {
        configureAppIcon()
        buildHierarchy()
        configureSubviews()
        layoutSubviews()
    }
    
    private func configureAppIcon() {
        view.addSubview(appIcon)
        appIcon.image = UIImage(named: "logo_vertical")
        appIcon.contentMode = .scaleAspectFit
    }
    
    private func buildHierarchy() {
        view.addSubview(appIcon)
        view.addSubview(signInLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
    }
    
    private func configureSubviews() {
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        signInLabel.text = "Sign in with email"
        signInLabel.textColor = mainTextBlackColor
        signInLabel.textAlignment = .center
        signInLabel.font = .boldSystemFont(ofSize: 18.0)
        signInLabel.numberOfLines = 0
        signInLabel.clipsToBounds = true
        
        emailTextField.placeholder = "e-mail"
        emailTextField.borderStyle = .roundedRect
        emailTextField.clearButtonMode = .always
        emailTextField.keyboardType = .emailAddress
        
        passwordTextField.placeholder = "password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.textContentType = .password
        passwordTextField.isSecureTextEntry = true
        passwordTextField.rightView = visabilityButton
        passwordTextField.rightViewMode = .always
        passwordTextField.keyboardType = .asciiCapable
        
        visabilityButton.setImage(UIImage(named: "show"), for: .normal)
        visabilityButton.setImage(UIImage(named: "hide"), for: .selected)
        visabilityButton.imageEdgeInsets = UIEdgeInsets(top: 4.0, left: -12.0, bottom: -4.0, right: 0)
        visabilityButton.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        
        signInButton.setTitle("Sign in".uppercased(), for: .normal)
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.backgroundColor = .black
        signInButton.layer.cornerRadius = 15
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
    }
    
    private func layoutSubviews() {
        
        appIcon.translatesAutoresizingMaskIntoConstraints = false
        appIcon.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 60.0).isActive = true
        appIcon.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 40.0).isActive = true
        appIcon.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -40.0).isActive = true
        appIcon.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        signInLabel.translatesAutoresizingMaskIntoConstraints = false
        signInLabel.topAnchor.constraint(equalTo: appIcon.bottomAnchor, constant: 40.0).isActive = true
        signInLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 20.0).isActive = true
        signInLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20.0).isActive = true
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.topAnchor.constraint(equalTo: signInLabel.bottomAnchor, constant: 20.0).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 20.0).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20.0).isActive = true
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20.0).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 20.0).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20.0).isActive = true
        
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20.0).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        signInButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 120.0).isActive = true
        signInButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -120.0).isActive = true
    }
    // MARK: - Handlers
    
    @objc func togglePasswordView(_ sender: Any) {
        passwordTextField.isSecureTextEntry.toggle()
        visabilityButton.isSelected.toggle()
    }
    
    private func loggedIn() {
        
        if (UserDefaults.standard.string(forKey: "email") != nil) && UserDefaults.standard.string(forKey: "password") != nil {
            faceIdAdd()
        } else {
            // userDefault is nil (empty)
        }
    }
    
    private func saveToUserDefaults() {
        defaults.set(emailTextField.text, forKey: "email")
        defaults.set(passwordTextField.text, forKey: "password")
    }
    
    private func checkTextfields() {
        
        if emailTextField.text?.isEmpty ?? true {
            print("email is empty")
            signInButton.isEnabled = false
        } else if passwordTextField.text?.isEmpty ?? true {
            print("password empty")
            signInButton.isEnabled = false
        } else {
            validateEmail()
            validatePassword()
            signInButton.isEnabled = true
        }
    }
    
    private func validateEmail() {
        if (emailTextField.text?.isEmail())! {
            print("Okay Email go ahead")
        } else {
            print("email bad")
            let alert = UIAlertController(title: "Registration error: Please enter a valid email address", message: "Please try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    private func validatePassword() {
        if (passwordTextField.text?.isValidPassword())! {
            print("Password is okay")
        } else {
            print("bad password")
            let alert = UIAlertController(title: "Registration error: Please enter a valid password", message: "Please try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    private func faceIdAdd() {
        let context = LAContext()
        var error: NSError? = nil
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                     error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Please authorize with touch id!") { [weak self] success, error in
                DispatchQueue.main.async {
                    guard success, error == nil else {
                        let alert = UIAlertController(title: "Failed to Authorize", message: "Please try again", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                        self?.present(alert, animated: true)
                        return }
                    self?.present(TabBarController(), animated: true)
                }
            }
        } else {
            let alert = UIAlertController(title: "Unavailable", message: "You cant use this feature", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dissmis", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }
    
    @objc private func signInButtonTapped() {
        
        checkTextfields()
        saveToUserDefaults()
        openTabBarController()
        
    }
    
    private func openTabBarController() {
        
        self.present(TabBarController(), animated: true)
        
    }
}
// MARK: - UITextFieldDelegate

extension AuthorizationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
            visabilityButton.isHidden = false
        } else {
            resignFirstResponder()
        }
        return true
    }
}
