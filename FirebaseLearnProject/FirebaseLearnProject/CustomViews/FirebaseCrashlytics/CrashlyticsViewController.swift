//
//  CrashlyticsViewController.swift
//  FirebaseLearnProject
//
//  Created by sookim on 1/18/24.
//

import UIKit
import SnapKit
import Then

class CrashlyticsViewController: UIViewController {

    lazy private var crashButton = UIButton().then {
        $0.backgroundColor = .systemGray5
        $0.setTitle("Crash 발생", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.setTitleColor(.systemRed, for: .highlighted)
        $0.addTarget(self, action: #selector(touchedCrashButton), for: .touchUpInside)
        view.addSubview($0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        self.title = "Crashlytics (충돌 로그 수집)"
        self.setupConstraints()
    }
    
    private func setupConstraints() {
        crashButton.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(50)
            make.center.equalToSuperview()
        }
    }

    @objc private func touchedCrashButton() {
        fatalError("Crash 버튼 클릭")
    }

}
