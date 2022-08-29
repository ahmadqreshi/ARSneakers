//
//  FavProductVC.swift
//  ARSneakers
//
//  Created by Ahmad Qureshi on 20/05/22.
//

import UIKit

class FavProductVC: UIViewController {
    
    @IBOutlet weak var favCollectionView: UICollectionView!
    @IBOutlet weak var noFavLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBarButton()
        favCollectionView.delegate = self
        favCollectionView.dataSource = self
        setUpCollectionViewCell()
    }
    override func viewWillAppear(_ animated: Bool) {
        if DataBase.shared.favData.isEmpty {
            noFavLabel.isHidden = false
        }
        favCollectionView.reloadData()
    }
    func setUpCollectionViewCell() {
        let nib = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
        self.favCollectionView.register(nib, forCellWithReuseIdentifier: "HomeCollectionViewCell")
    }
    func setUpBarButton() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Favourites"
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        let barButtonLeft = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButtonLeft
    }
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension FavProductVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataBase.shared.favData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = favCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell {
            let data = DataBase.shared.favData[indexPath.row]
            cell.companyName.text = data.productModel
            if let img = UIImage(named: data.companyName) {
                cell.companyIcon.image = img
            }
            cell.productDescription.text = data.productPrice
            if let productImg = UIImage(named: data.resourceName) {
                cell.productImage.image = productImg
            }
            cell.productIndex = indexPath.row
            if data.isFavourite {
                cell.favButton.isSelected = true
            } else {
                cell.favButton.isSelected = false
            }
            cell.favButton.isHidden = true
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = DataBase.shared.favData[indexPath.row]
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "AugmentedRealityVC") as? AugmentedRealityVC {
            for(index,item) in DataBase.shared.allData.enumerated() {
                if item.uuid == data.uuid{
                    vc.productIndex = index
                    break
                }
            }
            vc.productData = data
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension FavProductVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 250)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
