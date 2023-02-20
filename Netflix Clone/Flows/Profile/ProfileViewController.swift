//
//  ProfileViewController.swift
//  Netflix Clone
//
//  Created by mac on 29.01.2023.
//

import UIKit
import Firebase

final class ProfileViewController: UIViewController {
    
    weak var coordinator: TabCoordinator?
    
    // MARK: - init UI
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "userPhoto")
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.text = "Hello, User!"
        userNameLabel.contentMode = .scaleAspectFill
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.textColor = .whiteColor
        userNameLabel.numberOfLines = 0
        return userNameLabel
    }()
    
    private let signOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Out", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(
            self,
            action: #selector(logOutAction),
            for: .touchUpInside
        )
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = .blackBackgroundColor
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - setupUI
    private func setupUI() {
        view.addSubview(contentView)
        setupContentView()
        setupUserImageView()
        setupUserNameLabel()
        setupSignOutButton()
        sayHelloYoUser()
        
    }
    
    func sayHelloYoUser() {
        guard let userEmail = Auth.auth().currentUser?.email else { return }
        userNameLabel.text = "Hello, \(userEmail)👋🏼"
    }
    
    // MARK: - Constraints
    private func setupContentView() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
        
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(signOutButton)
    }
    
    private func setupUserImageView() {
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 80),
            userImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            userImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            userImageView.heightAnchor.constraint(equalTo: userImageView.widthAnchor)
            
        ])
    }
    
    private func setupUserNameLabel() {
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 50),
            userNameLabel.centerXAnchor.constraint(equalTo: userImageView.centerXAnchor),
            userNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7)
        ])
    }
    
    private func setupSignOutButton() {
        NSLayoutConstraint.activate([
            signOutButton.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 50),
            signOutButton.centerXAnchor.constraint(equalTo: userImageView.centerXAnchor),
            signOutButton.widthAnchor.constraint(equalToConstant: 100),
            signOutButton.heightAnchor.constraint(equalTo: signOutButton.widthAnchor, multiplier: 0.4)
        ])
    }
    
    @objc func logOutAction() {
        do {
            try Auth.auth().signOut()
            coordinator?.finish()
        } catch {
            print(error.localizedDescription)
        }
    }
}
