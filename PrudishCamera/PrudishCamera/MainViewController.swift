//
//  MainViewController.swift
//  PrudishCamera
//
//  Created by JinFeng on 2021/8/3.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = CameraViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
