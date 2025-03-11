//
//  graphDateToast.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 3/11/25.
//

import UIKit
import RxSwift
import RxCocoa

class graphDateToastView : UIViewController {
    
    var viewModel : GraphViewModelInterface
    var disposeBag : DisposeBag = .init()
    
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
        label.font = UIFont(size: 18.0)
        label.text = "월 선택하기"
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
        setTableView()
        setLayout()
        setAnimation()
        setReactive()
    }
    
    lazy var mainViewHeightAnchor = mainView.heightAnchor.constraint(equalToConstant: 550)
    lazy var mainViewBottomAnchor = mainView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 400)
    
    func setTableView() {
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
        tableView.register(DateTableViewCell.self, forCellReuseIdentifier: DateTableViewCell.identifier)
    }
    
    func setLayout() {
        view.addSubview(mainView)
        mainView.addSubview(headerStackView)
        mainView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            mainView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            
            mainViewHeightAnchor,
            mainViewBottomAnchor,
            
            headerStackView.leadingAnchor.constraint(equalTo: self.mainView.leadingAnchor, constant: 15),
            headerStackView.trailingAnchor.constraint(equalTo: self.mainView.trailingAnchor),
            headerStackView.topAnchor.constraint(equalTo: self.mainView.topAnchor),
            headerStackView.heightAnchor.constraint(equalToConstant: 55),
            
            headerLabel.leadingAnchor.constraint(equalTo: self.headerStackView.leadingAnchor),
            headerLabel.centerYAnchor.constraint(equalTo: self.headerStackView.centerYAnchor),
            
            headerButton.trailingAnchor.constraint(equalTo: self.headerStackView.trailingAnchor),
            headerButton.centerYAnchor.constraint(equalTo: self.headerStackView.centerYAnchor),
            headerButton.widthAnchor.constraint(equalToConstant: 30),
            
            tableView.leadingAnchor.constraint(equalTo: self.mainView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.mainView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.mainView.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: self.headerStackView.bottomAnchor)
        ])
    }
    
    func setAnimation() {
        self.mainViewBottomAnchor.constant -= 420
        UIView.animate(withDuration: 0.3) {
            self.mainView.layoutIfNeeded() // 레이아웃 업데이트가 애니메이션되도록 함
        }
    }
    
    func setReactive() {
        // MARK: - DateList Cell 바인딩
        viewModel.dateListObservable
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: DateTableViewCell.identifier, cellType: DateTableViewCell.self)) { (index, item, cell) in
                cell.configure(dateStr: item)
            }.disposed(by: disposeBag)
        
        // MARK: - Dismiss 버튼 탭 바인딩
        headerButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                removeView()
            }.disposed(by: disposeBag)
        
        // MARK: - Cell Index 클릭 바인딩
        tableView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] indexPath in
                guard let self = self else { return }
                guard let indexPath = indexPath.element else { return }
                guard let cellData = tableView.cellForRow(at: indexPath) as? DateTableViewCell, let dateStr = cellData.dateLabel.text else { return }
                viewModel.selectDateObserver.onNext(dateStr)
                removeView()
            }.disposed(by: disposeBag)
    }
    
    func removeView() {
        // TODO: - 사라지는 애니메이션 추가
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
