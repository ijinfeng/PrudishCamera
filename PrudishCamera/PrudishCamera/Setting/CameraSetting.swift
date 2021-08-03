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
