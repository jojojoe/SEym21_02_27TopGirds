//
//  TGymProAlertView.swift
//  TGymTopGIrds
//
//  Created by JOJO on 2021/7/26.
//

import UIKit
 

class TGymProAlertView: UIView {
    var okBtnclickBlock: (()->Void)?
    var cancelBtnclickBlock: (()->Void)?
    var selectColorItemBlock: ((UIColor)->Void)?
    let infoLabel = UILabel()
    let cancelBtn = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        showCancelBtnStatus(isShow: false)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TGymProAlertView {
    @objc func bgViewBtnClick(sender: UIButton) {
        cancelBtnclickBlock?()
    }
    @objc func okBtnclick(sender: UIButton) {
        okBtnclickBlock?()
    }
    
    func showCancelBtnStatus(isShow: Bool) {
        cancelBtn.isHidden = !isShow
        if isShow {
            // save page
            infoLabel.text = "Paid items will be deducted \(LMymBCartCoinManager.default.coinCostCount) coins."
        } else {
            // edit alert page
            infoLabel.text = "Use paid items, coins will be deducted when saving !"
            
        }
    }
}

extension TGymProAlertView {
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
        let topIconImgV = UIImageView(image: UIImage(named: "popup_emoji_ic"))
        bottomBgView.addSubview(topIconImgV)
        topIconImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(45)
            $0.width.height.equalTo(100)
        }
        //
        
        infoLabel
            .fontName(20, "Athelas-Regular")
            .color(UIColor.white)
            .textAlignment(.center)
            .numberOfLines(2)
            .text("Paid items will be deducted \(LMymBCartCoinManager.default.coinCostCount) coins.")
            .adhere(toSuperview: bottomBgView)
        infoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(topIconImgV.snp.bottom).offset(8)
            $0.left.equalTo(44)
            $0.height.greaterThanOrEqualTo(1)
        }
        //
        
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
            $0.top.equalTo(infoLabel.snp.bottom).offset(40)
            $0.width.equalTo(225)
            $0.height.equalTo(44)
        }
        okBtn.addTarget(self, action: #selector(okBtnclick(sender:)), for: .touchUpInside)
        
        //
        
        cancelBtn
            .backgroundColor(UIColor.black)
            .title("Cancel")
            .titleColor(UIColor(hexString: "#FFFFFF")!.withAlphaComponent(0.5))
            .font(18, "Athelas-Regular")
            .adhere(toSuperview: bottomBgView)
//        cancelBtn.layer.cornerRadius = 6
        cancelBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(okBtn.snp.bottom).offset(5)
            $0.width.equalTo(225)
            $0.height.equalTo(44)
        }
        cancelBtn.addTarget(self, action: #selector(bgViewBtnClick(sender:)), for: .touchUpInside)
    }
    
    
}

