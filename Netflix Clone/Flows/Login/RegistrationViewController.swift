//
//  LoginViewController.swift
//  Netflix Clone
//
//  Created by Ann Yesip on 23.10.2022.
//
import UIKit
import Firebase

final class RegistrationViewController: UIViewController {
    
    var didSendEventClosure: ((RegistrationViewController.Event) -> Void)?
    
    var sinIn: Bool = true {
        didSet {
            repeatPasswordTextField.isHidden = sinIn
            print(sinIn)
        }
    }
    
    let viewModel: RegistrationViewModel = RegistrationViewModel()
    
    // MARK: - init UI
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
        
    }()
    
    private let emailTextField: UITextField = {
        let email = UITextField()
        email.translatesAutoresizingMaskIntoConstraints = false
        email.borderStyle = .roundedRect
        email.placeholder
        email.backgroundColor = .zeusColor.withAlphaComponent(0.7)
        email.textColor = .whiteColor
        email.clearButtonMode = .whileEditing
        email.returnKeyType = .done
        email.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGreyColor ]
        )
        return email
        
    }()
    
    private let passwordTextField: UITextField = {
        let password = UITextField()
        password.translatesAutoresizingMaskIntoConstraints = false
        password.isSecureTextEntry = true
        password.borderStyle = .roundedRect
        password.backgroundColor = .zeusColor.withAlphaComponent(0.7)
        password.textColor = .whiteColor
        password.clearButtonMode = .whileEditing
        password.returnKeyType = .done
        password.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGreyColor ]
        )
        return password
        
    }()
    
    private let repeatPasswordTextField: UITextField = {
        let password = UITextField()
        password.translatesAutoresizingMaskIntoConstraints = false
        password.placeholder = "Repeat Password"
        password.isSecureTextEntry = true
        password.borderStyle = .roundedRect
        password.backgroundColor = .zeusColor.withAlphaComponent(0.7)
        password.textColor = .whiteColor
        password.clearButtonMode = .whileEditing
        password.returnKeyType = .done
        password.attributedPlaceholder = NSAttributedString(
            string: "Repeat Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGreyColor ]
        )
        return password
        
    }()
    
    private let registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .redColor
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8.0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(
            self,
            action: #selector(handleSignUp),
            for: .touchUpInside
        )
        return button
    }()
    
    private let dontHaneAccButton: UIButton = {
        let button = UIButton()
        button.setTitle("I don't have an account", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8.0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(
            self,
            action: #selector(doUHaveAccChange),
            for: .touchUpInside
        )
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
        view.backgroundColor = .blackBackgroundColor
        setupContentView()
        setupTextFields()
        assignbackground()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self
        
        repeatPasswordTextField.isHidden = true
    }
    
    func assignbackground() {
        let background = UIImage(named: "openNetflixOnTV1")
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    // MARK: - Constraints
    private func setupContentView() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
        contentView.addSubview(stackView)
    }
    
    func setupTextFields() {
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(repeatPasswordTextField)
        stackView.addArrangedSubview(registrationButton)
        stackView.addArrangedSubview(dontHaneAccButton)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 40),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -40),
            stackView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    //MARK: - registration func
    
    @objc func handleSignUp() {
        viewModel.validateForm(
            sinIn: sinIn,
            email: emailTextField.text,
            password: passwordTextField.text,
            repeatPassword: repeatPasswordTextField.text) { [weak self] result in
                switch result {
                case .success(let success):
                    self?.didSendEventClosure?(.login)
                case .failure(let failure):
                    self?.showAlert(reason: failure.errorText)
                }
            }
    }
    
    @objc func doUHaveAccChange() {
        sinIn = !sinIn
        if !sinIn {
            dontHaneAccButton.setTitle("I already have an account", for: .normal)
            registrationButton.setTitle("Registration", for: .normal)
        } else {
            dontHaneAccButton.setTitle("I don't have an account", for: .normal)
            registrationButton.setTitle("Login", for: .normal)
        }
    }

    func showAlert(reason: String) {
        let alert = UIAlertController(title: "Error", message: reason, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    
    //MARK: - deinited
    deinit {
        print("\(self) deinited")
    }
}

//MARK: - Event extension
extension RegistrationViewController {
    enum Event {
        case login
    }
}


extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
}

// user 2
// TestUser2@test.test
// 123456789


// user 1
//TestUser1@test.test
//111111
