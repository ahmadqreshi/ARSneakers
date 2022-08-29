//
//  ProductDetailVC.swift
//  ARSneakers
//
//  Created by Ahmad Qureshi on 19/05/22.
//

import UIKit

var isFavClosure : (() -> Void)?
class ProductDetailVC: UIViewController {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var productModel: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var favButton: UIButton!
    var productIndex = Int()
    var productData = DataBaseModel(resourceName: "", companyName: "", productModel: "", productDescription: "", productPrice: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
    }
    override func viewWillAppear(_ animated: Bool) {
        if DataBase.shared.allData[productIndex].isFavourite {
            favButton.isSelected = true
        } else {
            favButton.isSelected = false
        }
    }
    func setUpData() {
        if let productImg = UIImage(named: productData.resourceName) {
            productImage.image = productImg
        }
        companyName.text = productData.companyName
        productModel.text = productData.productModel
        productDescription.text = productData.productDescription
        addToCartBtn.setTitle("Add To Cart (\(productData.productPrice))", for: .normal)
    }
    func customAlertBox(title : String,message : String) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "PopUpVC") as? PopUpVC{
            vc.titleToShow = title
            vc.messageToShow = message
            self.present(vc, animated: true, completion: nil)
        }
    }
    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        isFavClosure?()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func favBtnPressed(_ sender: UIButton) {
        sender.isSelected.toggle()
        DataBase.shared.allData[productIndex].isFavourite.toggle()
    }
    @IBAction func addToCartBtnPressed(_ sender: UIButton) {
        isFavClosure?()
        DataBase.shared.allData[productIndex].addedToCart = true
        customAlertBox(title: "Success", message: "Item Added to Cart Succesfully")
    }
}


