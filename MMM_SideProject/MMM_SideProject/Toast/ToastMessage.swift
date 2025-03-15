import UIKit

class ToastManager {
    
    static let shared = ToastManager()
    
    private init() {}
    
    func showToast(message: String, duration: TimeInterval = 3.0) {
        // 메인 스레드에서 실행되도록 보장
        DispatchQueue.main.async {
            // keyWindow 또는 현재 활성화된 window 찾기
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
                return
            }
            
            // 기존 토스트가 있다면 제거
            window.subviews.filter({ $0.tag == 9999 }).forEach({ $0.removeFromSuperview() })
            
            // 토스트 컨테이너 생성
            let toastContainer = UIView()
            toastContainer.tag = 9999
            toastContainer.backgroundColor = UIColor.mainColor.withAlphaComponent(0.2)
            toastContainer.alpha = 0.0
            toastContainer.layer.cornerRadius = 15
            toastContainer.clipsToBounds = true
            
            // 토스트 메시지 레이블
            let toastLabel = UILabel()
            toastLabel.textColor = UIColor.white
            toastLabel.textAlignment = .center
            toastLabel.font = UIFont.systemFont(ofSize: 14)
            toastLabel.text = message
            toastLabel.clipsToBounds = true
            toastLabel.numberOfLines = 0
            
            // 뷰 계층 구조 설정
            toastContainer.addSubview(toastLabel)
            window.addSubview(toastContainer)
            
            // 레이아웃 설정
            toastContainer.translatesAutoresizingMaskIntoConstraints = false
            toastLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let safeAreaBottom: NSLayoutYAxisAnchor
            if #available(iOS 11.0, *) {
                safeAreaBottom = window.safeAreaLayoutGuide.bottomAnchor
            } else {
                safeAreaBottom = window.bottomAnchor
            }
            
            NSLayoutConstraint.activate([
                toastContainer.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 20),
                toastContainer.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -20),
                toastContainer.bottomAnchor.constraint(equalTo: safeAreaBottom, constant: -20),
                
                toastLabel.leadingAnchor.constraint(equalTo: toastContainer.leadingAnchor, constant: 15),
                toastLabel.trailingAnchor.constraint(equalTo: toastContainer.trailingAnchor, constant: -15),
                toastLabel.topAnchor.constraint(equalTo: toastContainer.topAnchor, constant: 10),
                toastLabel.bottomAnchor.constraint(equalTo: toastContainer.bottomAnchor, constant: -10)
            ])
            
            // 애니메이션 설정
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                toastContainer.alpha = 1.0
            }, completion: { _ in
                UIView.animate(withDuration: 0.3, delay: duration, options: .curveEaseOut, animations: {
                    toastContainer.alpha = 0.0
                }, completion: { _ in
                    toastContainer.removeFromSuperview()
                })
            })
        }
    }
}
