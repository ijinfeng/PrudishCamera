//
//  CameraSetting.swift
//  PrudishCamera
//
//  Created by JinFeng on 2021/8/3.
//

import Foundation

class Setting: NSObject {
    enum Template {
        case defalut
        case weixin
        case toutiao
    }
    
    var template: Template = .defalut
    
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
