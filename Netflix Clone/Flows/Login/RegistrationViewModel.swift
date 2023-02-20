//
//  RegistrationViewModel.swift
//  Netflix Clone
//
//  Created by mac on 13.01.2023.
//

import Foundation
import Firebase

class RegistrationViewModel {
    
    enum Reason: Error {
        case passwordsAreNotTheSame
        case wrongPassword
        case unknownError
        
        var errorText: String {
            switch self {
            case .passwordsAreNotTheSame:
                return "Passwords are not the same"
            case .wrongPassword:
                return "Wrong password"
            case .unknownError:
                return "Unknown Error"
            }
        }
        
    }
    
    func validateForm(
        sinIn: Bool,
        email: String?,
        password: String?,
        repeatPassword: String?,
        complition: @escaping (Result<AuthDataResult, Reason>
) -> Void) {
        guard let email = email else { return }
        guard let password = password else { return }
        guard let repeatPassword = repeatPassword else { return }
        
        if sinIn { // auth
            if (!email.isEmpty && !password.isEmpty) {
                Auth.auth().signIn(withEmail: email, password: password) { (result, error)  in
                    if error == nil {
                        if let result = result {
                            complition(.success(result))
                            print("we are auth !!!")
                        }
                    } else {
                        complition(.failure(Reason.wrongPassword))
                    }
                }
            }
        } else  { //registration
            if (!email.isEmpty && !password.isEmpty && !repeatPassword.isEmpty) {
                guard password == repeatPassword else {
                    complition(.failure(Reason.passwordsAreNotTheSame))
                    return
                }
                
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if error == nil {
                        if let result = result {
                            print(result.user.uid)
                            let ref = Database.database().reference().child("users")
                            ref.child(result.user.uid).updateChildValues(["name": email, "password" : password])
                            complition(.success(result))
                        }
                    }
                }
            } else {
                complition(.failure(Reason.unknownError))
            }
        }
        
        
    }
}
