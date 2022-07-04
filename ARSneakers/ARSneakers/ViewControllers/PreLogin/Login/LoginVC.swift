//
//  LoginVC.swift
//  ARSneakers
//
//  Created by Ahmad Qureshi on 19/05/22.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let loginViewModel = LoginViewModel()
    var loggedUser = UserData(name: "", email: "", password: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpOpacity()
        setUpDelegates()
        setUpTapGesture()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillLayoutSubviews() {
        backImage.roundCorners(radius: 20)
    }
    func setUpTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAnyWhere(sender:)))
        view.addGestureRecognizer(tap)
    }
    func setUpDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    func setUpOpacity() {
        let tintView = UIView()
        tintView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        tintView.frame = CGRect(x: 0, y: 0, width: backImage.frame.width, height: backImage.frame.height)
        backImage.addSubview(tintView)
    }
    @objc func tapAnyWhere(sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.2) {
            self.warningLabel.isHidden = true
        }
    }
    @IBAction func logInBtnPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        loginViewModel.setCredentials(email: email, password: password)
        switch loginViewModel.credentialsInput() {
        case .correct:
            if UserDefaults.standard.valueExists(forKey: "User") {
                if let savedUserData = UserDefaults.standard.object(forKey: "User") as? Data {
                    let decoder = JSONDecoder()
                    if let savedUser = try? decoder.decode(UserData.self, from: savedUserData) {
                        loggedUser = savedUser
                        if loggedUser.email == email && loggedUser.password == password {
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            guard let vc = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC else { return }
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else if loggedUser.email == email && loggedUser.password != password {
                            warningLabel.isHidden = false
                            warningLabel.text = "Incorrect Password"
                        } else {
                            warningLabel.isHidden = false
                            warningLabel.text = "User Does not exist"
                        }
                    }
                }
            } else {
                warningLabel.isHidden = false
                warningLabel.text = "user does not exist"
            }
        case .incorrect:
            UIView.animate(withDuration: 0.2) {
                self.warningLabel.isHidden = false
            }
            warningLabel.text = loginViewModel.credentialsInputErrorMessage
            return
        }
    }
    
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension LoginVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        warningLabel.isHidden = true
    }
    
}

extension UserDefaults {
    func valueExists(forKey key: String) -> Bool {
        return object(forKey: key) != nil
    }
}
