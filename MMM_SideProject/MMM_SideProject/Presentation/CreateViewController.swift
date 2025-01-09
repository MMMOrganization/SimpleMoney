//
//  CreateViewController.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 12/28/24.
//

import UIKit

class CreateViewController: UIViewController {

    lazy var topStackView : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [expendButton, incomeButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .fill
        sv.spacing = 0
        return sv
    }()
    
    let expendButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("지출", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.backgroundColor = .white
        button.setTitleColor(.blackColor, for: .normal)
        button.layer.shouldRasterize = false
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    let incomeButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("수입", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.backgroundColor = .white
        button.setTitleColor(.blackColor, for: .normal)
        button.layer.shouldRasterize = false
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    let dateButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("2024.12.04. 월요일", for: .normal)
        button.setBackgroundColor(UIColor(hexCode: ColorConst.mainColorString, alpha: 0.20), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.setTitleColor(.blackColor, for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    let expendTypeLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "기타"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .grayColor
        return label
    }()
    
    let inputMoneyTextField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.text = "120,000원"
        tf.keyboardType = .numberPad
        tf.textAlignment = .center
        tf.font = UIFont(size: 35)
        tf.textColor = .blackColor
        tf.tintColor = .clear
        // 키보드 올라오게 해야 함.
        // 커서 땠을 때 원 표시되어야 함.
        // , 적용되어야 함.
        return tf
    }()
    
    let separatorLine : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexCode: ColorConst.mainColorString, alpha: 0.70)
        return view
    }()
    
    let iconConstLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "아이콘"
        label.textColor = .blackColor
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    let iconCollectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        //let tempWidth = (UIScreen.main.bounds.width - 15 * 3) / 4
        
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: 71, height: 71)
        flowLayout.minimumInteritemSpacing = 23 // 아이템 사이 간격
        flowLayout.minimumLineSpacing = 20 // 줄 간격
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setCollectionView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dateButton.layer.cornerRadius = dateButton.frame.height / 2
        expendButton.layer.addBorder([.bottom])
    }
    
    func setCollectionView() {
        iconCollectionView.dataSource = self
        iconCollectionView.delegate = self
        
        iconCollectionView.register(CreateCollectionViewCell.self, forCellWithReuseIdentifier: CreateCollectionViewCell.identifier)
    }
    
    func setLayout() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.scrollEdgeAppearance =
        navigationController?.navigationBar.standardAppearance
        view.backgroundColor = .white
        
        view.addSubview(topStackView)
        view.addSubview(dateButton)
        view.addSubview(expendTypeLabel)
        view.addSubview(inputMoneyTextField)
        view.addSubview(separatorLine)
        view.addSubview(iconConstLabel)
        view.addSubview(iconCollectionView)
        
        NSLayoutConstraint.activate([
            // MARK: - 지출 수입 버튼 Layout
            expendButton.heightAnchor.constraint(equalToConstant: 35),
            incomeButton.heightAnchor.constraint(equalToConstant: 35),
            
            // MARK: - topStackView Layout
            topStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            topStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            topStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            // MARK: - dateButton Layout
            dateButton.topAnchor.constraint(equalTo: self.topStackView.bottomAnchor, constant: 15),
            dateButton.widthAnchor.constraint(equalToConstant: 200),
            dateButton.heightAnchor.constraint(equalToConstant: 30),
            dateButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            // MARK: - expendTypeLabel Layout
            expendTypeLabel.topAnchor.constraint(equalTo: self.dateButton.bottomAnchor, constant: 15),
            expendTypeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            // MARK: - inputMoneyTextField Layout
            inputMoneyTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            inputMoneyTextField.topAnchor.constraint(equalTo: self.expendTypeLabel.bottomAnchor, constant: 15),
            
            // MARK: - separatorLine Layout
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            separatorLine.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            separatorLine.topAnchor.constraint(equalTo: self.inputMoneyTextField.bottomAnchor, constant: 25),
            
            // MARK: - iconConstLabel Layout
            iconConstLabel.topAnchor.constraint(equalTo: self.separatorLine.bottomAnchor, constant: 10),
            iconConstLabel.leadingAnchor.constraint(equalTo: self.separatorLine.leadingAnchor, constant: 15),
            
            // MARK: - iconCollectionView Layout
            iconCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            iconCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            iconCollectionView.topAnchor.constraint(equalTo: self.iconConstLabel.bottomAnchor, constant: 10),
            iconCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
    }
}

extension CreateViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = iconCollectionView.dequeueReusableCell(withReuseIdentifier: CreateCollectionViewCell.identifier, for: indexPath) as! CreateCollectionViewCell
        
        cell.contentView.clipsToBounds = true
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.backgroundColor = UIColor(hexCode: ColorConst.grayColorString, alpha: 0.20)
        
        return cell
    }
}
