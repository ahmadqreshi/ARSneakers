//
//  SignUpVC.swift
//  ARSneakers
//
//  Created by Ahmad Qureshi on 19/05/22.
//

import UIKit

class SignUpVC: UIViewController {
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    
    let signUpViewModel = SignUpViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpOpacity()
        setUpTapGesture()
        setUpBarButton()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillLayoutSubviews() {
        backgroundImage.roundCorners(radius: 20)
    }
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    func setUpOpacity() {
        let tintView = UIView()
        tintView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        tintView.frame = CGRect(x: 0, y: 0, width: backgroundImage.frame.width, height: backgroundImage.frame.height)
        backgroundImage.addSubview(tintView)
    }
    func setUpTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAnyWhere(sender:)))
        view.addGestureRecognizer(tap)
    }
    @objc func tapAnyWhere(sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            self.warningLabel.isHidden = true
        }
    }
    func setUpBarButton() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(systemName: "arrow.left")!, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        let barButtonLeft = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButtonLeft
    }
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUPBtnPressed(_ sender: UIButton) {
        guard let name = nameTextField.text , let email = emailTextField.text , let password = passTextField.text , let confirmPass = confirmPassTextField.text else { return }
        signUpViewModel.setDetails(name: name, email: email, pass: password, verifyPass: confirmPass)
        switch signUpViewModel.signUpInput() {
        case .correct :
            if UserDefaults.standard.valueExists(forKey: "User") {
                if let savedUserData = UserDefaults.standard.object(forKey: "User") as? Data {
                    let decoder = JSONDecoder()
                    if let savedUser = try? decoder.decode(UserData.self, from: savedUserData) {
                        if savedUser.email == email {
                            warningLabel.isHidden = false
                            warningLabel.text = "Email is Already Registered"
                            return
                        }
                    }
                }
            }
            let data = UserData(name: name, email: email, password: password)
            let encoder = JSONEncoder()
            if let encodedUser = try? encoder.encode(data) {
                UserDefaults.standard.set(encodedUser, forKey: "User")
            }
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC else { return }
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .incorrect:
            UIView.animate(withDuration: 0.2) {
                self.warningLabel.isHidden = false
            }
            warningLabel.text = signUpViewModel.inputErrorMessage
            return
        }
    }
}
