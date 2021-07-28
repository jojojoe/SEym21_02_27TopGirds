//
//  DaLMymDataManager.swift
//  LMymLayMirrorEff
//
//  Created by JOJO on 2021/7/14.
//

import Foundation
import UIKit
import GPUImage
import SwifterSwift


struct GridItem: Codable {
    var isPro: Bool? = false
    var thumb: String? = ""
    var gridIndexs: [Int]? = [0, 3, 6,]
    
}

class GCFilterItem: Codable {

    let filterName : String
    let type : String
    let imageName : String
    
    enum CodingKeys: String, CodingKey {
        case filterName
        case type
        case imageName
    }
    
}


class LMynARTDataManager {
//    var layoutTypeList: [NEymEditToolItem] = []
//    var bgColorList: [NEymEditToolItem] = []
//    var bgColorImgList: [NEymEditToolItem] = []
//    var stickerItemList: [NEymEditToolItem] = []
//
    
    
    
    var textColors: [String] = []
    var textFontNames: [String] = []
    var bgColors: [String] = []
    
    var maskList: [GridItem] {
        return LMynARTDataManager.default.loadJson([GridItem].self, name: "GridList") ?? []
    }
    
    
    var overlayerImgList : [GCStickerItem] {
        return LMynARTDataManager.default.loadJson([GCStickerItem].self, name: "overlayerImgList") ?? []
    }
    
    var stickerList : [GCStickerItem] {
        return LMynARTDataManager.default.loadJson([GCStickerItem].self, name: "StickerList") ?? []
    }
    
    static let `default` = LMynARTDataManager()
    
    init() {
        loadData()
    }
    
    func loadData() {
        
//        bgColorList = loadJson([NEymEditToolItem].self, name: "bgColor") ?? []
//        bgColorImgList = loadJson([NEymEditToolItem].self, name: "bgColorImg") ?? []
//        stickerItemList = loadJson([NEymEditToolItem].self, name: "mirrorSticker") ?? []
//        layoutTypeList = loadJson([NEymEditToolItem].self, name: "layoutStyleList") ?? []
//        
//        
        textColors = ["#000000","#FFFFFF","#FFB6C1","#FF69B4","#FF00FF","#7B68EE","#0000FF","#4169E1","#00BFFF","#00FFFF","#F5FFFA","#3CB371","#98FB98","#32CD32","#FFFF00","#FFD700","#FFA500","#FF7F50","#CD853F","#00FA9A"]
        textFontNames = ["Avenir-Heavy", "Baskerville-BoldItalic", "ChalkboardSE-Bold", "Courier-BoldOblique", "Didot-Bold", "DINCondensed-Bold", "Futura-MediumItalic", "Georgia-Bold", "KohinoorBangla-Semibold", "NotoSansKannada-Bold", "Palatino-BoldItalic", "SnellRoundhand-Bold", "Verdana-Bold",  "GillSans-Bold", "Rockwell-Bold", "TrebuchetMS-Bold"]
        bgColors = ["#FFFFFF","#000000","#FFB6C1","#FF69B4","#FF00FF","#7B68EE","#0000FF","#4169E1","#00BFFF","#00FFFF","#F5FFFA","#3CB371","#98FB98","#32CD32","#FFFF00","#FFD700","#FFA500","#FF7F50","#CD853F","#00FA9A"]
        
        
        
    }
    
    
}


extension LMynARTDataManager {
    func loadJson<T: Codable>(_:T.Type, name: String, type: String = "json") -> T? {
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                return try! JSONDecoder().decode(T.self, from: data)
            } catch let error as NSError {
                debugPrint(error)
            }
        }
        return nil
    }
    
    func loadJson<T: Codable>(_:T.Type, path:String) -> T? {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            do {
                return try PropertyListDecoder().decode(T.self, from: data)
            } catch let error as NSError {
                print(error)
            }
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
    func loadPlist<T: Codable>(_:T.Type, name:String, type:String = "plist") -> T? {
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            return loadJson(T.self, path: path)
        }
        return nil
    }
    
}



struct NEymEditToolItem: Codable, Hashable {
    static func == (lhs: NEymEditToolItem, rhs: NEymEditToolItem) -> Bool {
        return lhs.thumbName == rhs.thumbName
    }
    var thumbName: String = ""
    var bigName: String = ""
    var isPro: Bool = false
     
}

class GCPaintItem: Codable {
    let previewImageName : String
    let StrokeType : String
    let gradualColorOne : String
    let gradualColorTwo : String
    let isDashLine : Bool
    
    
}
 
// filter
extension LMynARTDataManager {
    func filterOriginalImage(image: UIImage, lookupImgNameStr: String) -> UIImage? {
        
        if let gpuPic = GPUImagePicture(image: image), let lookupImg = UIImage(named: lookupImgNameStr), let lookupPicture = GPUImagePicture(image: lookupImg) {
            let lookupFilter = GPUImageLookupFilter()
            
            gpuPic.addTarget(lookupFilter, atTextureLocation: 0)
            lookupPicture.addTarget(lookupFilter, atTextureLocation: 1)
            lookupFilter.intensity = 0.7
            
            lookupPicture.processImage()
            gpuPic.processImage()
            lookupFilter.useNextFrameForImageCapture()
            let processedImage = lookupFilter.imageFromCurrentFramebuffer()
            return processedImage
        } else {
            return nil
        }
        return nil
    }
}
