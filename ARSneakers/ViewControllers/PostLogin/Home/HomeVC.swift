//
//  ViewController.swift
//  ARSneakers
//
//  Created by Ahmad Qureshi on 18/05/22.
//

import UIKit

protocol UpdateFav : AnyObject {
    func updateFav(isFav: Bool)
}

class HomeVC: UIViewController {

    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var bgImageHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        setUpCollectionViewCell()
        setUpOpacity()
        setUpBarButton()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        backgroundImage.roundCorners(radius: 20)
    }
    override func viewWillAppear(_ animated: Bool) {
        homeCollectionView.reloadData()
        self.navigationController?.navigationBar.isHidden = false
    }
    func setUpBarButton() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        let button1 = UIButton(type: UIButton.ButtonType.custom)
        button1.setImage(UIImage(systemName: "cart.fill")!, for: .normal)
        button1.tintColor = .white
        button1.addTarget(self, action: #selector(cartBtnPressed), for: .touchUpInside)
        let barButtonLeft = UIBarButtonItem(customView: button1)
        
        let button2 = UIButton(type: UIButton.ButtonType.custom)
        button2.setImage(UIImage(systemName: "heart.fill")!, for: .normal)
        button2.tintColor = .white
        button2.addTarget(self, action: #selector(favouriteBtnPressed), for: .touchUpInside)
        let barButtonRight = UIBarButtonItem(customView: button2)
        
        self.navigationItem.leftBarButtonItem = barButtonLeft
        self.navigationItem.rightBarButtonItem = barButtonRight
    }
    @objc func cartBtnPressed() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "CartVC") as? CartVC {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @objc func favouriteBtnPressed() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "FavProductVC") as? FavProductVC {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func setUpOpacity() {
        let tintView = UIView()
        tintView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        tintView.frame = CGRect(x: 0, y: 0, width: backgroundImage.frame.width, height: backgroundImage.frame.height)
        backgroundImage.addSubview(tintView)
    }
    func setUpCollectionViewCell() {
        let nib = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
        self.homeCollectionView.register(nib, forCellWithReuseIdentifier: "HomeCollectionViewCell")
    }
}

extension HomeVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataBase.shared.allData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell {
            let data = DataBase.shared.allData[indexPath.row]
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
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = DataBase.shared.allData[indexPath.row]
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "AugmentedRealityVC") as? AugmentedRealityVC {
            vc.productIndex = indexPath.row
            vc.productData = data
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if homeCollectionView.contentOffset.y > 0 {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.2) {
                self.bgImageHeight.constant = 0
                self.view.layoutIfNeeded()
            }
            self.navigationController?.navigationBar.isHidden = true
        } else  {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3) {
                self.bgImageHeight.constant = 200
                self.view.layoutIfNeeded()
            }
            self.navigationController?.navigationBar.isHidden = false
        }
    }
}
extension HomeVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 250)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

