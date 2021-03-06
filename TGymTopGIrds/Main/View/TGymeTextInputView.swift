//
//  TGymeTextInputView.swift
//  TGymTopGIrds
//
//  Created by JOJO on 2021/7/23.
//

import UIKit
import SnapKit
import ZKProgressHUD

let maxLableCount: Int = 30
class SBTextInputVC: UIViewController {

    var cancelBtn: UIButton = UIButton.init(type: .custom)
    var doneBtn: UIButton = UIButton.init(type: .custom)
    
    var contentTextView: UITextView = UITextView.init()
    var cancelClickActionBlock: (()->Void)?
    var doneClickActionBlock: ((String, Bool)->Void)?
    
    var limitLabel: UILabel = UILabel.init(text: "0/\(maxLableCount)")
    
    
    
    // Public
    var contentText: String = "" {
        didSet {
            updateLimitTextLabel(contentText: contentText)
//            "Begin writing your story here"
            let defaultText = "Begin writing your story here"
            if contentText == defaultText || contentText == "" {
                contentTextView.text = ""
                contentTextView.placeholder = defaultText
            } else {
                contentTextView.text = contentText
                contentTextView.placeholder = ""
                
            }
            
        }
    }
    var isAddNew: Bool = false
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTextView()
        setupTextViewNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
 
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updatUI()
    }
}

extension SBTextInputVC {
    
    func updatUI() {
        
         
         
    }
    
    func setupView() {
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        // blur
        let blur = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView.init(effect: blur)
        view.addSubview(effectView)
        effectView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
        
        
        view.addSubview(cancelBtn)
        view.addSubview(doneBtn)
        
        
        cancelBtn.snp.makeConstraints {
            $0.width.equalTo(65)
            $0.height.equalTo(44)
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }
        
        doneBtn.snp.makeConstraints {
            $0.width.equalTo(67)
            $0.height.equalTo(32)
            $0.centerY.equalTo(cancelBtn)
            $0.right.equalToSuperview().offset(-10)
        }
        
        //
        cancelBtn.setImage(UIImage(named: "ostcoin_ic_close"), for: .normal)
        cancelBtn.backgroundColor = UIColor.clear
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick(btn:)), for: .touchUpInside)

        doneBtn
            .title("Done")
            .titleColor(UIColor(hexString: "#161616")!)
            .backgroundColor(UIColor(hexString: "#92E121")!)
            .font(18, "Athelas-Regular")
        doneBtn.layer.cornerRadius = 8
        doneBtn.addTarget(self, action: #selector(doneBtnClick(btn:)), for: .touchUpInside)
    }
    
    @objc
    func cancelBtnClick(btn: UIButton) {
        finishEdit()
        cancelClickActionBlock?()
    }
    
    @objc
    func doneBtnClick(btn: UIButton) {
        
        finishEdit()
        doneClickActionBlock?(contentTextView.text, isAddNew)

    }
    
    func setupTextView() {
        
        contentTextView.backgroundColor = .clear
        contentTextView.textColor = UIColor.white
        contentTextView.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(contentTextView)
        contentTextView.delegate = self
        contentTextView.textAlignment = .left
        contentTextView.snp.makeConstraints {
            $0.left.equalTo(cancelBtn.snp.right)
            $0.right.equalTo(doneBtn.snp.left)
            $0.top.equalTo(cancelBtn.snp.bottom).offset(20)
            $0.height.equalTo(280)
        }

        
        limitLabel.textAlignment = .right
        limitLabel.font =  UIFont(name: "IBMPlexSans", size: 16)
        limitLabel.textColor = UIColor.white
        view.addSubview(limitLabel)
        limitLabel.snp.makeConstraints {
            $0.right.equalTo(contentTextView)
            $0.top.equalTo(contentTextView.snp.bottom).offset(10)
            $0.width.equalTo(80)
            $0.height.equalTo(30)
        }
        
    }
    
}

extension SBTextInputVC {
    func finishEdit() {
        contentTextView.resignFirstResponder()
    }
    
    func startEdit() {
        contentTextView.becomeFirstResponder()
    }

    func updateLimitTextLabel(contentText: String) {
        
        limitLabel.text = "\(contentText.count)/\(maxLableCount)"
        if contentText.count >= maxLableCount {
            limitLabel.textColor = UIColor.white
            showCountLimitAlert()
        } else {
            limitLabel.textColor = UIColor.white
        }
    }

}
 

extension SBTextInputVC: UITextViewDelegate {
    
    func showCountLimitAlert() {
        if !ZKProgressHUD.isShowing {
            ZKProgressHUD.showInfo("No more than \(maxLableCount) characters.", maskStyle: nil, onlyOnceFont: nil, autoDismissDelay: 2, completion: nil)
        }
        
    }
    
    func setupTextViewNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(textViewNotifitionAction), name: UITextView.textDidChangeNotification, object: nil);
    }
    @objc
    func textViewNotifitionAction(userInfo:NSNotification){
        guard let textView = userInfo.object as? UITextView else { return }
        if textView.text.count >= maxLableCount {
            let selectRange = textView.markedTextRange
            if let selectRange = selectRange {
                let position =  textView.position(from: (selectRange.start), offset: 0)
                if (position != nil) {
                    // ???????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
                    return
                }

            }
            textView.text = String(textView.text[..<String.Index(encodedOffset: maxLableCount)])

            // ?????????????????????case????????????????????????????????????????????????????????????????????????
            textView.selectedRange = NSRange(location: textView.text.count, length: 0)
        }
        
        contentText = textView.text
        
    }
     
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // range: The range of characters to be replaced.(location???count)
        // ????????????
        let selectedRange = textView.markedTextRange
        if let selectedRange = selectedRange {
            let position =  textView.position(from: (selectedRange.start), offset: 0)
            if position != nil {
                let startOffset = textView.offset(from: textView.beginningOfDocument, to: selectedRange.start)
                let endOffset = textView.offset(from: textView.beginningOfDocument, to: selectedRange.end)
                let offsetRange = NSMakeRange(startOffset, endOffset - startOffset) // ????????????????????????
                if offsetRange.location < maxLableCount {
                    // ????????????????????????????????????
                    return true
                } else {
                    debugPrint("??????????????????")
                    return false
                }
            }
        }

        // ???????????????
        if range.location >= maxLableCount {
            debugPrint("??????????????????")
            return false
        }

        // ?????????????????????
        if textView.text.count >= maxLableCount && range.length <  text.count {
            debugPrint("??????????????????")
            return false
        }

        return true
    }
    
}

