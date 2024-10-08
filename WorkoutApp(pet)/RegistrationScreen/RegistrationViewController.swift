//
//  RegistrationViewController.swift
//  WorkoutApp(pet)
//
//  Created by Danilius on 03.02.2024.
//

import UIKit
import FirebaseAuth

final class RegistrationViewController: UIViewController {
    
    //MARK: - Variables
    
    private let router: Router
    private let viewModel: RegistrationViewModel
    
    private let registrationLabel = RegistrationLabel()
    private let nameField = RegistrationCustomTextField(fieldType: .name)
    private let lastNameField = RegistrationCustomTextField(fieldType: .lastName)
    private let emailField = RegistrationCustomTextField(fieldType: .email)
    private let passwordField = RegistrationCustomTextField(fieldType: .password)
    private let confirmPasswordField = RegistrationCustomTextField(fieldType: .confirmPassword)
    private let regSighUpButton = SignUpButton()
    private let navBarButton = CustomNavBarButton(type: .back)
    
    private var textFieldArray = [UITextField]()
    //MARK: - UIComponents
    
    private lazy var textFieldStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameField, lastNameField,
                                                   emailField, passwordField,
                                                   confirmPasswordField])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        return stack
    }()
    //MARK: - Lifecycle
    init(router: Router, viewModel: RegistrationViewModel) {
        self.router = router
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarAppearance()
        setupUI()
        setupTextFieldDelegate()
        setupActions()
        setupLayout()
        createTextFieldArray()
        setupHideKeyboardOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}
//MARK: - UI Setup

private extension RegistrationViewController {
    
    func navigationBarAppearance() {
        title = Const.signUp
        
        view.backgroundColor = ColorResources.white
        
        let backButton = UIBarButtonItem(customView: navBarButton)
        navBarButton.setTitle(Const.back, for: .normal)
        navBarButton.frame = CGRect(x: 0, y: 0, width: 70, height: 25)
        navBarButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = backButton
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : ColorResources.black]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : FontResources.boldSystemFont26]
        
    }
    
    @objc func backTapped() {
        self.router.popScreen(from: navigationController)
    }
    
    func setupUI() {
        setupViews(registrationLabel, textFieldStack, regSighUpButton)
    }
    
    func setupTextFieldDelegate() {
        nameField.delegate = self
        lastNameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
    }
    
    func setupActions() {
        regSighUpButton.signUpTapped = {
            if ValidateField.voidValidateFields(textFields: self.textFieldArray) {
                guard let firstName = self.nameField.text, !firstName.isEmpty ,
                      let lastName = self.lastNameField.text, !lastName.isEmpty,
                      let email = self.emailField.text, !email.isEmpty,
                      let password = self.passwordField.text, !password.isEmpty,
                      let confirmPassword = self.confirmPasswordField.text, !confirmPassword.isEmpty else {
                    return
                }
                
                self.viewModel.registerUser(firstName: firstName, lastName: lastName, email: email, password: password, confirmPassword: confirmPassword) { [weak self] user, error in
                    guard let self = self else { return }
                    if let error = error {
                        self.showAlert(message: error)
                    } else if user != nil {
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        self.router.navigateToTabBar(from: navigationController)
                    }
                }
            } else {
                self.showAlert(message: Const.fillAllFields)
            }
        }
    }
    
    func setupLayout() {
        
        NSLayoutConstraint.activate([
            registrationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            registrationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            
            textFieldStack.topAnchor.constraint(equalTo: registrationLabel.bottomAnchor, constant: 30),
            textFieldStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textFieldStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            regSighUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            regSighUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            regSighUpButton.widthAnchor.constraint(equalToConstant: 335),
            regSighUpButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func createTextFieldArray() {
        textFieldArray.append(nameField)
        textFieldArray.append(lastNameField)
        textFieldArray.append(emailField)
        textFieldArray.append(passwordField)
        textFieldArray.append(confirmPasswordField)
    }
}

//MARK: - Closing keyboard after filling all textfields
extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameField:
            lastNameField.becomeFirstResponder()
        case lastNameField:
            emailField.becomeFirstResponder()
        case emailField:
            passwordField.becomeFirstResponder()
        case passwordField:
            confirmPasswordField.becomeFirstResponder()
        case confirmPasswordField:
            view.endEditing(true)
        default:
            break
        }
        return true
    }
}

