//
//  graphDateToast.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 3/11/25.
//

import UIKit

class graphDateToastView : UIViewController {
    
    var viewModel : GraphViewModelInterface
    
    let mainView : UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.clipsToBounds = true
        v.layer.cornerRadius = 20
        return v
    }()
    
    lazy var headerStackView : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [headerLabel, headerButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    let headerLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .blackColor
        label.font = UIFont(size: 14.0)
        return label
    }()
    
    let headerButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "following"), for: .normal)
        return button
    }()
    
    let tableView : UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    init(viewModel: GraphViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    func setLayout() {
        view.addSubview(mainView)
        mainView.addSubview(headerStackView)
        mainView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            mainView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            mainView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            mainView.heightAnchor.constraint(equalToConstant: 400),
            
            headerStackView.leadingAnchor.constraint(equalTo: self.mainView.leadingAnchor),
            headerStackView.trailingAnchor.constraint(equalTo: self.mainView.trailingAnchor),
            headerStackView.topAnchor.constraint(equalTo: self.mainView.topAnchor),
            headerStackView.heightAnchor.constraint(equalToConstant: 60),
            
            headerLabel.leadingAnchor.constraint(equalTo: self.headerStackView.leadingAnchor, constant: 15),
            headerLabel.centerYAnchor.constraint(equalTo: self.headerStackView.centerYAnchor),
            
            headerButton.trailingAnchor.constraint(equalTo: self.headerStackView.trailingAnchor, constant: -15),
            headerButton.centerYAnchor.constraint(equalTo: self.headerStackView.centerYAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: self.mainView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.mainView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.mainView.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: self.headerStackView.bottomAnchor)
        ])
    }
}
