//
//  TGymeFilterBar.swift
//  TGymTopGIrds
//
//  Created by JOJO on 2021/7/23.
//

import UIKit


class TGymeFilterEffecBar: UIView {
    
    var collection: UICollectionView!
    var didSelectStickerItemBlock: ((_ stickerItem: GCStickerItem) -> Void)?
    var currentSelectIndexPath : IndexPath?
    var userImg: UIImage
    
    init(frame: CGRect, userImg: UIImage) {
        self.userImg = userImg
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

extension TGymeFilterEffecBar {
    func refreshContentCollection() {
        collection.reloadData()
    }
}


extension TGymeFilterEffecBar {
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
            $0.top.equalToSuperview()
        }
        collection.register(cellWithClass: TGymeFilterEffecCell.self)
    }
    
}

extension TGymeFilterEffecBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = LMynARTDataManager.default.overlayerImgList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withClass: TGymeFilterEffecCell.self, for: indexPath)
        cell.bgImgV.image = userImg
        cell.contentImgV.image = UIImage(named: item.thumbnail)
        
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
        return LMynARTDataManager.default.overlayerImgList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension TGymeFilterEffecBar: UICollectionViewDelegateFlowLayout {
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

extension TGymeFilterEffecBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentSelectIndexPath = indexPath
        let item = LMynARTDataManager.default.overlayerImgList[indexPath.item]
        didSelectStickerItemBlock?(item)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


class TGymeFilterEffecCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    let bgImgV = UIImageView()
    let selectView = UIImageView()
    let proImageV = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        
        bgImgV.contentMode = .scaleAspectFill
        bgImgV.clipsToBounds = true
        contentView.addSubview(bgImgV)
        bgImgV.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        bgImgV.layer.cornerRadius = 8
        //
        contentImgV.contentMode = .scaleAspectFill
        contentImgV.clipsToBounds = true
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        contentImgV.layer.cornerRadius = 8
        //
        selectView.contentMode = .scaleAspectFill
        selectView.clipsToBounds = true
        contentView.addSubview(selectView)
        selectView.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        selectView.layer.cornerRadius = 8
        selectView.layer.borderWidth = 1.5
        selectView.layer.borderColor = UIColor(hexString: "#ACFF34")?.cgColor
        //
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
}

