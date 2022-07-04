//
//  SignUpViewModel.swift
//  ARSneakers
//
//  Created by Ahmad Qureshi on 19/05/22.
//

import Foundation
class SignUpViewModel {
    // MARK: - Class Properties
    private var fullName : String = ""
    private var emailId : String = ""
    private var password : String = ""
    private var verifyPass : String = ""
    var inputErrorMessage : String = ""
    // MARK: - Custom Methods
    func setDetails(name : String, email: String, pass: String, verifyPass : String) {
        self.fullName = name
        self.emailId = email
        self.password = pass
        self.verifyPass = verifyPass
    }
    func signUpInput() -> SignUpInputStatus {
        if fullName.isEmpty && emailId.isEmpty && password.isEmpty {
            inputErrorMessage = "Please Provide Fields"
            return .incorrect
        } else if fullName.isEmpty {
            inputErrorMessage = "Please Enter Your Name"
            return .incorrect
        } else if emailId.isEmpty {
            inputErrorMessage = "Please Enter Your Email"
            return .incorrect
        } else if !emailId.isValidEmail() {
            inputErrorMessage = "Please Enter Valid Email ID"
            return .incorrect
        } else if password.isEmpty {
            inputErrorMessage = "Please Enter Password"
            return .incorrect
        } else if !password.isValidPassword() {
            inputErrorMessage = "Please Provide Strong Password"
            return .incorrect
        } else if password != verifyPass {
            inputErrorMessage = "Please match your Passwords"
            return .incorrect
        } else {
            return .correct
        }
    }
}

// MARK: - Check Status
extension SignUpViewModel {
    enum SignUpInputStatus {
        case correct
        case incorrect
    }
}
