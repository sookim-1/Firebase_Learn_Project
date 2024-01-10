//
//  LocalPushViewController.swift
//  FirebaseLearnProject
//
//  Created by sookim on 1/10/24.
//

import UIKit

class LocalPushViewController: UIViewController {

    lazy private var permissionButton = UIButton().then {
        $0.backgroundColor = .systemGray5
        $0.setTitle("알림권한", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.setTitleColor(.systemRed, for: .highlighted)
        $0.addTarget(self, action: #selector(touchedPermissionButton), for: .touchUpInside)
        view.addSubview($0)
    }

    lazy private var requestButton = UIButton().then {
        $0.backgroundColor = .systemGray5
        $0.setTitle("LocalPush 발송", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.setTitleColor(.systemRed, for: .highlighted)
        $0.addTarget(self, action: #selector(requestNoti), for: .touchUpInside)
        view.addSubview($0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        self.title = "로컬 알림(Local Push)"
        self.setupConstraints()
    }

    private func setupConstraints() {
        permissionButton.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(50)
            make.center.equalToSuperview()
        }

        requestButton.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(50)
            make.top.equalTo(permissionButton.snp.bottom).offset(25)
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

    @objc private func requestNoti() {
        // 컨텐츠 생성
        let content = UNMutableNotificationContent()
        content.title = "노티 (타이틀)"
        content.body = "노티 (바디)"
        content.badge = 1

        // 사운드 옵션
        content.sound = .default

        // 트리거 생성 - 0초로 설정시 오류
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)

        // pushID가 같은 경우 다시보내면 덮어씌어지고 pushID가 다른 경우 보내면 새로운 push생성
        let pushID = "Local Noti Test"

        let request = UNNotificationRequest(
            identifier: pushID,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current()
            .add(request) { error in
                guard let error = error else { return }
                print(error.localizedDescription)
            }
    }

}
