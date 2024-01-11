//
//  ServerPushViewController.swift
//  FirebaseLearnProject
//
//  Created by sookim on 1/10/24.
//

import UIKit
import SnapKit
import Then

class ServerPushViewController: UIViewController {
    
    lazy private var messageLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.text = "해당 텍스트에 알림메시지가 표시됩니다."
        $0.textAlignment = .center
        $0.textColor = .systemGreen
        $0.backgroundColor = .systemGray5
        $0.numberOfLines = 0

        view.addSubview($0)
    }

    lazy private var permissionButton = UIButton().then {
        $0.backgroundColor = .systemGray5
        $0.setTitle("알림권한", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.setTitleColor(.systemRed, for: .highlighted)
        $0.addTarget(self, action: #selector(touchedPermissionButton), for: .touchUpInside)

        view.addSubview($0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        self.title = "원격 알림(APNs Push)"

        self.setupConstarints()
    }

    private func setupConstarints() {
        permissionButton.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(50)
            make.center.equalToSuperview()
        }

        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(permissionButton.snp.bottom).offset(25)
            make.leading.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
    }

    @objc private func touchedPermissionButton() {
        // alert - 알림이 화면에 노출
        // sound - 소리
        // badge - 빨간색 동그라미 숫자
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge],
            completionHandler: { (granted, error) in
                print("granted notification, \(granted)")
            }
        )
    }

}
