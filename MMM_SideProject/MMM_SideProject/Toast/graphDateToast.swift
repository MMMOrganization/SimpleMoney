//
//  graphDateToast.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 3/11/25.
//

import UIKit

class graphDateToast: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    let mainView : UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.clipsToBounds = true
        v.layer.cornerRadius = 20
        return v
    }()
    
    lazy var headerStackView : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        return sv
    }()
    
}
