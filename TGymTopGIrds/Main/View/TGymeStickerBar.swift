//
//  TGymeStickerBar.swift
//  TGymTopGIrds
//
//  Created by JOJO on 2021/7/23.
//

import UIKit

class GCStickerView: UIView {
    
    var collection: UICollectionView!
    var didSelectStickerItemBlock: ((_ stickerItem: GCStickerItem) -> Void)?
    var currentSelectIndexPath : IndexPath?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        loadData()
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        
    }

}

extension GCStickerView {
    func refreshContentCollection() {
        collection.reloadData()
    }
}


extension GCStickerView {
    func loadData() {
        
    }
    
    func setupView() {
        // collection
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(110)
        }
        collection.register(cellWithClass: GCStickerCell.self)
    }
    
}

extension GCStickerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = LMynARTDataManager.default.stickerList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withClass: GCStickerCell.self, for: indexPath)
        
        cell.contentImageView.image = UIImage(named: item.thumbnail)
        
        if currentSelectIndexPath?.item == indexPath.item {
            cell.selectView.isHidden = false
        } else {
            cell.selectView.isHidden = true
        }
        
        if item.isPro == false {
            cell.proImageV.isHidden = true
        } else {
            cell.proImageV.isHidden = false
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LMynARTDataManager.default.stickerList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension GCStickerView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 108, height: 108)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}

extension GCStickerView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = LMynARTDataManager.default.stickerList[indexPath.item]
        didSelectStickerItemBlock?(item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}




class GCStickerCell: UICollectionViewCell {
    var contentImageView: UIImageView = UIImageView()
    let selectView: UIView = UIView()
    let proImageV: UIImageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        //
        let bgOverV = UIView()
        bgOverV
            .backgroundColor(UIColor(hexString: "#242424")!)
        bgOverV.layer.cornerRadius = 8
        contentView.addSubview(bgOverV)
        bgOverV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        //
        contentImageView.contentMode = .scaleAspectFit
        contentView.addSubview(contentImageView)
        contentImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.top.left.equalToSuperview().offset(4)
        }
        
//        selectView.contentMode = .scaleAspectFit
//        selectView.isHidden = true
//        selectView.backgroundColor = .clear
//        selectView.layer.borderWidth = 1
//        selectView.layer.borderColor = UIColor(hexString: "#FF4766")?.cgColor
//        contentView.addSubview(selectView)
//        selectView.snp.makeConstraints {
//            $0.top.equalTo(contentImageView).offset(-2)
//            $0.bottom.equalTo(contentImageView).offset(2)
//            $0.left.equalTo(contentImageView).offset(-2)
//            $0.right.equalTo(contentImageView).offset(2)
//        }
        
        
        proImageV.image = UIImage(named: "pro_ic")
        proImageV.isHidden = true
        addSubview(proImageV)
        proImageV.snp.makeConstraints {
            $0.top.equalTo(5)
            $0.right.equalTo(-6)
            $0.width.equalTo(29)
            $0.height.equalTo(16)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                selectView.isHidden = false
            } else {
                selectView.isHidden = true
            }
        }
    }
}











