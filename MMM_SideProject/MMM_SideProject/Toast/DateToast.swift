//
//  DateToast.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 3/10/25.
//

import UIKit
import RxSwift
import RxCocoa

class DateToastView : UIViewController {
    
    // TODO: - ViewModel을 받아서 DatePicker가 변경될 때마다 Date를 전달할 수 있도록 하자.
    var viewModel : CreateViewModelInterface!
    var disposeBag : DisposeBag = .init()
    
    init(viewModel: CreateViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("CreateViewController DataToastView - Initializer 에러")
    }
    
    lazy var tempView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.mainColor.cgColor
        return view
    }()
    
    let datePicker : UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ko_KR")
        return picker
    }()
    
    lazy var buttonStackView : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [agreeButton, cancelButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fillEqually
        return sv
    }()
    
    lazy var agreeButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("확인", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.setTitleColor(.blackColor, for: .normal)
        return button
    }()
    
    lazy var cancelButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("취소", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.setTitleColor(.blackColor, for: .normal)
        return button
    }()
    
    @objc func buttonTapped() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        setLayout()
        setReactive()
    }
    
    func setLayout() {
        view.addSubview(tempView)
        tempView.addSubview(datePicker)
        tempView.addSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            tempView.widthAnchor.constraint(equalToConstant: 350),
            tempView.heightAnchor.constraint(equalToConstant: 300),
            tempView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            tempView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            datePicker.centerXAnchor.constraint(equalTo: self.tempView.centerXAnchor),
            datePicker.topAnchor.constraint(equalTo: self.tempView.topAnchor, constant: 20),
            
            buttonStackView.heightAnchor.constraint(equalToConstant: 35),
            buttonStackView.leadingAnchor.constraint(equalTo: self.tempView.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: self.tempView.trailingAnchor),
            buttonStackView.topAnchor.constraint(equalTo: self.datePicker.bottomAnchor, constant: 15)
        ])
    }
    
    func setReactive() {
        // MARK: - Date를 설정할 때마다 Date를 추적하는 스트림
        datePicker.rx.date
            .observe(on: MainScheduler.instance)
            .map {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let formattedDate = dateFormatter.string(from: $0)
                return formattedDate
            }
            .bind(to: viewModel.stringDateObserver)
            .disposed(by: disposeBag)
    }
}
