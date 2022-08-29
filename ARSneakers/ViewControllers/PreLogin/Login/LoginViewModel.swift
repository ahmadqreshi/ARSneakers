//
//  LoginViewModel.swift
//  ARSneakers
//
//  Created by Ahmad Qureshi on 19/05/22.
//

import Foundation
class LoginViewModel {
    // MARK: - Stored Properties
    private var email : String = ""
    private var password : String = ""
    var credentialsInputErrorMessage : String = ""

    // MARK: - Custom Methods
    func setCredentials(email: String, password: String) {
        self.email = email
        self.password = password
    }
    func credentialsInput() -> CredentialsInputStatus {
        if email.isEmpty && password.isEmpty {
            credentialsInputErrorMessage = "Please Enter Fields"
            return .incorrect
        } else if email.isEmpty {
            credentialsInputErrorMessage = "Please Enter Your Mail"
            return .incorrect
        } else if !email.isValidEmail() {
            credentialsInputErrorMessage = "Please Enter Valid Email ID"
            return .incorrect
        } else if password.isEmpty {
            credentialsInputErrorMessage = "Please Enter Your Password"
            return .incorrect
        } else {
            return .correct
        }
    }
}

extension LoginViewModel {
    enum CredentialsInputStatus {
        case correct
        case incorrect
    }
}
