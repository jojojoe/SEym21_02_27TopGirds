//
//  TGymeEditToolMaskBar.swift
//  TGymTopGIrds
//
//  Created by JOJO on 2021/7/23.
//

import UIKit

class TGymeEditToolMaskBar: UIView {
    var collection_m: UICollectionView!
    let layout_m = UICollectionViewFlowLayout()
    
    
    var collection_c: UICollectionView!
    let layout_c = UICollectionViewFlowLayout()
    let alphaSlider = UISlider()
    
    var gridSelectBlock: ((GridItem)->Void)?
    var bgColorSelectBlock: ((String)->Void)?
    var alphaSliderValueChangeBlock: ((Float)->Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension TGymeEditToolMaskBar {
    func setupView() {
        
        layout_m.scrollDirection = .horizontal
        collection_m = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout_m)
        collection_m.showsVerticalScrollIndicator = false
        collection_m.showsHorizontalScrollIndicator = false
        collection_m.backgroundColor = .clear
        collection_m.delegate = self
        collection_m.dataSource = self
        addSubview(collection_m)
        collection_m.snp.makeConstraints {
            $0.bottom.right.left.equalToSuperview()
            $0.height.equalTo(50)
        }
        collection_m.register(cellWithClass: TGymeToolMaskCell.self)
        
        //
        layout_c.scrollDirection = .horizontal
        collection_c = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout_c)
        collection_c.showsVerticalScrollIndicator = false
        collection_c.showsHorizontalScrollIndicator = false
        collection_c.backgroundColor = .clear
        collection_c.delegate = self
        collection_c.dataSource = self
        addSubview(collection_c)
        collection_c.snp.makeConstraints {
            $0.right.left.equalToSuperview()
            $0.bottom.equalTo(collection_m.snp.top).offset(-15)
            $0.height.equalTo(40)
        }
        collection_c.register(cellWithClass: TGymeToolColorCell.self)
        
        //
        alphaSlider.minimumValue = 0
        alphaSlider.maximumValue = 1
        alphaSlider.minimumTrackTintColor = UIColor(hexString: "#ACFF34")
        alphaSlider.maximumTrackTintColor = UIColor(hexString: "#242424")
        alphaSlider.setThumbImage(UIImage(named: "slide_ic"), for: .normal)
        self.addSubview(alphaSlider)
        alphaSlider.snp.makeConstraints {
            $0.left.equalTo(30)
            $0.right.equalTo(-30)
            $0.bottom.equalTo(collection_c.snp.top).offset(-15)
            $0.height.equalTo(30)
        }
        alphaSlider.addTarget(self, action: #selector(alphaSliderChange(sender:)), for: .valueChanged)
        
    }
    
}

extension TGymeEditToolMaskBar {
    @objc func alphaSliderChange(sender: UISlider) {
        alphaSliderValueChangeBlock?(sender.value)
    }
}

extension TGymeEditToolMaskBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collection_m {
            let cell = collectionView.dequeueReusableCell(withClass: TGymeToolMaskCell.self, for: indexPath)
            let item = LMynARTDataManager.default.maskList[indexPath.item]
            cell.contentImgV.image = UIImage(named: item.thumb ?? "")
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withClass: TGymeToolColorCell.self, for: indexPath)
            
            if indexPath.item == 0 {
                cell.contentImgV.image = UIImage(named: "color_set_ic")
                cell.contentImgV.backgroundColor = .clear
                cell.layer.borderWidth = 0
                cell.layer.cornerRadius = 0
                cell.selectView.layer.cornerRadius = cell.bounds.width / 2
            } else {
                let item = LMynARTDataManager.default.bgColors[indexPath.item - 1]
                cell.contentImgV.image = nil
                cell.contentImgV.backgroundColor = UIColor(hexString: item)
                cell.layer.cornerRadius = cell.bounds.width / 2
                cell.selectView.layer.cornerRadius = cell.bounds.width / 2
                
                cell.layer.masksToBounds = true
                if item.contains("000000") {
                    cell.layer.borderWidth = 1
                    cell.layer.borderColor = UIColor.lightGray.cgColor
                } else {
                    cell.layer.borderWidth = 0
                    
                }
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collection_m {
            return LMynARTDataManager.default.maskList.count
        }
        return LMynARTDataManager.default.bgColors.count + 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension TGymeEditToolMaskBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collection_m {
            return CGSize(width: 48, height: 48)
        }
        return CGSize(width: 36, height: 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 17
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension TGymeEditToolMaskBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collection_m {
            let item = LMynARTDataManager.default.maskList[indexPath.item]
            gridSelectBlock?(item)
        } else {
            if indexPath.item == 0 {
                bgColorSelectBlock?("color")
            } else {
                let color = LMynARTDataManager.default.bgColors[indexPath.item - 1]
                bgColorSelectBlock?(color)
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}




class TGymeToolMaskCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentImgV.contentMode = .scaleAspectFit
        contentImgV.clipsToBounds = true
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        
        
    }
}


class TGymeToolColorCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    let selectView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentImgV.contentMode = .scaleAspectFill
        contentImgV.clipsToBounds = true
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        //
        selectView.contentMode = .scaleAspectFill
        selectView.clipsToBounds = true
        contentView.addSubview(selectView)
        selectView.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        selectView.isHidden = true
        selectView.layer.borderWidth = 1.5
        selectView.layer.borderColor = UIColor(hexString: "#ACFF34")?.cgColor
        
    }
    
    override var isSelected: Bool {
        didSet {
            selectView.isHidden = !isSelected
        }
    }
}

