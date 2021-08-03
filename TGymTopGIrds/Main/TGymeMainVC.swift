//
//  TGymeMainVC.swift
//  TGymTopGIrds
//
//  Created by JOJO on 2021/7/23.
//

import UIKit
import RxSwift
import Photos
import YPImagePicker

var previewWidth: CGFloat = 330

class TGymeMainVC: UIViewController, UINavigationControllerDelegate {
    let disposeBag = DisposeBag()
    
    let storeBtn = UIButton(type: .custom)
    let startedBtn = UIButton(type: .custom)
    let settingV = TGymeSettingView()
    let apnameLabel = UILabel()
    let homeBgView = UIView()
    let bottomBannerBgView = UIView()
    let homeBtn = UIButton(type: .custom)
    let settBtn = UIButton(type: .custom)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        showHomeView()
        homeBtn.isSelected = true
        settBtn.isSelected = false
        
        AFlyerLibManage.event_LaunchApp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeBgView.clipsToBounds = true
        settingV.clipsToBounds = true
        homeBgView.layer.cornerRadius = 60
        settingV.layer.cornerRadius = 60
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        homeBgView.roundCorners([.bottomLeft, .bottomRight], radius: 60)
//        settingV.roundCorners([.bottomLeft, .bottomRight], radius: 60)
    }
}

extension TGymeMainVC {
    func setupView() {
        view.backgroundColor = UIColor.black
        //
        bottomBannerBgView
            .backgroundColor(UIColor(hexString: "#FFFFFF")!)
            .adhere(toSuperview: self.view)
        bottomBannerBgView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(190)
        }
        //
        storeBtn
            .image(UIImage(named: "store_center_ic"))
            .rx.tap
            .subscribe(onNext:  {
                [weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    self.storeBtnAction()
                }
            })
            .disposed(by: disposeBag)
        
        view.addSubview(storeBtn)
        storeBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.right.equalTo(-10)
            $0.width.height.equalTo(44)
        }
        //
        
        apnameLabel
            .fontName(20, "Athelas-Regular")
            .color(.white)
            .text(AppName)
            .adhere(toSuperview: self.view)
        apnameLabel.snp.makeConstraints {
            $0.left.equalTo(28)
            $0.centerY.equalTo(storeBtn)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        
        homeBgView
            .backgroundColor(.black)
            .adhere(toSuperview: self.view)
        homeBgView.snp.makeConstraints {
            $0.top.equalTo(storeBtn.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(bottomBannerBgView.snp.top).offset(60)
        }
        
        //
        let iconImgV = UIImageView()
        iconImgV
            .image("get_started_icon")
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: homeBgView)
        iconImgV.snp.makeConstraints {
            $0.bottom.equalTo(homeBgView.snp.centerY).offset(-50)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(48)
        }
        //
        let homeInfo1 = UILabel()
        homeInfo1
            .fontName(20, "Athelas-Regular")
            .color(UIColor(hexString: "#9E9E9E")!)
            .text("Create Grid Pic for Your Posts")
            .adhere(toSuperview: homeBgView)
        homeInfo1.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(iconImgV.snp.bottom).offset(26)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
//        let homeInfo2 = UILabel()
//        homeInfo2
//            .fontName(14, "Athelas-Regular")
//            .color(UIColor(hexString: "#4B4B4B")!)
//            .textAlignment(.center)
//            .numberOfLines(2)
//            .text("Let's Design Now!")
//            .adhere(toSuperview: homeBgView)
//        homeInfo2.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.top.equalTo(homeInfo1.snp.bottom).offset(12)
//            $0.width.equalTo(250)
//            $0.height.greaterThanOrEqualTo(30)
//        }
        //

        startedBtn
            .title("Let's Design Now!")
            .backgroundColor(UIColor(hexString: "#ACFF34")!)
            .titleColor(UIColor(hexString: "#161616")!)
            .font(20, "Athelas-Regular")
            .rx.tap
            .subscribe(onNext:  {
                [weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    self.starBtnAction()
                }
            })
            .disposed(by: disposeBag)
        startedBtn.layer.cornerRadius = 12
        homeBgView.addSubview(startedBtn)
        startedBtn.snp.makeConstraints {
            $0.top.equalTo(homeInfo1.snp.bottom).offset(55)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(225)
            $0.height.equalTo(49)
        }
        
        //
        self.view.addSubview(settingV)
        settingV.upVC = self
        settingV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(storeBtn.snp.bottom)
            $0.bottom.equalTo(bottomBannerBgView.snp.top).offset(60)
        }
        
        //
        homeBtn
            .image(UIImage(named: "home_tab_ic_n"), .normal)
            .image(UIImage(named: "home_tab_ic_s"), .selected)
            .adhere(toSuperview: bottomBannerBgView)
            .rx.tap
            .subscribe(onNext:  {
                [weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    self.showHomeView()
                }
            })
            .disposed(by: disposeBag)

        homeBtn.snp.makeConstraints {
            $0.bottom.equalTo(-40)
            $0.left.equalTo(70)
            $0.width.height.equalTo(67)
        }
        
        homeBtn.adjustsImageWhenHighlighted = false
        //
        settBtn.adjustsImageWhenHighlighted = false
        settBtn
            .image(UIImage(named: "set_tab_ic_n"), .normal)
            .image(UIImage(named: "set_tab_ic_s"), .selected)
            .adhere(toSuperview: bottomBannerBgView)
            .rx.tap
            .subscribe(onNext:  {
                [weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    self.showSettingView()
                }
            })
            .disposed(by: disposeBag)
        settBtn.snp.makeConstraints {
            $0.bottom.equalTo(-40)
            $0.right.equalTo(-70)
            $0.width.height.equalTo(67)
        }
        
        
    }
    
    func showHomeView() {
        homeBtn.isSelected = true
        settBtn.isSelected = false
        homeBgView.isHidden = false
        settingV.isHidden = true
    }
    
    func showSettingView() {
        homeBtn.isSelected = false
        settBtn.isSelected = true
        homeBgView.isHidden = true
        settingV.isHidden = false
    }
    
    
}

extension TGymeMainVC {
    func starBtnAction() {
        checkAlbumAuthorization()
    }
    func storeBtnAction() {
        self.navigationController?.pushViewController(TGymeStoreVC())
    }
        
}

extension TGymeMainVC: UIImagePickerControllerDelegate {
    
    func checkAlbumAuthorization() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                switch status {
                case .authorized:
                    DispatchQueue.main.async {
                        self.presentPhotoPickerController()
                    }
                case .limited:
                    DispatchQueue.main.async {
                        self.presentLimitedPhotoPickerController()
                    }
                case .notDetermined:
                    if status == PHAuthorizationStatus.authorized {
                        DispatchQueue.main.async {
                            self.presentPhotoPickerController()
                        }
                    } else if status == PHAuthorizationStatus.limited {
                        DispatchQueue.main.async {
                            self.presentLimitedPhotoPickerController()
                        }
                    }
                case .denied:
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                        let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                            DispatchQueue.main.async {
                                let url = URL(string: UIApplication.openSettingsURLString)!
                                UIApplication.shared.open(url, options: [:])
                            }
                        })
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                        alert.addAction(confirmAction)
                        alert.addAction(cancelAction)
                        
                        self.present(alert, animated: true)
                    }
                    
                case .restricted:
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                        let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                            DispatchQueue.main.async {
                                let url = URL(string: UIApplication.openSettingsURLString)!
                                UIApplication.shared.open(url, options: [:])
                            }
                        })
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                        alert.addAction(confirmAction)
                        alert.addAction(cancelAction)
                        
                        self.present(alert, animated: true)
                    }
                default: break
                }
            }
        }
    }
    
    func presentLimitedPhotoPickerController() {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 1
        config.screens = [.library]
        config.library.defaultMultipleSelection = false
        config.library.skipSelectionsGallery = true
        config.showsPhotoFilters = false
        config.library.preselectedItems = nil
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            var imgs: [UIImage] = []
            for item in items {
                switch item {
                case .photo(let photo):
                    if let img = photo.image.scaled(toWidth: 1200) {
                        imgs.append(img)
                    }
                    print(photo)
                case .video(let video):
                    print(video)
                }
            }
            picker.dismiss(animated: true, completion: nil)
            if !cancelled {
                if let image = imgs.first {
                    self.showEditVC(image: image)
                }
            }
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    
    
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        picker.dismiss(animated: true, completion: nil)
//        var imgList: [UIImage] = []
//
//        for result in results {
//            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
//                if let image = object as? UIImage {
//                    DispatchQueue.main.async {
//                        // Use UIImage
//                        print("Selected image: \(image)")
//                        imgList.append(image)
//                    }
//                }
//            })
//        }
//        if let image = imgList.first {
//            self.showEditVC(image: image)
//        }
//    }
    
 
    func presentPhotoPickerController() {
        let myPickerController = UIImagePickerController()
        myPickerController.allowsEditing = false
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        self.present(myPickerController, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.showEditVC(image: image)
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.showEditVC(image: image)
        }

    }
//
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func showEditVC(image: UIImage) {
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else {return}
            
            let vc = PGIEditVC(image: image)
            self.navigationController?.pushViewController(vc)
        }

    }
    
}


