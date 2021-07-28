//
//  TGymeStoreVC.swift
//  TGymTopGIrds
//
//  Created by JOJO on 2021/7/23.
//

import UIKit
import RxSwift
import Adjust
import SwiftyStoreKit
import NoticeObserveKit
import StoreKit

class TGymeStoreVC: UIViewController {
    let disposeBag = DisposeBag()
    private var pool = Notice.ObserverPool()
    let topBannerView = UIView()
    
    let backBtn = UIButton(type: .custom)
    let topCoinLabel = UILabel()
    var collection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollection()
        addNotificationObserver()
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func addNotificationObserver() {
        
        NotificationCenter.default.nok.observe(name: .pi_noti_coinChange) {[weak self] _ in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.topCoinLabel.text = "\(LMymBCartCoinManager.default.coinCount)"
            }
        }
        .invalidated(by: pool)
        
        NotificationCenter.default.nok.observe(name: .pi_noti_priseFetch) { [weak self] _ in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.collection.reloadData()
            }
        }
        .invalidated(by: pool)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.topCoinLabel.text = "\(LMymBCartCoinManager.default.coinCount)"
    }
    
}

extension TGymeStoreVC {
    func setupView() {
        view.backgroundColor = UIColor.black
        backBtn
            .image(UIImage(named: "back_home_ic"))
            .rx.tap
            .subscribe(onNext:  {
                [weak self] in
                guard let `self` = self else {return}
                if self.navigationController != nil {
                    self.navigationController?.popViewController()
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
        
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalTo(10)
            $0.width.height.equalTo(44)
        }
        
//        let topTitleLabel = UILabel()
//            .fontName(18, "Verdana-Bold")
//            .color(UIColor.white)
//            .text("Setting")
//        view.addSubview(topTitleLabel)
//        topTitleLabel.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.centerY.equalTo(backBtn)
//            $0.width.height.greaterThanOrEqualTo(1)
//        }
        
        topBannerView
            .backgroundColor(.clear)
        topBannerView.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: 130)
        
        //
        let topCoinImgV = UIImageView(image: UIImage(named: "store_coins_ic"))
        topBannerView.addSubview(topCoinImgV)
        topCoinImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(5)
            $0.width.height.equalTo(80)
        }
        
        //
        topCoinLabel.textAlignment = .right
        topCoinLabel.text = "\(LMymBCartCoinManager.default.coinCount)"
        topCoinLabel.textColor = UIColor(hexString: "#FFFFFF")
        topCoinLabel.font = UIFont(name: "Athelas-Regular", size: 40)
        topBannerView.addSubview(topCoinLabel)
        topCoinLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(topCoinImgV.snp.bottom)
            $0.height.greaterThanOrEqualTo(35)
            $0.width.greaterThanOrEqualTo(25)
        }
        
        
        
    }
    
    func setupCollection() {
        
        // collection
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .clear
//        collection.layer.cornerRadius = 35
        collection.layer.masksToBounds = true
        collection.delegate = self
        collection.dataSource = self
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalTo(backBtn.snp.bottom).offset(10)
            $0.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        collection.register(cellWithClass: LMymStoreCell.self)
        collection.register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: UICollectionReusableView.self)
    }
    
    func selectCoinItem(item: StoreItem) {
        LMymBCartCoinManager.default.purchaseIapId(item: item) { (success, errorString) in
            
            if success {
                self.showAlert(title: "Purchase successful.", message: "")
            } else {
                self.showAlert(title: "Purchase failed.", message: errorString)
            }
        }
    }
    
    
}

extension TGymeStoreVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: LMymStoreCell.self, for: indexPath)
        let item = LMymBCartCoinManager.default.coinIpaItemList[indexPath.item]
        cell.coinCountLabel.text = "+\(item.coin)"
        cell.priceLabel.text = item.price
        
         
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LMymBCartCoinManager.default.coinIpaItemList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind ==         UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withClass: UICollectionReusableView.self, for: indexPath)
            
            header.addSubview(topBannerView)
            return header
        } else {
            return UICollectionReusableView()
        }
    }
    
}

extension TGymeStoreVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellwidth: CGFloat = 134
        let cellHeight: CGFloat = (160 / 134) * cellwidth
        
        
        return CGSize(width: cellwidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let left: CGFloat = ((UIScreen.main.bounds.width - (134 * 2 + 25) - 1) / 2)
        return UIEdgeInsets(top: 20, left: left, bottom: 0, right: left)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 22
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 22
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.width, height: 150)
    }
    
}

extension TGymeStoreVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = LMymBCartCoinManager.default.coinIpaItemList[safe: indexPath.item] {
            selectCoinItem(item: item)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}





class LMymStoreCell: UICollectionViewCell {
    
    var bgView: UIView = UIView()
    
    var bgImageV: UIImageView = UIImageView()
    var coverImageV: UIImageView = UIImageView()
    var coinCountLabel: UILabel = UILabel()
    var priceLabel: UILabel = UILabel()
    var priceBgImgV: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        backgroundColor = UIColor.clear
        bgView.backgroundColor = .clear
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        //
        bgImageV.backgroundColor = .clear
        bgImageV.contentMode = .scaleAspectFit
        bgImageV.image = UIImage(named: "")
        bgImageV.layer.masksToBounds = true
        bgImageV.layer.cornerRadius = 12
        bgImageV.layer.borderColor = UIColor.white.cgColor
        bgImageV.layer.borderWidth = 1
        bgView.addSubview(bgImageV)
        bgImageV.snp.makeConstraints {
            $0.bottom.left.right.top.equalToSuperview()
            
        }
        
        //
        let iconImgV = UIImageView(image: UIImage(named: "store_coins_ic"))
        iconImgV.contentMode = .scaleAspectFit
        bgView.addSubview(iconImgV)
        iconImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(24)
            $0.width.height.equalTo(32)
        }
        
        //
        coinCountLabel.adjustsFontSizeToFitWidth = true
        coinCountLabel.textColor = UIColor(hexString: "#FFFFFF")
//        coinCountLabel.layer.shadowColor = UIColor(hexString: "#FFE7A8")?.cgColor
//        coinCountLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
//        coinCountLabel.layer.shadowRadius = 3
//        coinCountLabel.layer.shadowOpacity = 0.8
        
        coinCountLabel.numberOfLines = 1
        coinCountLabel.textAlignment = .center
        coinCountLabel.font = UIFont(name: "Athelas-Regular", size: 32)
        coinCountLabel.adjustsFontSizeToFitWidth = true
        bgView.addSubview(coinCountLabel)
        coinCountLabel.snp.makeConstraints {
            $0.top.equalTo(iconImgV.snp.bottom).offset(2)
            $0.centerX.equalToSuperview()
            $0.left.equalTo(5)
            $0.height.greaterThanOrEqualTo(1)
        }
        
        //
//        coverImageV.image = UIImage(named: "home_button")
//        coverImageV.contentMode = .center
//        bgView.addSubview(coverImageV)
//
        
        //
        bgView.addSubview(priceBgImgV)
        priceBgImgV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(40)
        }
        priceBgImgV.contentMode = .scaleAspectFill
        //
        priceLabel.textColor = UIColor(hexString: "#161616")
        priceLabel.font = UIFont(name: "Athelas-Regular", size: 20)
        priceLabel.textAlignment = .center
        bgView.addSubview(priceLabel)
//        priceLabel.layer.shadowColor = UIColor(hexString: "#FF12D2")?.cgColor
//        priceLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
//        priceLabel.layer.shadowRadius = 3
//        priceLabel.layer.shadowOpacity = 0.8
        
        
        priceLabel.backgroundColor = UIColor(hexString: "#ACFF34")
        priceLabel.cornerRadius = 12
        priceLabel.adjustsFontSizeToFitWidth = true
//        priceLabel.layer.borderWidth = 2
//        priceLabel.layer.borderColor = UIColor.white.cgColor
        priceLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(118)
            $0.height.greaterThanOrEqualTo(49)
            $0.bottom.equalToSuperview().offset(-8)
        }
        
        
        
//        coverImageV.snp.makeConstraints {
//            $0.center.equalTo(priceLabel.snp.center)
//            $0.width.equalTo(135)
//            $0.height.equalTo(54)
//        }
    }
     
}




