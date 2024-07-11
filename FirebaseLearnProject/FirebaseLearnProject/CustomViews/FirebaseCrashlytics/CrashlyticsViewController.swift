//
//  CrashlyticsViewController.swift
//  FirebaseLearnProject
//
//  Created by sookim on 1/18/24.
//

import UIKit
import SnapKit
import Then
import FirebaseCrashlytics

class CrashlyticsViewController: UIViewController {

    lazy private var buttonStackView = UIStackView(arrangedSubviews: [crashButton, crashLogButton]).then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.spacing = 10
        view.addSubview($0)
    }

    lazy private var crashButton = UIButton().then {
        $0.backgroundColor = .systemGray5
        $0.setTitle("Crash 발생", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.setTitleColor(.systemRed, for: .highlighted)
        $0.addTarget(self, action: #selector(touchedCrashButton), for: .touchUpInside)
    }

    lazy private var crashLogButton = UIButton().then {
        $0.backgroundColor = .systemGray5
        $0.setTitle("Crash 로그 수집", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.setTitleColor(.systemRed, for: .highlighted)
        $0.addTarget(self, action: #selector(touchedCrashLogButton), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        self.title = "Crashlytics (충돌 로그 수집)"
        self.setupConstraints()
    }
    
    private func setupConstraints() {
        buttonStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.center.equalToSuperview()
        }

        crashButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }

    @objc private func touchedCrashButton() {
        let numbers = [0]
        let _ = numbers[1]
    }

    @objc private func touchedCrashLogButton() {

        /// Custom Key 추가
        // Set int_key to 100.
        Crashlytics.crashlytics().setCustomValue(100, forKey: "int_key")

        // Set str_key to "hello".
        Crashlytics.crashlytics().setCustomValue("hello", forKey: "str_key")

        let keysAndValues = [
                         "string key" : "string value",
                         "string key 2" : "string value 2",
                         "boolean key" : true,
                         "boolean key 2" : false,
                         "float key" : 1.01,
                         "float key 2" : 2.02
                        ] as [String : Any]

        Crashlytics.crashlytics().setCustomKeysAndValues(keysAndValues)

        /// Custom Log Message
        Crashlytics.crashlytics().log("로그 시작")
        Crashlytics.crashlytics().log(format: "%@, %@", arguments: getVaList(["Higgs-Boson detected! Bailing out…", ""]))
        
        Crashlytics.crashlytics().setUserID("152")

        let userInfo = [
          NSLocalizedDescriptionKey: NSLocalizedString("The request failed.", comment: ""),
          NSLocalizedFailureReasonErrorKey: NSLocalizedString("The response returned a 404.", comment: ""),
          NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString("Does this page exist?", comment: ""),
          "ProductID": "123456",
          "View": "MainView"
        ]

        let error = NSError.init(domain: NSCocoaErrorDomain,
                                 code: -1001,
                                 userInfo: userInfo)

        Crashlytics.crashlytics().record(error: error)
    }

}
