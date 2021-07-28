//
//  TGymeEdiTVC.swift
//  TGymTopGIrds
//
//  Created by JOJO on 2021/7/23.
//

import UIKit
import RxSwift
import DeviceKit

class PGIEditVC: UIViewController {
    let disposeBag = DisposeBag()
    
    let backBtn = UIButton(type: .custom)
    let nextBtn = UIButton(type: .custom)
    
    var contentImage: UIImage
    let contentBgView = UIView()
    let stackView = UIStackView()

    let bottomToolBgContentView = UIView()
    
    let bottomBtnBgView = UIView()
    let canvasView = UIView()
    var gridPreview: MGGridPreview!
    var shapeOverlayerImageV: UIImageView = UIImageView()
    
    var topProAlertBgView = UIView()
    
    var isGridTypePro: Bool = false
    var isShapeTypePro: Bool = false
    
    let gridBtn = MGEditBottonBtn(iconName: "gird_ic", name: "Grid")
    let shapeBtn = MGEditBottonBtn(iconName: "filter_ic", name: "Shape")
    
    let stickerBtn = MGEditBottonBtn(iconName: "sticker_ic", name: "Sticker")
    let fontBtn = MGEditBottonBtn(iconName: "font_ic", name: "Font")
    
    
    let gridBar = TGymeEditToolMaskBar()
    var shapeBar: TGymeFilterEffecBar!
    
    let stickerBar = GCStickerView()
    let fontBar = TGymeTextToolBar()
    let textinputView = SBTextInputVC()
    
    var toolViews: [UIView] = []
    var colorPanView: TGymColorPanView!
    var proAlertV: TGymProAlertView!
    
    init(image: UIImage) {
        self.contentImage = image
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#161616")
        setupActionBlock()
        setupView()
        setupContentPreview()
        
        setupColorPan()
        setupProAlertView()
        gridBtnClick(sender: gridBtn)
    }
    
    
    

}

extension PGIEditVC {
    func checkTopProAlertStatus() {
        var isStickerPro: Bool = false
        
        for stickerView in TMTouchAddonManager.default.addonStickersList {
            if stickerView.stikerItem?.isPro == true {
                isStickerPro = true
            }
        }
        if isShapeTypePro == true || isGridTypePro == true || isStickerPro == true {
//            topProAlertBgView.isHidden = false
            showProAlertV()
        } else {
            
//            topProAlertBgView.isHidden = true
        }
    }
}

extension PGIEditVC {
    
    func setupView() {
        // bottomBtnBgView
        bottomBtnBgView.backgroundColor = UIColor(hexString: "#ACFF34")
        view.addSubview(bottomBtnBgView)
        
        bottomBtnBgView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(190)
            $0.bottom.equalTo(view.snp.bottom)
        }
        
        // contentBgView
        view.addSubview(contentBgView)
        contentBgView.clipsToBounds = true
        contentBgView.layer.cornerRadius = 56
        contentBgView.backgroundColor = UIColor(hexString: "#161616")
        //
        contentBgView.addSubview(bottomToolBgContentView)
        contentBgView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(bottomBtnBgView.snp.top).offset(60)
        }
        
        bottomToolBgContentView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(150)
            $0.bottom.equalTo(bottomBtnBgView.snp.top).offset(20)
            
        }
        
        if Device.current.diagonal == 4.7 || Device.current.diagonal >= 7.9 {
            contentBgView.snp.remakeConstraints {
                $0.left.right.equalToSuperview()
                $0.top.equalToSuperview()
                $0.bottom.equalTo(bottomBtnBgView.snp.top).offset(98)
            }
            
//            bottomBtnBgView.snp.remakeConstraints {
//                $0.left.right.equalToSuperview()
//                $0.height.equalTo(190)
//                $0.bottom.equalTo(view.snp.bottom)
//            }
            
            bottomToolBgContentView.snp.remakeConstraints {
                $0.left.right.equalToSuperview()
                $0.height.equalTo(150)
                $0.bottom.equalTo(bottomBtnBgView.snp.top).offset(86)
                
            }
        } else if Device.current.diagonal == 5.5 {
            bottomToolBgContentView.snp.remakeConstraints {
                $0.left.right.equalToSuperview()
                $0.height.equalTo(150)
                $0.bottom.equalTo(bottomBtnBgView.snp.top).offset(36)
                
            }
        }
        
        
        //
        
        view.addSubview(backBtn)
        backBtn.setImage(UIImage(named: "back_home_ic"), for: .normal)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(10)
            $0.width.equalTo(34)
            $0.height.equalTo(44)
        }
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        //
        let backBtn1 = UIButton(type: .custom)
        backBtn1.setTitleColor(.white, for: .normal)
        backBtn1
            .title("Home")
            .font(20, "Athelas-Regular")
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
        
        view.addSubview(backBtn1)
        backBtn1.snp.makeConstraints {
            $0.top.equalTo(backBtn)
            $0.left.equalTo(backBtn.snp.right)
            $0.width.greaterThanOrEqualTo(40)
            $0.height.equalTo(44)
        }
        // nextBtn
        
        view.addSubview(nextBtn)
        nextBtn.setImage(UIImage(named: "next_edit_ic"), for: .normal)
        nextBtn.snp.makeConstraints {
            $0.centerY.equalTo(backBtn)
            $0.right.equalTo(-16)
            $0.width.equalTo(134/2)
            $0.height.equalTo(64/2)
        }
        nextBtn.addTarget(self, action: #selector(nextBtnClick(sender:)), for: .touchUpInside)
        
        
    }
    
    
    
}

extension PGIEditVC {
    func setupContentPreview() {
        
        
        
          

        // setupCanvasView
        setupCanvasView()
        // bottom tool views
        setupBottomToolViews()
        // bottom btns
        setupBottomBtns()
        
        
//        view.bringSubviewToFront(bottomToolBgView)
    }
    
    func setupCanvasView() {
        
        // canvasView
        canvasView.clipsToBounds = true
        canvasView.backgroundColor = .clear
        contentBgView.addSubview(canvasView)
        canvasView.snp.makeConstraints {
            $0.top.equalTo(backBtn.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(previewWidth)
        }
        let tapGesture = UITapGestureRecognizer.init(target: self, action:#selector(addonBgTapAction(tapGesture:)))
        canvasView.addGestureRecognizer(tapGesture)
        
        
        // gridPreview
        gridPreview = MGGridPreview(frame: CGRect(x: 0, y: 0, width: previewWidth, height: previewWidth), image: contentImage, widthCount: 3, heightCount: 3)
        canvasView.addSubview(gridPreview)

        // shapeOverlayerImageV
        shapeOverlayerImageV.contentMode = .scaleAspectFit
        canvasView.addSubview(shapeOverlayerImageV)
        shapeOverlayerImageV.snp.makeConstraints {
            $0.top.left.right.bottom.equalTo(gridPreview)
        }
        
    }
    
//    func setupTopProAlertView() {
//        topProAlertBgView.isHidden = true
//        contentBgView.addSubview(topProAlertBgView)
//        topProAlertBgView.backgroundColor = .clear
//        topProAlertBgView.snp.makeConstraints {
////            $0.right.equalTo(shapeOverlayerImageV)
//            $0.centerX.equalToSuperview()
//            $0.top.equalTo(-2)
//            $0.width.equalTo(200)
//            $0.height.equalTo(40)
//        }
//
//        let topProAlertLabel = UILabel()
//        topProAlertLabel.textColor = UIColor(hexString: "#FFDC46")
//        topProAlertLabel.textAlignment = .center
//        topProAlertLabel.text = "Current is Purchase Item"
//        topProAlertLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 13)
//
//        topProAlertBgView.addSubview(topProAlertLabel)
//        topProAlertLabel.snp.makeConstraints {
//            $0.center.equalToSuperview()
//            $0.width.height.equalToSuperview()
//        }
//
//    }
    
    func setupBottomToolViews() {
        
        // grid bar
        setupGridBar()
        setupShapeBar()
        setupStickerBar()
        setupFontBar()
  
        toolViews.append(gridBar)
        toolViews.append(shapeBar)
        
        toolViews.append(stickerBar)
        toolViews.append(fontBar)
    }
    
    func setupGridBar() {
        gridBar.alphaSliderValueChangeBlock = {
            [weak self] alpha in
            guard let `self` = self else {return}
            
            
            
            let currentColor = self.gridPreview.currentColor ?? "#FFFFFF"
            let currentGridIndexs = self.gridPreview.currentGridList ?? [0,1]
            let currentAlpha = self.gridPreview.currentAlpha ?? 0.7
            
            self.gridPreview.updateCoverView(alpha: alpha.cgFloat, indexs: currentGridIndexs)
            
//            self.gridPreview.updateCoverView(colorStr: currentColor, alpha: alpha.cgFloat, indexs: currentGridIndexs)
        }
        gridBar.bgColorSelectBlock = {
            [weak self] color in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                if color == "color" {
                    self.showGridColorPan()
                } else {
                    let currentGridIndexs = self.gridPreview.currentGridList ?? [0,1]
                    self.gridPreview.updateCoverView(colorStr: color, indexs: currentGridIndexs)
                    
//                    let currentColor = self.gridPreview.currentColor ?? "#FFFFFF"
//
//                    let currentAlpha = self.gridPreview.currentAlpha ?? 0.7
//                    self.gridPreview.updateCoverView(colorStr: color, alpha: currentAlpha, indexs: currentGridIndexs)
                }
            }
            
        }
        gridBar.gridSelectBlock = {
            [weak self] gridItem in
            guard let `self` = self else {return}
//            let currentColor = self.gridPreview.currentColor ?? "#000000"
//            let currentGridIndexs = self.gridPreview.currentGridList ?? []
//            let currentAlpha = self.gridPreview.currentAlpha ?? 0.7
            self.gridPreview.updateCoverView(indexs: gridItem.gridIndexs ?? [])
//            self.gridPreview.updateCoverView(colorStr: currentColor, alpha: currentAlpha, indexs: gridItem.gridIndexs ?? [])
            
            self.isGridTypePro = gridItem.isPro ?? false
//            self.checkTopProAlertStatus()
        }
        gridBar.alphaSlider.value = self.gridPreview.currentAlpha?.float ?? 0.7
        bottomToolBgContentView.addSubview(gridBar)
        gridBar.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
    }
    
   
    
    func setupShapeBar() {
        // shape bar
        let shapeBar = TGymeFilterEffecBar(frame: CGRect.zero, userImg: contentImage)
        self.shapeBar = shapeBar
        shapeBar.didSelectStickerItemBlock = {
            [weak self] shapeItem in
            guard let `self` = self else {return}
            self.shapeOverlayerImageV.image = UIImage(named: shapeItem.contentImageName ?? "")
            self.isShapeTypePro = shapeItem.isPro ?? false
            if shapeItem.isPro == true {
                self.checkTopProAlertStatus()
            }
        }
        bottomToolBgContentView.addSubview(shapeBar)
        shapeBar.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(110)
        }
    }
    
    
    
    func setupStickerBar() {
        // stickerBar
        stickerBar.didSelectStickerItemBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            guard let stickerImage = UIImage(named: item.contentImageName) else {return}
            TMTouchAddonManager.default.addNewStickerAddonWithStickerImage(stickerImage: stickerImage, stickerItem: item, atView: self.canvasView)
            if item.isPro == true {
                self.checkTopProAlertStatus()
            }
        }
        bottomToolBgContentView.addSubview(stickerBar)
        stickerBar.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(110)
        }
    }
    
    func setupFontBar() {
        // font bar
        TMTouchAddonManager.default.isAllwaysAddNewTextView = true
        fontBar.didSelectFontBlock = {
            [weak self] fontName in
            guard let `self` = self else {return}
            TMTouchAddonManager.default.replaceSetupTextAddonFontItem(fontItem: fontName, fontIndexPath: IndexPath(item: 0, section: 0), canvasView: self.canvasView)
        }
        fontBar.didSelectColorBlock = {
            [weak self] colorHex in
            guard let `self` = self else {return}
            if colorHex.contains("color") {
                self.showFontColorPan()
            } else {
                
                TMTouchAddonManager.default.replaceSetupTextAddonTextColorName(colorName: colorHex, colorIndexPath: IndexPath(item: 0, section: 0), canvasView: self.canvasView)
            }
        }
        
        bottomToolBgContentView.addSubview(fontBar)
        fontBar.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(110)
        }
        
        
        
    }
    
    
    func setupBottomBtns() {
        
        gridBtn.addTarget(self, action: #selector(gridBtnClick(sender:)), for: .touchUpInside)
        
        
        shapeBtn.addTarget(self, action: #selector(shapeBtnClick(sender:)), for: .touchUpInside)
        
        
        
        stickerBtn.addTarget(self, action: #selector(stickerBtnClick(sender:)), for: .touchUpInside)
        
        fontBtn.addTarget(self, action: #selector(fontBtnClick(sender:)), for: .touchUpInside)
        
        
        bottomBtnBgView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.centerY.equalTo(bottomBtnBgView.snp.centerY).offset(24)
            $0.right.equalToSuperview().offset(-25)
            $0.left.equalToSuperview().offset(25)
            $0.height.equalTo(67)
        }
        if Device.current.diagonal == 4.7 || Device.current.diagonal >= 7.9  {
            stackView.snp.remakeConstraints {
                $0.centerY.equalTo(bottomBtnBgView.snp.centerY).offset(50)
                $0.right.equalToSuperview().offset(-25)
                $0.left.equalToSuperview().offset(25)
                $0.height.equalTo(67)
            }
        }
        
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(gridBtn)
        stackView.addArrangedSubview(shapeBtn)
        
        stackView.addArrangedSubview(fontBtn)
        stackView.addArrangedSubview(stickerBtn)
        
        
    }
    
    func setupColorPan() {
        let colorPanView = TGymColorPanView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height))
        self.colorPanView = colorPanView
        view.addSubview(colorPanView)
        colorPanView.isHidden = true
        colorPanView.selectColorItemBlock = {
            [weak self] color in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.gridPreview.updateCoverView(color: color, indexs: self.gridPreview.currentGridList ?? [])
                
            }
        }
        colorPanView.okBtnclickBlock = {
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                self.colorPanView.isHidden = true
            }
        }
    }
    
    func setupProAlertView() {
        let proAlertV = TGymProAlertView()

        self.proAlertV = proAlertV
        view.addSubview(proAlertV)
        proAlertV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        proAlertV.isHidden = true
        proAlertV.okBtnclickBlock = {
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                self.proAlertV.isHidden = true
            }
        }
        proAlertV.cancelBtnclickBlock = {
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                self.proAlertV.isHidden = true
            }
        }
        
    }
    
    
}

extension PGIEditVC {
    func showGridColorPan() {
        self.colorPanView.isHidden = false
        colorPanView.selectColorItemBlock = {
            [weak self] color in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.gridPreview.updateCoverView(color: color, indexs: self.gridPreview.currentGridList ?? [])
                
            }
        }
    }
    func showFontColorPan() {
        self.colorPanView.isHidden = false
        colorPanView.selectColorItemBlock = {
            [weak self] color in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                TMTouchAddonManager.default.replaceSetupTextAddonTextColorName(colorName: color.hexString ?? "#000000", colorIndexPath: IndexPath(item: 0, section: 0), canvasView: self.canvasView)
                
            }
        }
    }
    
    
    
    func showProAlertV() {
        self.proAlertV.isHidden = false
    }
    
}

extension PGIEditVC {
    func proccessSaveImage() -> UIImage? {
        
        let scale: CGFloat = 3
        let width_big: CGFloat = canvasView.frame.size.width * 3
        let canvas_big = UIView()
        canvas_big.backgroundColor = .white
        canvas_big.frame = CGRect(x: 0, y: 0, width: width_big, height: width_big)
        // gridPreview
        let grid_previewBig = MGGridPreview(frame: CGRect(x: 0, y: 0, width: width_big, height: width_big), image: gridPreview.previewImageView.image ?? UIImage(), widthCount: 3, heightCount: 3)
        
        grid_previewBig.updateCoverView(colorStr: self.gridPreview.currentColor ?? "#000000", alpha: self.gridPreview.currentAlpha ?? 0.5 , indexs: self.gridPreview.currentGridList ?? [])
        grid_previewBig.showLineViewsStatus(isShow: false)
        canvas_big.addSubview(grid_previewBig)
        
        // shapeOverlayerImageV
        let shapeOverlayerImageV_big = UIImageView()
        shapeOverlayerImageV_big.contentMode = .scaleAspectFit
        canvas_big.addSubview(shapeOverlayerImageV_big)
        shapeOverlayerImageV_big.frame = CGRect(x: 0, y: 0, width: width_big, height: width_big)
        shapeOverlayerImageV_big.image = shapeOverlayerImageV.image
        
        for stickerView in TMTouchAddonManager.default.addonStickersList {
            let stickerImgV = UIImageView()
            stickerImgV.image = stickerView.contentImageview.image
            stickerImgV.contentMode = .scaleAspectFit
            stickerImgV.bounds = CGRect(x: 0, y: 0, width: stickerView.bounds.size.width * scale, height: stickerView.bounds.size.height * scale)
            stickerImgV.center = CGPoint(x: canvas_big.bounds.size.width / 2, y: canvas_big.bounds.size.height / 2)
            canvas_big.addSubview(stickerImgV)
            transformNewAddonView(newAddon: stickerImgV, originAddon: stickerView, scale: scale)
            
        }
        
        for textView in TMTouchAddonManager.default.addonTextsList {
            let text_Big = UILabel()
            text_Big.numberOfLines = 0
            text_Big.bounds = CGRect.init(x: 0, y: 0, width: textView.contentLabel.bounds.width * scale, height: textView.contentLabel.bounds.size.height * scale)
            text_Big.center = CGPoint(x: canvas_big.bounds.size.width / 2, y: canvas_big.bounds.size.height / 2)
            let attri = NSMutableAttributedString.init(attributedString: textView.contentAttributeString)
            let font_big = UIFont(name: textView.textFont.fontName, size: textView.textFont.pointSize * scale) ?? UIFont.systemFont(ofSize: 30 * scale)
            attri.addAttributes([NSAttributedString.Key.font : font_big], range: NSRange(location: 0, length: attri.length))
            
            text_Big.attributedText = attri
            
            transformNewAddonView(newAddon: text_Big, originAddon: textView, scale: scale)
            
            canvas_big.addSubview(text_Big)
        }
        
//        let canvasImage_big = canvas_big.snapshotView(afterScreenUpdates: true)?.screenshot
        
        let canvasImage_big = canvas_big.screenshot
        
        return canvasImage_big
    }
    
    func transformNewAddonView(newAddon: UIView, originAddon: UIView, scale: CGFloat) {
        
        let originalTransform = originAddon.transform
        let translation = CGPoint(x: originalTransform.tx * scale, y: originalTransform.ty * scale)
        let rotation = atan2(originalTransform.b, originalTransform.a)
        let scaleX = sqrt(originAddon.transform.a * originAddon.transform.a + originAddon.transform.c * originAddon.transform.c)
        let scaleY = sqrt(originAddon.transform.b * originAddon.transform.b + originAddon.transform.d * originAddon.transform.d)
        
        newAddon.transform = newAddon.transform.translatedBy(x: translation.x, y: translation.y)
        newAddon.transform = newAddon.transform.rotated(by: rotation)
        newAddon.transform = newAddon.transform.scaledBy(x: scaleX, y: scaleY)
    }
    
    
}


extension PGIEditVC {
    @objc func backBtnClick(sender: UIButton) {
        TMTouchAddonManager.default.clearAddonManagerDefaultStatus()
        if self.navigationController == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController()
        }
    }
    @objc func nextBtnClick(sender: UIButton) {
        TMTouchAddonManager.default.cancelCurrentAddonHilightStatus()
//        let saveActionBlock: (()->Void) = {
//            [weak self] in
//            guard let `self` = self else {return}
//            if let image_big = self.proccessSaveImage(), let smallPreivew = self.canvasView.screenshot {
//
//
//            }
//        }
//
//        saveActionBlock()
//
        
        //
        var totalIsPro: Bool = false
        
        var isStickerPro: Bool = false
        for stickerView in TMTouchAddonManager.default.addonStickersList {
            if stickerView.stikerItem?.isPro == true {
                isStickerPro = true
            }
        }
        if self.isShapeTypePro == true || self.isGridTypePro == true || isStickerPro == true {
            
            totalIsPro = true
            
        }
        
        if let image_big = self.proccessSaveImage(), let smallPreivew = self.canvasView.screenshot {
            let saveVC = TGymeSavEVC.init(bigImage_save: image_big, previewImage_small: smallPreivew, isPro: totalIsPro)
            self.navigationController?.pushViewController(saveVC, animated: true)

        }
        
    }
    
    @objc func gridBtnClick(sender: UIControl) {
        showToolView(toolView: gridBar, btn: sender, titleName: "Grid")
        TMTouchAddonManager.default.cancelCurrentAddonHilightStatus()
    }
    @objc func shapeBtnClick(sender: UIControl) {
        showToolView(toolView: shapeBar, btn: sender, titleName: "Shape")
        TMTouchAddonManager.default.cancelCurrentAddonHilightStatus()
    }
    
    @objc func stickerBtnClick(sender: UIControl) {
        showToolView(toolView: stickerBar, btn: sender, titleName: "Sticker")
        TMTouchAddonManager.default.cancelCurrentAddonHilightStatus()
         
        
    }
    @objc func fontBtnClick(sender: UIControl) {
        showToolView(toolView: fontBar, btn: sender, titleName: "Font")
        TMTouchAddonManager.default.cancelCurrentAddonHilightStatus()
    }
    
//    @objc func bottomToolBgDoneBtnClick(sender: UIButton) {
//        bottomToolBgView.isHidden = true
//        bottomToolBgContentView.isHidden = true
//        TMTouchAddonManager.default.cancelCurrentAddonHilightStatus()
//
//    }
    
    @objc
    func addonBgTapAction(tapGesture: UITapGestureRecognizer) {
        TMTouchAddonManager.default.cancelCurrentAddonHilightStatus()
    }
    
}

extension PGIEditVC {
    
    func setupActionBlock() {
         
        TMTouchAddonManager.default.doubleTapTextAddonActionBlock = { [weak self] contentString, font in
            guard let `self` = self else {return}
            self.showTextInputViewStatus(contentString: contentString, font: font)
            
        }
        
        TMTouchAddonManager.default.textAddonReplaceBarStatusBlock = { [weak self] textAddon in
            guard let `self` = self else {return}
            
            self.fontBar.replaceSetupBarStatusWith(colorHex: textAddon.textColorName, fontName: textAddon.contentLabel.font.fontName)
            
        }
        
        
        TMTouchAddonManager.default.removeStickerAddonActionBlock = { [weak self] in
            guard let `self` = self else {return}
//            self.checkTopProAlertStatus()
            
        }
        
    }
}

extension PGIEditVC {
    func showToolView(toolView: UIView, btn: UIControl, titleName: String) {
        
        for subView in toolViews {
            if toolView == subView {
                subView.isHidden = false
            } else {
                subView.isHidden = true
            }
        }
        for btnm in stackView.arrangedSubviews {
            if let btn_m = btnm as? UIControl {
                if btn_m == btn {
                    btn_m.alpha = 1
                } else {
                    btn_m.alpha = 0.25
                }
            }
        }
        
    }
    
    func showTextInputViewStatus(contentString: String, font: UIFont) {
        let textinputVC = SBTextInputVC()
        self.addChild(textinputVC)
        view.addSubview(textinputVC.view)
        textinputVC.view.alpha = 0
        textinputVC.startEdit()
        UIView.animate(withDuration: 0.25) {
            [weak self] in
            guard let `self` = self else {return}
            textinputVC.view.alpha = 1
        }
        textinputVC.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        textinputVC.contentTextView.becomeFirstResponder()
        textinputVC.cancelClickActionBlock = {
            
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let `self` = self else {return}
                textinputVC.view.alpha = 0
            } completion: {[weak self] (finished) in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    textinputVC.removeViewAndControllerFromParentViewController()
                }
            }

            
            
            textinputVC.contentTextView.resignFirstResponder()
        }
        textinputVC.doneClickActionBlock = {
            [weak self] contentString, isAddNew in
            guard let `self` = self else {return}
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let `self` = self else {return}
                textinputVC.view.alpha = 0
            } completion: {[weak self] (finished) in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    textinputVC.removeViewAndControllerFromParentViewController()
                }
            }
            textinputVC.contentTextView.resignFirstResponder()
            TMTouchAddonManager.default.replaceSetupTextContentString(contentString: contentString, canvasView: self.canvasView)
            
        }
    }
    
    
    
}




class MGEditBottonBtn: UIControl {
    
    let iconImageV = UIImageView()
    let nameLabel = UILabel()
    
    let iconName: String
    let name: String
    
    override init(frame: CGRect) {
        self.iconName = ""
        self.name = ""
        super.init(frame: frame)
        
        setupView()
    }
    
    init(iconName: String, name: String) {
        self.iconName = iconName
        self.name = name
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        iconImageV.image = UIImage(named: iconName)
        iconImageV.contentMode = .scaleAspectFit
        addSubview(iconImageV)
        iconImageV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
         
        
    }
    
}




