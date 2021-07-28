//
//  TGymeSettingView.swift
//  TGymTopGIrds
//
//  Created by JOJO on 2021/7/23.
//

import UIKit
import RxSwift
import MessageUI
import StoreKit
import Defaults
import NoticeObserveKit
import DeviceKit


let AppName: String = "GridChic"
let purchaseUrl = ""
let TermsofuseURLStr = "https://www.app-privacy-policy.com/live.php?token=69F7cQTWrTG1asuBAezz87HkQYiPrhh9"
let PrivacyPolicyURLStr = "https://www.app-privacy-policy.com/live.php?token=wbAroOg9uIJ0OhTOJPNRMcOlwAQZyme3"
let feedbackEmail: String = "foenr.veiurb@yandex.com"
let AppAppStoreID: String = ""



class TGymeSettingView: UIView {

    let disposeBag = DisposeBag()
//    let backBtn = UIButton(type: .custom)
    
    let userPlaceIcon = UIImageView(image: UIImage(named: "setting_name_background"))
    let userNameLabel = UILabel()
    let feedbackBtn = SettingContentBtn(frame: .zero, name: "Feedback", iconImage: UIImage(named: "feedback_ic"))
    let privacyLinkBtn = SettingContentBtn(frame: .zero, name: "Privacy Policy", iconImage: UIImage(named: "provaciy_ic"))
    let termsBtn = SettingContentBtn(frame: .zero, name: "Terms of use", iconImage: UIImage(named: "trem_of_use_ic"))
    let logoutBtn = SettingContentBtn(frame: .zero, name: "Log out", iconImage: UIImage(named: "setting_logout_background"))
//    let loginBtn = UIButton(type: .custom)
    
    let infoTitleLabel = UILabel()
    
    
    var upVC: UIViewController?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupContentView()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = UIColor.black
         
        //
        //
        userPlaceIcon.image = UIImage(named: "get_started_icon")
        addSubview(userPlaceIcon)
        userPlaceIcon.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(35)
            $0.width.height.equalTo(36)
        }
        //
        let topTitleLabel = UILabel()
            .fontName(20, "Athelas-Regular")
            .color(UIColor.white)
            .text(AppName)
        addSubview(topTitleLabel)
        topTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(userPlaceIcon.snp.bottom).offset(30)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        //
        
        
        infoTitleLabel
            .fontName(14, "Athelas-Regular")
            .color(UIColor(hexString: "#9E9E9E")!)
            .text("Current version number: V \(Bundle.main.shortVersion)")
        addSubview(infoTitleLabel)
        infoTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(topTitleLabel.snp.bottom).offset(30)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        
        
//
//        //
//        userNameLabel.font = UIFont(name: "Verdana-Bold", size: 18)
////        userNameLabel.layer.shadowColor = UIColor(hexString: "#292929")?.cgColor
////        userNameLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
////        userNameLabel.layer.shadowRadius = 3
////        userNameLabel.layer.shadowOpacity = 0.8
//        userNameLabel.textColor = UIColor(hexString: "#000000")
//        userNameLabel.textAlignment = .center
//        userNameLabel.text = "Log in"
//        view.addSubview(userNameLabel)
//        userNameLabel.adjustsFontSizeToFitWidth = true
//        userNameLabel.snp.makeConstraints {
//            $0.center.equalTo(userPlaceIcon)
//            $0.left.equalTo(30)
//            $0.height.greaterThanOrEqualTo(1)
//        }
//        //
        
    }
    
    func setupContentView() {
 
        let btnwidth: CGFloat = UIScreen.width - 60
        let btnheight: CGFloat = 46
        
        // feedback
        addSubview(feedbackBtn)
        feedbackBtn.clickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            self.feedback()
        }
        feedbackBtn.snp.makeConstraints {
            $0.left.equalTo(30)
            $0.height.equalTo(btnheight)
            $0.width.equalTo(btnwidth)
            $0.top.equalTo(infoTitleLabel.snp.bottom).offset(40)
            
        }
        
//        if Device.current.diagonal == 4.7 || Device.current.diagonal > 7 {
//            feedbackBtn.snp.makeConstraints {
//                $0.width.equalTo(357)
//                $0.height.equalTo(64)
//                $0.top.equalTo(userNameLabel.snp.bottom).offset(27)
//                $0.centerX.equalToSuperview()
//            }
//        } else {
//            feedbackBtn.snp.makeConstraints {
//                $0.width.equalTo(357)
//                $0.height.equalTo(64)
//                $0.top.equalTo(userNameLabel.snp.bottom).offset(37)
//                $0.centerX.equalToSuperview()
//            }
//        }
        
        // privacy link
        addSubview(privacyLinkBtn)
        privacyLinkBtn.clickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIApplication.shared.openURL(url: PrivacyPolicyURLStr)
        }
        privacyLinkBtn.snp.makeConstraints {
            $0.left.equalTo(30)
            $0.height.equalTo(btnheight)
            $0.width.equalTo(btnwidth)
            $0.top.equalTo(feedbackBtn.snp.bottom).offset(10)
            
        }
        // terms
        
        addSubview(termsBtn)
        termsBtn.clickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIApplication.shared.openURL(url: TermsofuseURLStr)
        }
        termsBtn.snp.makeConstraints {
            $0.left.equalTo(30)
            $0.height.equalTo(btnheight)
            $0.width.equalTo(btnwidth)
            $0.top.equalTo(privacyLinkBtn.snp.bottom).offset(10)
            
        }
        
         
        
    }
    
}


extension TGymeSettingView: MFMailComposeViewControllerDelegate {
    func feedback() {
        //首先要判断设备具不具备发送邮件功能
        if MFMailComposeViewController.canSendMail(){
            //获取系统版本号
            let systemVersion = UIDevice.current.systemVersion
            let modelName = UIDevice.current.modelName
            
            let infoDic = Bundle.main.infoDictionary
            // 获取App的版本号
            let appVersion = infoDic?["CFBundleShortVersionString"] ?? "8.8.8"
            // 获取App的名称
            let appName = "\(AppName)"

            
            let controller = MFMailComposeViewController()
            //设置代理
            controller.mailComposeDelegate = self
            //设置主题
            controller.setSubject("\(appName) Feedback")
            //设置收件人
            // FIXME: feed back email
            controller.setToRecipients([feedbackEmail])
            //设置邮件正文内容（支持html）
         controller.setMessageBody("\n\n\nSystem Version：\(systemVersion)\n Device Name：\(modelName)\n App Name：\(appName)\n App Version：\(appVersion )", isHTML: false)
            
            //打开界面
            self.upVC?.present(controller, animated: true, completion: nil)
        }else{
            HUD.error("The device doesn't support email")
        }
    }
    
    //发送邮件代理方法
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
    }
 }



class SettingContentBtn: UIButton {
    var clickBlock: (()->Void)?
    var nameTitle: String
    var iconImage: UIImage?
    
    
    
    init(frame: CGRect, name: String, iconImage: UIImage?) {
        self.nameTitle = name
        self.iconImage = iconImage
        super.init(frame: frame)
        setupView()
        addTarget(self, action: #selector(clickAction(sender:)), for: .touchUpInside)
    }
    
    @objc func clickAction(sender: UIButton) {
        clickBlock?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = .clear
 
        //
        let iconImgV = UIImageView(image: iconImage)
        iconImgV.contentMode = .scaleAspectFit
        addSubview(iconImgV)
        iconImgV.snp.makeConstraints {
            $0.left.equalTo(40)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        //
        let nameLabel = UILabel()
        addSubview(nameLabel)
        nameLabel.text = nameTitle
        nameLabel.textColor = UIColor(hexString: "#FFFFFF")
        nameLabel.font = UIFont(name: "Athelas-Regular", size: 16)
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines(1)
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.greaterThanOrEqualTo(1)
            $0.left.equalTo(iconImgV.snp.right).offset(20)
            $0.width.greaterThanOrEqualTo(1)
            
        }
        
        //
        var lineV = UIView()
        lineV
            .backgroundColor(UIColor(hexString: "#979797")!.withAlphaComponent(0.35))
        addSubview(lineV)
        lineV.snp.makeConstraints {
            $0.left.equalTo(iconImgV.snp.left)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        //
        var arrowImgV = UIImageView()
        arrowImgV
            .image("next_ic")
            .adhere(toSuperview: self)
        arrowImgV.snp.makeConstraints {
            $0.right.equalTo(-40)
            $0.centerY.equalTo(iconImgV)
            $0.width.equalTo(10)
            $0.height.equalTo(23)
        }
    }
    
}
