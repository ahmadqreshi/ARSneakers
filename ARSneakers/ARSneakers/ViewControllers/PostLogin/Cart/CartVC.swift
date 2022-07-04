//
//  CartVC.swift
//  ARSneakers
//
//  Created by Ahmad Qureshi on 20/05/22.
//

import UIKit

class CartVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cartCollectionView: UICollectionView!
    @IBOutlet weak var billingAmountLabel: UILabel!
    @IBOutlet weak var cardDetailTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBarButton()
        setUpDelegate()
        setUpCollectionViewCell()
        closureDefinition()
        setUpName()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    override func viewWillAppear(_ animated: Bool) {
        setUpBillingAmount()
        cartCollectionView.reloadData()
    }
    func closureDefinition() {
        removeCartItem = {
            self.cartCollectionView.reloadData()
            self.setUpBillingAmount()
        }
    }
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    func setUpDelegate() {
        cartCollectionView.delegate = self
        cartCollectionView.dataSource = self
        cardDetailTextField.delegate = self
    }
    func setUpBarButton() {
        self.navigationController?.navigationBar.isHidden = false
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .black
        let button2 = UIButton(type: .custom)
        button2.setImage(UIImage(systemName: "power"), for: .normal)
        button2.tintColor = .black
        button2.addTarget(self, action: #selector(logOutButtonPressed), for: .touchUpInside)
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        let barButtonLeft = UIBarButtonItem(customView: button)
        let barButtonRight = UIBarButtonItem(customView: button2)
        self.navigationItem.leftBarButtonItem = barButtonLeft
        self.navigationItem.rightBarButtonItem = barButtonRight
    }
    func setUpCollectionViewCell() {
        let nib = UINib(nibName: "CartCollectionViewCell", bundle: nil)
        self.cartCollectionView.register(nib, forCellWithReuseIdentifier: "CartCollectionViewCell")
    }
    func setUpName() {
        if let savedUserData = UserDefaults.standard.object(forKey: "User") as? Data {
            let decoder = JSONDecoder()
            if let savedUser = try? decoder.decode(UserData.self, from: savedUserData) {
                nameLabel.text = savedUser.name
            }
        }
    }
    func setUpBillingAmount() {
        var amount = Int()
        DataBase.shared.cartData.forEach { item in
            if let number = Int(item.productPrice.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
                amount += number
            }
        }
        billingAmountLabel.text = "Your Billing Amount : ₹\(amount/100).00"
    }
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func logOutButtonPressed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func customAlertBox(title : String,message : String) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "PopUpVC") as? PopUpVC{
            vc.titleToShow = title
            vc.messageToShow = message
            self.present(vc, animated: true, completion: nil)
        }
    }
    @IBAction func buyBtnPressed(_ sender: UIButton) {
        if DataBase.shared.cartData.isEmpty {
            customAlertBox(title: "Warning!", message: "Your Cart is Empty")
            return
        }
        if let address = addressTextField.text , address.isEmpty {
            customAlertBox(title: "Warning!", message: "Address field is mandatory")
            return
        }
        if let cardNumber = cardDetailTextField.text , cardNumber.isEmpty {
            customAlertBox(title: "Warning!", message: "Please provide your card number")
            return
        }
        for (index,_) in DataBase.shared.allData.enumerated() {
            DataBase.shared.allData[index].addedToCart = false
        }
        cartCollectionView.reloadData()
        billingAmountLabel.text = "Your Billing Amount : ₹00.00"
        addressTextField.text = nil
        cardDetailTextField.text = nil
        customAlertBox(title: "", message: "")
    }
}
extension CartVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let rows = DataBase.shared.cartData.isEmpty ? 1 : DataBase.shared.cartData.count
        return rows
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = cartCollectionView.dequeueReusableCell(withReuseIdentifier: "CartCollectionViewCell", for: indexPath) as? CartCollectionViewCell {
            if DataBase.shared.cartData.isEmpty {
                cell.viewWhenNoItem.isHidden = false
                return cell
            }
            let data = DataBase.shared.cartData[indexPath.row]
            if let compIcon = UIImage(named: data.companyName) {
                cell.companyIcon.image = compIcon
            }
            cell.productIndex = indexPath.row
            cell.productPrice.text = data.productPrice
            cell.companyNameLabel.text = data.productModel
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if DataBase.shared.cartData.isEmpty {
            return
        }
        let data = DataBase.shared.cartData[indexPath.row]
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "AugmentedRealityVC") as? AugmentedRealityVC {
            for (index,item) in DataBase.shared.allData.enumerated() {
                if item.uuid == data.uuid {
                    vc.productIndex = index
                }
            }
            vc.productData = data
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension CartVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 160)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension CartVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case cardDetailTextField :
            if let _ = string.rangeOfCharacter(from: NSCharacterSet.decimalDigits) {
                return true
            } else {
                return false
            }
        default:
            return true
        }
    }
}
