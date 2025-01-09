//
//  CreateViewController.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 12/28/24.
//

import UIKit

class CreateViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        // Do any additional setup after loading the view.
    }
    
    func setLayout() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.scrollEdgeAppearance =
        navigationController?.navigationBar.standardAppearance
        view.backgroundColor = .white
    }
}
