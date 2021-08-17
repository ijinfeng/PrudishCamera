//
//  CameraSetting.swift
//  PrudishCamera
//
//  Created by JinFeng on 2021/8/3.
//

import Foundation
import UIKit

class Setting: NSObject {
    enum Template {
        case defalut
        case weixin
        case toutiao
    }
    
    /// 模版类型
    var template: Template = .defalut
    /// 是否开启雷达提示
    /// 开启后在人脸达到最佳焦点附近时会声音提示
    var openRadar = false
    /// 是否开启震动提示
    /// 开启后在人脸达到最佳焦点附近时会震动提示
    var openShake = false
    /// 是否开启自动对焦
    /// 关闭则需要手动设置最佳焦点
    var openAutoFocusing = true
    /// 手动设置的焦点
    var customFocusingValue: CGPoint?
    /// 是否开启预览
    var openPreview = false
    
    
    enum AnchorType {
        /// 十字锚点
        case cross
        /// 三点：左眼，右眼，嘴巴
        case threePoint
    }
    
    
    required init?(coder: NSCoder) {
        super.init()
        decode(with: coder)
    }
    
    override init() {
        super.init()
    }
    
    func save() {
        guard let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return
        }
        let savePath = URL(fileURLWithPath: documentPath).appendingPathComponent("prudish.camera.archive")
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
            do {
                try data.write(to: savePath)
            } catch {
                print("User setting save failed: \(error)")
            }
        } catch {
            print("Archive data failed: \(error)")
        }
    }
    
    static func read() -> Setting {
        guard let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return Setting()
        }
        let savePath = URL(fileURLWithPath: documentPath).appendingPathComponent("prudish.camera.archive")
        do {
            let data = try Data.init(contentsOf: savePath)
            let model = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Setting
            return model ?? Setting()
        } catch {
            print("Read data failed: \(error)")
        }
        return Setting()
    }
}

extension Setting: NSCoding, NSSecureCoding {
    func encode(with coder: NSCoder) {
        coder.encode(template, forKey: "template")
    }
    
    func decode(with coder: NSCoder) {
        template = coder.decodeObject(forKey: "template") as! Setting.Template
    }
    
    static var supportsSecureCoding: Bool {
        true
    }
    
}
