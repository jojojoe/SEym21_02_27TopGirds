//
//  TGymColorPanView.swift
//  TGymTopGIrds
//
//  Created by JOJO on 2021/7/26.
//

import UIKit
import GDColorSlider

class TGymColorPanView: UIView {
    var okBtnclickBlock: (()->Void)?
    var selectColorItemBlock: ((UIColor)->Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TGymColorPanView {
    @objc func bgViewBtnClick(sender: UIButton) {
        okBtnclickBlock?()
    }
    
    @objc func colorValueChange(colorSlider: GDColorSlider) {
        selectColorItemBlock?(colorSlider.selectedColor)
    }
}

extension TGymColorPanView {
    func setupView() {
        let bgViewBtn = UIButton(type: .custom)
        bgViewBtn
            .backgroundColor(.clear)
            .adhere(toSuperview: self)
        bgViewBtn.addTarget(self, action: #selector(bgViewBtnClick(sender:)), for: .touchUpInside)
        bgViewBtn.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        //
        let bottomBgView = UIView()
        bottomBgView
            .backgroundColor(.black)
            .adhere(toSuperview: self)
//        bottomBgView.roundCorners([.topLeft, .topRight], radius: 36)
        bottomBgView.layer.cornerRadius = 36
        bottomBgView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(380)
        }
        let bottommakstView = UIView()
        bottommakstView
            .backgroundColor(.black)
            .adhere(toSuperview: self)
        bottommakstView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(37)
        }
        
        
        
        //
        let colorPan = GDColorSlider(frame: CGRect(x: (UIScreen.width - 224)/2, y: 40, width: 224, height: 224))
        bottomBgView.addSubview(colorPan)
        colorPan.addTarget(self, action: #selector(colorValueChange(colorSlider:)), for: .valueChanged)
        colorPan.layer.cornerRadius = 224/2
        colorPan.clipsToBounds = true
        colorPan.colorImageName = "pancolor"
        colorPan.isShowBottomIndicate = false
        colorPan.isShowRightIndicate = false
        colorPan.isShowContentIndicate = true
        
        let okBtn = UIButton(type: .custom)
        
        okBtn
            .backgroundColor(UIColor(hexString: "#ACFF34")!)
            .title("OK")
            .titleColor(UIColor.black)
            .font(20, "Athelas-Regular")
            .adhere(toSuperview: bottomBgView)
        okBtn.layer.cornerRadius = 6
        okBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(colorPan.snp.bottom).offset(30)
            $0.width.equalTo(225)
            $0.height.equalTo(44)
        }
        okBtn.addTarget(self, action: #selector(bgViewBtnClick(sender:)), for: .touchUpInside)
    }
    
    
}

