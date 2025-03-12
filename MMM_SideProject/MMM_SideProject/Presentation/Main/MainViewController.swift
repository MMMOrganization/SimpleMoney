//
//  MainViewController.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 12/11/24.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - Legacy 코드 (사용하지 않는 ViewController)
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
    
    
    // MARK: - Recently View
    lazy var recentlyStackView : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [recentlyConstantExpendLabel, recentlyView])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 5
        sv.alignment = .fill
        return sv
    }()
    let recentlyConstantExpendLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "가장 최근 지출은?"
        label.font = UIFont(name: FontConst.mainFont, size: 18.0)
        label.textColor = UIColor(hexCode: ColorConst.blackColorString)
        return label
    }()
    let recentlyView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 30
        view.backgroundColor = UIColor(hexCode: ColorConst.mainColorString, alpha: 0.10)
        // 가로로 8만큼, 높이로 8만큼 띄어서 그림자 생성
        return view
    }()
    let recentlyTodayDateLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(hexCode: ColorConst.grayColorString)
        label.text = "12/6"
        label.font = UIFont(name: FontConst.mainFont, size: 16)
        return label
    }()
    let recentlyImage : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "Vector")
        image.backgroundColor = .clear
        return image
    }()
    let recentlyImageTypeLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontConst.mainFont, size: 14)
        label.textColor = UIColor(hexCode: ColorConst.grayColorString, alpha: 0.80)
        label.textAlignment = .center
        label.text = "카페 음료"
        return label
    }()
    let recentlyAmountLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontConst.mainFont, size: 25)
        label.textColor = UIColor(hexCode: ColorConst.blackColorString)
        label.textAlignment = .right
        label.text = "5,300원"
        return label
    }()
    
    
    // MARK: - Most View
    lazy var mostStackView : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [mostConstantExpendLabel, mostView])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 5
        sv.alignment = .fill
        return sv
    }()
    let mostConstantExpendLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "가장 최근 지출은?"
        label.font = UIFont(name: FontConst.mainFont, size: 18.0)
        label.textColor = UIColor(hexCode: ColorConst.blackColorString)
        return label
    }()
    let mostView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 30
        view.backgroundColor = UIColor(hexCode: ColorConst.mainColorString, alpha: 0.10)
        // 가로로 8만큼, 높이로 8만큼 띄어서 그림자 생성
        return view
    }()
    let mostTodayDateLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(hexCode: ColorConst.grayColorString)
        label.text = "12/6"
        label.font = UIFont(name: FontConst.mainFont, size: 16)
        return label
    }()
    let mostImageView : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "Vector")
        image.backgroundColor = .clear
        return image
    }()
    let mostImageTypeLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontConst.mainFont, size: 14)
        label.textColor = UIColor(hexCode: ColorConst.grayColorString, alpha: 0.80)
        label.textAlignment = .center
        label.text = "카페 음료"
        return label
    }()
    let mostAmountLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontConst.mainFont, size: 25)
        label.textColor = UIColor(hexCode: ColorConst.blackColorString)
        label.textAlignment = .right
        label.text = "5,300원"
        return label
    }()
    
    lazy var pieChartStackView : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [pieChartConstantLabel, pieChartBackgroundView])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 5
        sv.alignment = .fill
        return sv
    }()
    let pieChartConstantLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontConst.mainFont, size: 18)
        label.text = "지출 통계 차트를 확인해보세요."
        return label
    }()
    let pieChartBackgroundView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexCode: ColorConst.mainColorString, alpha: 0.10)
        view.clipsToBounds = true
        view.layer.cornerRadius = 30
        return view
    }()
    let pieChartView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    
    lazy var barChartStackView : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [barChartTitleView, barChartView])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 5
        return sv
    }()
    
    let barChartTitleView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor(hexCode: ColorConst.mainColorString, alpha: 0.10)
        return view
    }()
    
    let barChartTitleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontConst.mainFont, size: 15.0)
        label.text = "지출 내역을 막대 그래프로 확인해보세요."
        return label
    }()
    
    let barChartView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        pieChartView.layer.cornerRadius = pieChartView.frame.width / 2
    }
    
    func setLayout() {
        self.view.backgroundColor = .white
        
        // MARK: - Scroll View 추가
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        
        self.contentView.addSubview(topView)
        self.contentView.addSubview(topConstantLabel)
        self.contentView.addSubview(topExpendLabel)
        
        self.contentView.addSubview(recentlyStackView)
        self.contentView.addSubview(mostStackView)
        self.contentView.addSubview(pieChartStackView)
        self.contentView.addSubview(barChartStackView)
        
        self.topView.addSubview(topDateView)
        
        self.topDateView.addSubview(topDateLabel)
        self.topDateView.addSubview(previousDateButton)
        self.topDateView.addSubview(followingDateButton)
        
        self.recentlyView.addSubview(recentlyTodayDateLabel)
        self.recentlyView.addSubview(recentlyImage)
        self.recentlyView.addSubview(recentlyImageTypeLabel)
        self.recentlyView.addSubview(recentlyAmountLabel)
        
        self.mostView.addSubview(mostTodayDateLabel)
        self.mostView.addSubview(mostImageView)
        self.mostView.addSubview(mostImageTypeLabel)
        self.mostView.addSubview(mostAmountLabel)
        
        self.pieChartBackgroundView.addSubview(pieChartView)
        
        self.barChartTitleView.addSubview(barChartTitleLabel)
        
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
            contentView.heightAnchor.constraint(equalToConstant: 1400),
            
            // 세로 방향의 스크롤뷰 설정
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // MARK: - topView Layout
            topView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            topView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 193),
            
            // MARK: - topConstantLabel Layout
            topConstantLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 90),
            topConstantLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -24),
            
            // MARK: - topExpendLabel Layout
            topExpendLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 115),
            topExpendLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -24),
            
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
            followingDateButton.centerYAnchor.constraint(equalTo: self.topDateView.centerYAnchor),
            
            // MARK: - recentlyStackView Layout
            recentlyStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 24),
            recentlyStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -24),
            recentlyStackView.heightAnchor.constraint(equalToConstant: 190),
            recentlyStackView.topAnchor.constraint(equalTo: self.topView.bottomAnchor, constant: 10),
            
            // MARK: - recentlyView Layout
            recentlyView.heightAnchor.constraint(equalToConstant: 145),
            
            recentlyTodayDateLabel.leadingAnchor.constraint(equalTo: self.recentlyView.leadingAnchor, constant: 20),
            recentlyTodayDateLabel.topAnchor.constraint(equalTo: self.recentlyView.topAnchor, constant: 10),
            
            recentlyImage.widthAnchor.constraint(equalToConstant: 40),
            recentlyImage.heightAnchor.constraint(equalToConstant: 40),
            recentlyImage.centerYAnchor.constraint(equalTo: self.recentlyView.centerYAnchor),
            recentlyImage.leadingAnchor.constraint(equalTo: self.recentlyView.leadingAnchor, constant: 40),
            
            recentlyImageTypeLabel.centerXAnchor.constraint(equalTo: self.recentlyImage.centerXAnchor),
            recentlyImageTypeLabel.topAnchor.constraint(equalTo: self.recentlyImage.bottomAnchor, constant: 5),
            
            recentlyAmountLabel.trailingAnchor.constraint(equalTo: self.recentlyView.trailingAnchor, constant: -20),
            recentlyAmountLabel.bottomAnchor.constraint(equalTo: self.recentlyView.bottomAnchor, constant: -20),
            
            // MARK: - mostStackView Layout
            mostStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 24),
            mostStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -24),
            mostStackView.heightAnchor.constraint(equalToConstant: 190),
            mostStackView.topAnchor.constraint(equalTo: self.recentlyStackView.bottomAnchor, constant: 10),
            
            // MARK: - mostView Layout
            mostView.heightAnchor.constraint(equalToConstant: 145),
            
            mostTodayDateLabel.leadingAnchor.constraint(equalTo: self.mostView.leadingAnchor, constant: 20),
            mostTodayDateLabel.topAnchor.constraint(equalTo: self.mostView.topAnchor, constant: 10),
            
            mostImageView.widthAnchor.constraint(equalToConstant: 40),
            mostImageView.heightAnchor.constraint(equalToConstant: 40),
            mostImageView.centerYAnchor.constraint(equalTo: self.mostView.centerYAnchor),
            mostImageView.leadingAnchor.constraint(equalTo: self.mostView.leadingAnchor, constant: 40),
            
            mostImageTypeLabel.centerXAnchor.constraint(equalTo: self.mostImageView.centerXAnchor),
            mostImageTypeLabel.topAnchor.constraint(equalTo: self.mostImageView.bottomAnchor, constant: 5),
            
            mostAmountLabel.trailingAnchor.constraint(equalTo: self.mostView.trailingAnchor, constant: -20),
            mostAmountLabel.bottomAnchor.constraint(equalTo: self.mostView.bottomAnchor, constant: -20),
            
            // MARK: - pieChartStackView Layout
            pieChartStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 24),
            pieChartStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -24),
            pieChartStackView.heightAnchor.constraint(equalToConstant: 390),
            pieChartStackView.topAnchor.constraint(equalTo: self.mostView.bottomAnchor, constant: 10),
            
            // MARK: - pieChartView Layout
            pieChartBackgroundView.heightAnchor.constraint(equalToConstant: 340),
            
            pieChartView.widthAnchor.constraint(equalToConstant: 270),
            pieChartView.heightAnchor.constraint(equalToConstant: 270),
            pieChartView.centerXAnchor.constraint(equalTo: self.pieChartBackgroundView.centerXAnchor),
            pieChartView.topAnchor.constraint(equalTo: self.pieChartBackgroundView.topAnchor, constant: 10),
            
            // MARK: - barChartStackView Layout
            barChartStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 24),
            barChartStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -24),
            barChartStackView.heightAnchor.constraint(equalToConstant: 240),
            barChartStackView.topAnchor.constraint(equalTo: self.pieChartStackView.bottomAnchor, constant: 10),
            
            // MARK: - barChartView Layout
            barChartTitleView.heightAnchor.constraint(equalToConstant: 35),
            
            barChartTitleLabel.centerXAnchor.constraint(equalTo: self.barChartTitleView.centerXAnchor),
            barChartTitleLabel.centerYAnchor.constraint(equalTo: self.barChartTitleView.centerYAnchor)
        ])
    }
}
