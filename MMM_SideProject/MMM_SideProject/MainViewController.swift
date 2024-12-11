//
//  MainViewController.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 12/11/24.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - 스크롤 뷰
    let scrollView : UIScrollView = {
        let sc = UIScrollView()
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.backgroundColor = .white
        return sc
    }()
    
    let contentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Top View
    
    let topView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexCode: ColorConst.mainColorString, alpha: 0.08)
        return view
    }()
    
    let topConstantLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontConst.mainFont, size: 16.0)
        label.text = "이만큼 사용했어요"
        label.textAlignment = .right
        label.textColor = UIColor(hexCode: ColorConst.grayColorString)
        return label
    }()
    
    let topExpendLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontConst.mainFont, size: 30.0)
        label.text = "120,000원"
        label.textAlignment = .right
        label.textColor = UIColor(hexCode: ColorConst.blackColorString)
        return label
    }()
    
    let topDateView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexCode: ColorConst.mainColorString, alpha: 0.10)
        view.layer.cornerRadius = 20
        view.roundCorners(
            cornerRadius: 20,
            maskedCorners: CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        )
        return view
    }()
    
    let topDateLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2024년 12월"
        label.font = UIFont(name: FontConst.mainFont, size: 15.0)
        label.textAlignment = .center
        label.textColor = UIColor(hexCode: ColorConst.blackColorString)
        return label
    }()
    
    let previousDateButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "previous"), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    let followingDateButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "following"), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        // Do any additional setup after loading the view.
    }
    
    func setLayout() {
        self.view.backgroundColor = .white
        
        // MARK: - Scroll View 추가
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        
        self.contentView.addSubview(topView)
        self.contentView.addSubview(topConstantLabel)
        self.contentView.addSubview(topExpendLabel)
        
        self.topView.addSubview(topDateView)
        
        self.topDateView.addSubview(topDateLabel)
        self.topDateView.addSubview(previousDateButton)
        self.topDateView.addSubview(followingDateButton)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            
            // 스크롤 가능한 높이 설정 (1300까지)
            contentView.heightAnchor.constraint(equalToConstant: 1300),
            
            // 세로 방향의 스크롤뷰 설정
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // MARK: - topView Layout
            topView.topAnchor.constraint(equalTo: self.view.topAnchor),
            topView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 193),
            
            // MARK: - topConstantLabel Layout
            topConstantLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 90),
            topConstantLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -24),
            
            // MARK: - topExpendLabel Layout
            topExpendLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 115),
            topExpendLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24),
            
            // MARK: - topDateView Layout
            topDateView.bottomAnchor.constraint(equalTo: self.topView.bottomAnchor),
            topDateView.leadingAnchor.constraint(equalTo: self.topView.leadingAnchor, constant: 24),
            topDateView.trailingAnchor.constraint(equalTo: self.topView.trailingAnchor, constant: -24),
            topDateView.heightAnchor.constraint(equalToConstant: 25),
            
            // MARK: - topDateLabel Layout
            topDateLabel.centerXAnchor.constraint(equalTo: self.topDateView.centerXAnchor),
            topDateLabel.centerYAnchor.constraint(equalTo: self.topDateView.centerYAnchor),
            
            
            // MARK: - DateButtons Layout
            previousDateButton.heightAnchor.constraint(equalToConstant: 17),
            previousDateButton.widthAnchor.constraint(equalToConstant: 17),
            previousDateButton.trailingAnchor.constraint(equalTo: self.topDateLabel.leadingAnchor, constant: -9),
            previousDateButton.centerYAnchor.constraint(equalTo: self.topDateView.centerYAnchor),
            
            followingDateButton.heightAnchor.constraint(equalToConstant: 17),
            followingDateButton.widthAnchor.constraint(equalToConstant: 17),
            followingDateButton.leadingAnchor.constraint(equalTo: self.topDateLabel.trailingAnchor, constant: 9),
            followingDateButton.centerYAnchor.constraint(equalTo: self.topDateView.centerYAnchor)
            
            
        ])
    }
}
